//
//  AllView.swift
//  StockPredictor
//
//  Created by Alfie Downing on 02/08/2023.
//

import SwiftUI

struct AllStockListView: View {
    @EnvironmentObject var model: StockManager
    var items: [GridItem] = Array(repeating:GridItem(.adaptive(minimum: 120)), count: 1)
    @State private var isShowing = false
    @State private var isSearching = false
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                VStack(alignment: .leading){
                    Text("Welcome.")
                        .font(.title)
                        .bold()
                    
                    Text("Stock Analysis")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                }
                .padding(.leading,20)
                .padding(.bottom,10)
                Spacer()
                
                Button {
                    withAnimation {
                        isSearching.toggle()
                    }
                } label: {
                    HStack {
                        Text("Search")
                        Image(systemName: "magnifyingglass")
                            .padding(.trailing,20)
                        
                    }
                }
                .sheet(isPresented: $isSearching) {
                    SearchView()
                }
                
                
                
                
                
                
            }
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing:25) {
                    
                    ForEach(model.stocks) { stock in
                        
                        Button {
                            model.currentStock = stock
                            
                            isShowing.toggle()
                            
                        } label: {
                            
                            Rectangle()
                                .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8).opacity(0.4))
                                .opacity(0.6)
                                .frame(width: 250,height: 180)
                                .cornerRadius(15)
                                .overlay {
                                    VStack(alignment:.leading,spacing:40) {
                                        
                                        VStack {
                                            HStack {
                                                
                                                VStack(alignment: .leading){
                                                    Text(stock.symbol)
                                                        .font(.title2)
                                                        .bold()
                                                        .foregroundColor(.black)
                                                    
                                                    Text(stock.company)
                                                        .font(.callout)
                                                        .foregroundColor(.secondary)
                                                    
                                                }
                                                
                                                
                                                
                                                Spacer()
                                                
                                            }
                                            
                                            Divider()
                                            
                                        }
                                        
                                        
                                        
                                        VStack {
                                            
                                            Text("$" + String(format: "%.2f", stock.currentPrice))
                                                .foregroundColor(.black)
                                            
                                        }
                                        
                                       
                                        
                                    }
                                    .padding(.horizontal,20)
                                    
                                    
                                }
                            
                            
                        }
                        .padding(.leading, stock.id == 0 ? 20 : 0)
                        .padding(.trailing, stock.id == model.stocks.count-1 ? 20 : 0)
                        .fullScreenCover(isPresented: $isShowing) {
                            
                        } content: {
                            StockAnalysisView(isShowing: $isShowing)
                            
                        }
                        
                        .sheet(isPresented: $isShowing) {
                            StockAnalysisView(isShowing: $isShowing)
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
                
                
            }
            
            
            
            
            
            HStack {
                Text("Top Stocks")
                    .font(.title3)
                    .bold()
                
                Spacer()
                Button {
                    
                    isSearching.toggle()
                    
                } label: {
                    
                    Text("See All")
                        .foregroundColor(.secondary)
                }
                
            }
            .padding(.horizontal,20)
            
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .leading, spacing:25) {
                    
                    ForEach(model.stocks) { stock in
                        
                        Button {
                            
                            isShowing.toggle()
                            model.currentStock = stock
                            
                        } label: {
                            SingleStockListView(isShowing: $isShowing, stock: stock)
                        }
                        
                    }
                    
                    
                }
                
            }
        }
    }
}

struct AllView_Previews: PreviewProvider {
    static var previews: some View {
        AllStockListView()
            .environmentObject(StockManager())
    }
}
