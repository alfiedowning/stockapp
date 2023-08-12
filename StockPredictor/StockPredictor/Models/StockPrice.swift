//
//  StockPrice.swift
//  StockPredictor
//
//  Created by Alfie Downing on 18/07/2023.
//

import Foundation


let months = [
    "01" : "Jan",
    "02":"Feb",
    "03":"Mar",
    "04":"Apr",
    "05":"May",
    "06":"Jun",
    "07":"Jul",
    "08":"Aug",
    "09":"Sep",
    "10":"Oct",
    "11":"Nov",
    "12":"Dec"
]


func setDate(date: String) -> String {
    

    
    if date.count > 0 {
        let start = date.startIndex
        let end = date.index(start, offsetBy: 2)
        let month = date[start..<end]
        
        return months[String(month)]!

    }
    
    return ""
    
}


class StockPrice: Identifiable, Decodable {
    let close: Double
    var date: String
    let id: Int
    
    init(close: Double, date: String, id: Int) {
        self.close = close
        self.date = date
        self.id = id
        
        
    }

    
}
    
