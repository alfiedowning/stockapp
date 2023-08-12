
//
//  StockModel.swift
//  StockPredictor
//
//  Created by Alfie Downing on 18/07/2023.
//

import Foundation


class StockManager: ObservableObject {
    @Published var stocks = [Stock]()
    @Published var currentStock = Stock(company: "", currentPrice: 0, exchange: "", id: 0, industry: "", metrics: Metrics(beta: 0, eps: 0, mktCap: "", open: 0, peRatio: 0, prevClose: 0, range: "", volume: 0), prices: [[StockPrice]](), symbol: "")
    @Published var watchList: [Stock] = [Stock]()
    init () {

        getStockData(urlString: "http://192.168.1.111:5000", completion: { fetchedStocks in
            if let safeModel = fetchedStocks {
                DispatchQueue.main.async {
                    self.stocks = safeModel
                    }
                }
            })
        }


    func getStockData(urlString: String, completion: @escaping ([Stock]?) -> Void) {
        // 1. URL
        if let url = URL(string: urlString)
        {
            // 2. URLSession
            let urlSession = URLSession(configuration: .default)
            // 3. Request
            let request = URLRequest(url: url)
            // 3. Data task
            let task = urlSession.dataTask(with: request) { data, response, error in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    return
                }
                if let safeData = data {

                    let s: Stocks = self.parseStocks(data: safeData)
                    completion(s.stocks)
                }
            }
            task.resume()
        }



    }


    func parseStocks(data: Data) -> Stocks {

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Stocks.self, from: data)

        } catch {
            print("Error parsing JSON data.\(error.localizedDescription)")

            return Stocks(stocks: [Stock]())
        }
    }



}
