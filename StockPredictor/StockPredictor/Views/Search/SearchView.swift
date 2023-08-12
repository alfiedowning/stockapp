//
//  SearchView.swift
//  StockPredictor
//
//  Created by Alfie Downing on 02/08/2023.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var model: StockManager
    @State private var searchedText: String=""
    @State private var isShowing: Bool = false
    let stocks = [String]()
    var body: some View {
        VStack(alignment:
                .leading) {
            
            HStack{
                Text("Search")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding([.leading, .top],20)
        
            NavigationStack {
                
                
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(alignment: .leading, spacing:25) {
                        
                        ForEach(searchResults) { stock in
                            
                            Button {
                                model.currentStock = stock
                                isShowing.toggle()
                            } label: {
                                SingleStockListView(isShowing: $isShowing, stock: stock)
                                
                            }
                            
                            
                            
                        }
                        
                    }
                    
                }
                .searchable(text: $searchedText)
                .fullScreenCover(isPresented: $isShowing) {
                    StockAnalysisView(isShowing: $isShowing)
                }
                
            }
            
        }
    }
    
    var searchResults: [Stock] {
        if searchedText.isEmpty {
            return model.stocks
        } else {
            return model.stocks.filter { stock in
                stock.symbol.lowercased().contains(searchedText.lowercased()) || stock.company.lowercased().contains(searchedText.lowercased())
                ||  stock.industry.lowercased().contains(searchedText.lowercased()) ||  stock.exchange.lowercased().contains(searchedText.lowercased())
            }
        }
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
