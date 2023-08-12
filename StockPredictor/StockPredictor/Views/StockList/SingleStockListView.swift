//
//  AllStockView.swift
//  StockPredictor
//
//  Created by Alfie Downing on 30/07/2023.
//

import SwiftUI
import Charts

struct SingleStockListView: View {
    
    @EnvironmentObject var model: StockManager
    @Binding var isShowing: Bool
    var items: [GridItem] = Array(repeating:GridItem(.adaptive(minimum: 120)), count: 1)
    var stock: Stock = Stock(company: "", currentPrice: 0, exchange: "", id: 0, industry: "", metrics: Metrics(beta: 0, eps: 0, mktCap: "", open: 0, peRatio: 0, prevClose: 0, range: "", volume: 0), prices: [[StockPrice]](), symbol: "")
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray.opacity(0.2))
                .cornerRadius(15)
                .frame(height: 80)
                        
                HStack {
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(stock.symbol)
                                .foregroundColor(.black)
                                .font(.title3)
                                .bold()
                            
                            Text(stock.company)
                                .foregroundColor(.secondary)
                                .font(.caption)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    
                
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("$" + String(format: "%.2f", stock.currentPrice))
                            .foregroundColor(.black)
                            .bold()
                        
                        Text("\(stock.getPriceDirection())" + String(format: "%.2f", stock.calcPriceChange()) + "%")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(stock.prices[0][stock.prices.count - 1].close >= stock.prices[0][stock.prices.count - 2].close
                                ? Color.green : Color.red)
                    }
                    .padding(.trailing, 20)
                }
            
        }
        .padding(.horizontal, 20)
    

    }
}
    
struct AllStockView_Previews: PreviewProvider {
    static var previews: some View {
        SingleStockListView(isShowing: .constant(false))
            .environmentObject(StockManager())
    }
}


