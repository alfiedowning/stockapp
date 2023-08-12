import yahoo_fin.stock_info as si
from datetime import date
import pandas as pd
import concurrent.futures
from flask import Flask, jsonify

today = date.today()
currentDate = today.strftime("%Y-%m-%d")
end_dates = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31] # Index = Month - 1

def is_leap_year(year):
    # Leap year occurs every 4 years, except for multiples of 100 that are not multiples of 400
    return year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)

def getPrevDate(currentDate, timeFrame):
    """
    :param currentDate: the current date in the form "yyyy-mm-dd"
    :param timeFrame: the time frame for the data - how far to go back: ["1wk", "1mo", "6mo", "1y"]
    :return: previous date in the form "yyyy-mm-dd"
    """
    year, month, day = map(int, currentDate.split('-'))
    if timeFrame == "1wk":
        # Need to get date for a week ago
        if day <= 7:
            # Previous month, need to check if previous year as well
            if month == 1:
                year -= 1
                month = 13
            month -= 1
            prevMonthEndDate = end_dates[month-1]
            day = prevMonthEndDate - (7 - day)

            if month == 2 and is_leap_year(year):
                prevMonthEndDate += 1  # February has 29 days in a leap year
        else:
            day -= 7
    elif timeFrame == "1mo":
        # Need to get date for a month ago
        if month == 1:
            year -= 1
            month = 13
        month -= 1
        if day > end_dates[month-1]:
            day = end_dates[month-1]
    elif timeFrame == "6mo":
        # Need to get date for 6 months ago
        difference = month - 6
        if difference <= 0:
            month = 12 - abs(difference)
            year -= 1
        else:
            month = difference

        if day > end_dates[month-1]:
            day = end_dates[month-1]
    elif timeFrame=='1y':
        # Need to get date for 1 year ago
        year -= 1
    else:
        year -= 2
    return f"{month:02d}/{day:02d}/{year:04d}"

def fetch_price_data_for_time_frame(symbol, timeFrame, interval):
    p = si.get_data(symbol, start_date=getPrevDate(currentDate, timeFrame), end_date=currentDate, interval=interval)
    date_formats = {'1wk':'%d','1mo':'%m/%d', '6mo': '%m', '1y':'%m%d', '2y':'%m/%y'}
    p['date'] = p.index.strftime(date_formats[timeFrame])
    if timeFrame == '2y':
        p = p[::3] # remove rows with an odd index
    if timeFrame == '1y':
        p = p[::6]
    p = p.reset_index()
    p['id'] = p.index
    p = p.drop(columns=['index', 'high','low', 'ticker','volume','adjclose','open'])
    return p.to_dict(orient='records')

def getStocksData(batch_size=10):
    dow_list = si.tickers_dow(include_company_data=True)
   # dow_list = dow_list.iloc[:]
    dow_list['id'] = dow_list.index
    dow_list = dow_list.drop(columns=['Date added', 'Notes', 'Index weighting'])
    dow_list.rename(columns={"Company":"company", "Exchange":"exchange", "Symbol" : "symbol", "Industry":"industry"}, inplace=True)
    dow_list = dow_list.to_dict(orient='records')
    timeFrames = {"1wk": "1d", "1mo": "1wk", "6mo": "1mo", "1y":"1wk","2y":"1mo"}

    def process_stock(stock):
        quote_table = si.get_quote_table(stock['symbol'], dict_result=False)
        attributes_to_remove = ['1y Target Est', 'Ask', 'Avg. Volume', 'Bid', "Day's Range", 'Ex-Dividend Date',
                                "Forward Dividend & Yield", "Quote Price", "Earnings Date"]
        data = quote_table[~quote_table['attribute'].isin(attributes_to_remove)].copy()
        data.replace({'52 Week Range': 'range', 'Beta (5Y Monthly)': 'beta', 'EPS (TTM)': 'eps', 'Market Cap': 'mktCap','Open': 'open', 'PE Ratio (TTM)': 'peRatio', 'Previous Close': 'prevClose', 'Volume': 'volume'},
                     inplace=True)
        data = data.fillna(0.0)
        metric_dict = {row['attribute']: row['value'] for _, row in data.iterrows()}
        stock['metrics'] = metric_dict

        currentPrice = si.get_live_price(stock['symbol'])
        stock['currentPrice'] = round(currentPrice, 2)
        priceArr = []
        for timeFrame in timeFrames:
            price_data = fetch_price_data_for_time_frame(stock['symbol'], timeFrame, timeFrames[timeFrame])
            priceArr.append(price_data)  # Associate the price data with the time frame
        stock['prices'] = priceArr

    with concurrent.futures.ThreadPoolExecutor() as executor:
        for row in dow_list:
            executor.submit(process_stock, row)
    return dow_list

app = Flask("stock-info")

@app.route('/', methods=['GET'])
def hello():
    stockData = getStocksData()
    return jsonify({"stocks": stockData})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)


