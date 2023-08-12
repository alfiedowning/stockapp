//
//  Stock.swift
//  StockPredictor
//
//  Created by Alfie Downing on 16/07/2023.
//

import Foundation

class Metrics: Decodable {
    let beta: Double
    let eps: Double
    let mktCap: String
    let open: Double
    let peRatio: Double
    let prevClose: Double
    let range: String
    let volume: Double
    
    init(beta: Double, eps: Double, mktCap: String, open: Double, peRatio: Double, prevClose: Double, range: String, volume: Double) {
        self.beta = beta
        self.eps = eps
        self.mktCap = mktCap
        self.open = open
        self.peRatio = peRatio
        self.prevClose = prevClose
        self.range = range
        self.volume = volume
        
    }

    
}
class Stock: Decodable, Identifiable {
    let company: String
    let currentPrice: Double
    let exchange: String
    let id: Int
    let industry: String
    let metrics: Metrics
    var prices: [[StockPrice]]
    let symbol: String
    

    init(company: String, currentPrice: Double, exchange: String, id: Int, industry: String, metrics: Metrics, prices: [[StockPrice]], symbol: String) {
        self.company = company
        self.currentPrice = currentPrice
        self.exchange = exchange
        self.id = id
        self.industry = industry
        self.metrics = metrics
        self.prices = prices
        self.symbol = symbol
    }
    
    
    
    func getMetric(metric: String) -> String {
        if self.prices.count>1 {
                
            switch metric {
                case "Beta":
                    return String(metrics.beta)
                case "EPS":
                    return String(metrics.eps)
                case "Market Cap":
                    return metrics.mktCap
            case "Open":
                    return String(metrics.open)
                case "P/E":
                    return String(metrics.peRatio)
                case "Close":
                    return String(metrics.prevClose)
                case "52 Range":
                    return metrics.range
                case "Volume":
                    return String(Int(metrics.volume))
                default:
                    return ""
                }
            
            
                        
                        
                        
                        
        }
        
        return ""
        

    }
    
    
    func calcPriceChange() -> Double {
        let price: Double = ((self.prices[0][self.prices[0].count-1].close - self.prices[0][self.prices[0].count-2].close)/(self.prices[0][self.prices.count-2].close))*100

        return price
    }
    
    func getPriceDirection() -> String {
        print(self.prices[0].count)
        
        if self.prices[0].count > 0 {
            
            let direction = self.prices[0][self.prices[0].count-1].close >= self.prices[0][self.prices[0].count-2].close ? "+" : ""
            return direction

        }
        return ""
    }
    }
    
    




struct Stocks: Decodable {
    let stocks: [Stock]
}
