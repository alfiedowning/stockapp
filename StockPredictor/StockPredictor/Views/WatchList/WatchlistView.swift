//
//  WatchListView.swift
//  StockPredictor
//
//  Created by Alfie Downing on 04/08/2023.
//

import SwiftUI
import Charts

struct WatchlistView: View {
    @EnvironmentObject var model: StockManager
    @State var isShowing: Bool = false
    @State var searchedText: String = ""
    var body: some View {
        
        VStack {
            
            HStack {
                Text("Watchlist")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding(.leading,20)

        
            if model.watchList.count == 0 {
                
                Spacer()
                
                // Empty watchlist
                VStack (spacing:30){
                    Circle()
                        .foregroundColor(.secondary.opacity(0.12))
                        .frame(width: 120,height: 120)
                        .overlay {
                            Image(systemName: "star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30,height: 30)
                            
                        }
                }
                
                VStack(spacing:10){
                    Text("You watchlist is empty.")
                        .font(.title3)
                        .bold()
                    Text("Visit home to add a stock")
                        .foregroundColor(.secondary)
                }
            }
            else {
                NavigationStack {
                    
                    ScrollView {
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing:20) {
                        
                        
                        
                        
                        ForEach(searchResults) { stock in
                            
                            Button {
                                model.currentStock = stock
                                isShowing.toggle()
                            } label: {
                                
                                Rectangle()
                                    .foregroundColor(.secondary.opacity(0.2))
                                    .cornerRadius(30)
                                    .frame(width:180,height:170)
                                
                                    .overlay {
                                        
                                        VStack {
                                            
                                            HStack {
                                                Text(stock.symbol)
                                                    .font(.title2)
                                                    .foregroundColor(.black)
                                                    .bold()
                                                Spacer()
                                            }
                                            .padding(.top,20)
                                            
                                            
                                            Spacer()
                                            
                                            
                                            if stock.prices.count > 3 {
                                                
                                                let curColour = stock.prices[3][stock.prices[3].count - 1].close >= stock.prices[3][stock.prices[3].count - 2].close
                                                ? Color(hue: 0.35, saturation: 0.8, brightness: 0.79)
                                                : Color(hue: 0.0, saturation: 0.8, brightness: 0.79)
                                                
                                                let curGradient = LinearGradient(gradient: Gradient(colors: [
                                                    curColour.opacity(0.5),
                                                    curColour.opacity(0.2),
                                                    curColour.opacity(0.05)
                                                ]), startPoint: .trailing, endPoint: .bottom)
                                                
                                                Chart(stock.prices[3]) { price in
                                                    LineMark(x: .value("Month", price.date),
                                                             y: .value("Closing Price", price.close))
                                                    .interpolationMethod(.catmullRom)
                                                    
                                                    AreaMark(x: .value("Month", price.date),
                                                             y: .value("Closing Price", price.close))
                                                    .foregroundStyle(curGradient)
                                                }
                                                .chartYAxis(.hidden)
                                                .chartXAxis(.hidden)
                                                .foregroundColor(stock.prices[3][stock.prices[3].count - 1].close >= stock.prices[3][stock.prices[3].count - 2].close
                                                                 ? Color.green : Color.red)
                                                .frame(height:60)
                                                
                                            }
                                            
                                            Spacer()
                                            
                                            
                                            HStack {
                                                
                                                Text("$" + String(format: "%.2f", stock.currentPrice))
                                                    .foregroundColor(.black)
                                                    .bold()
                                                
                                                Spacer()
                                                
                                                Text("\(stock.getPriceDirection())" + String(format: "%.2f", stock.calcPriceChange()) + "%")
                                                    .font(.subheadline)
                                                    .bold()
                                                    .foregroundColor(stock.prices[0][stock.prices.count - 1].close >= stock.prices[0][stock.prices.count - 2].close
                                                                     ? Color.green : Color.red)
                                                
                                            }
                                            
                                            
                                        }
                                        .padding(.horizontal,20)
                                        .padding(.bottom,20)
                                        
                                        
                                    }

                            }

                            
                            
                            
                            
                            
                            
                        }
                            
                        }
                   
                        
                    }
                }
            
                .searchable(text: $searchedText)
                .fullScreenCover(isPresented: $isShowing) {
                    
                } content: {
                    StockAnalysisView(isShowing: $isShowing)
                    
                }
                
            }
            
            Spacer()

            
        }
        
        var searchResults: [Stock] {
            if searchedText.isEmpty {
                return model.watchList
            } else {
                return model.watchList.filter { stock in
                    stock.symbol.lowercased().contains(searchedText.lowercased()) || stock.company.lowercased().contains(searchedText.lowercased())
                    ||  stock.industry.lowercased().contains(searchedText.lowercased()) ||  stock.exchange.lowercased().contains(searchedText.lowercased())
                }
            }
        }
        
    }
        
        
        
        
        
    
}

struct WatchListView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView()
            .environmentObject(StockManager())
    }
}
