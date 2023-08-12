//
//  GraphView.swift
//  StockPredictor
//
//  Created by Alfie Downing on 31/07/2023.
//

import SwiftUI
import Charts


struct GraphView: View {
    var stock: Stock
    @Binding var selectedPeriod: String
    let periods: [String] = ["1W", "1M","6M","1Y","2Y"]

    var body: some View {
        
        let curColour = stock.prices[periods.firstIndex(of: selectedPeriod) ?? 0][stock.prices[periods.firstIndex(of: selectedPeriod) ?? 0].count-1].close >= stock.prices[periods.firstIndex(of: selectedPeriod) ?? 0][stock.prices[periods.firstIndex(of: selectedPeriod) ?? 0].count-2].close ?         Color(hue: 0.35, saturation: 0.8, brightness: 0.79) : Color(hue: 0.0, saturation: 0.8, brightness: 0.79)
        
        let curGradient = stock.prices[periods.firstIndex(of: selectedPeriod) ?? 0][stock.prices[periods.firstIndex(of: selectedPeriod) ?? 0].count-1].close >= stock.prices[periods.firstIndex(of: selectedPeriod) ?? 0][stock.prices[periods.firstIndex(of: selectedPeriod) ?? 0].count-2].close ?
        
        LinearGradient(gradient: Gradient(colors: [
            curColour.opacity(0.5),
            curColour.opacity(0.2),
            curColour.opacity(0.05)
        ]), startPoint: .trailing, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [
                        curColour.opacity(0.5),
                        curColour.opacity(0.2),
                        curColour.opacity(0.05)
                    ]), startPoint: .trailing, endPoint: .bottom)
        
        
        VStack {
                        
            if stock.prices.count > 1 {
                
                Chart(stock.prices[periods.firstIndex(of: selectedPeriod) ?? 0]) { price in
                    
                   
                    
                        
                        LineMark(x: .value("Month", price.date),
                                 y: .value("Closing Price", price.close))
                        .symbol {
                            Circle().strokeBorder(lineWidth: 1.5)
                                .frame(width: 5,height: 5)
                        }
                        
                        AreaMark(x: .value("Month", price.date),
                                 y: .value("Closing Price", price.close))
                        .foregroundStyle(curGradient)
                        
                  
                    
                    
                    
                }
    
                    .foregroundColor(stock.prices[periods.firstIndex(of: selectedPeriod) ?? 0][stock.prices[periods.firstIndex(of: selectedPeriod) ?? 0].count-1].close >= stock.prices[periods.firstIndex(of: selectedPeriod) ?? 0][stock.prices[periods.firstIndex(of: selectedPeriod) ?? 0].count-2].close ? Color.green : Color.red)                
            }
            
        }
    }
}



struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(stock: Stock(company: "", currentPrice: 0, exchange: "", id: 0, industry: "", metrics: Metrics(beta: 0, eps: 0, mktCap: "", open: 0, peRatio: 0, prevClose: 0, range: "", volume: 0), prices: [[StockPrice]](), symbol: ""), selectedPeriod: .constant("1D"))
        
    }
}
