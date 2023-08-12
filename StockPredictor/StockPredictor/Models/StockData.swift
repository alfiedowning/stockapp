//
//  StockData.swift
//  StockPredictor
//
//  Created by Alfie Downing on 18/07/2023.
//

import Foundation

class StockData: Identifiable {
    var id = UUID()
    var stock: Stock
    var prices: [StockPrice]
    
    
    init(stock: Stock, prices: [StockPrice]) {
        self.stock = stock
        self.prices = prices
    }
    
}
