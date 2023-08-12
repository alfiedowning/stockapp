//
//  StockAnalysisView.swift
//  StockPredictor
//
//  Created by Alfie Downing on 15/07/2023.
//

import SwiftUI
import Charts

struct StockAnalysisView: View {
    @EnvironmentObject var model: StockManager
    @Binding var isShowing: Bool
    @State private var selectedPeriod: String = "1W"
    let periods: [String] = ["1W", "1M","6M","1Y","2Y"]
    let allMetrics: [String] = ["Beta", "EPS", "Market Cap","Open","P/E","Close","52 Range","Volume"]
    
    var gridItems: [GridItem] = Array(repeating: GridItem(.adaptive(minimum: 100)), count: 2)
    
    var body: some View {
        
        VStack (spacing:20){
            
            
            ZStack(alignment: .leading){
                HStack {
                    
                    
                    Button {
                        isShowing.toggle()
                        
                    } label: {
                        Circle()
                            .frame(width:30,height:30)
                            .overlay {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                            }
                            .foregroundColor(.gray.opacity(0.4))
                    }
                  

                   
                    
                    Spacer()
                    
                    Text("View Stock Insights")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                    
                    Button {
                        
                        if let existingIndex = model.watchList.firstIndex(where: { stock in
                                stock.company == model.currentStock.company
                            }) {
                                model.watchList.remove(at: existingIndex)
                            } else {
                                model.watchList.append(model.currentStock)
                            }
                        
                        
                        
                        
                        
                        
                    } label: {
                                Image(systemName: model.watchList.contains(where: { stock in
                                    stock.company == model.currentStock.company
                                }) ? "star.fill" : "star")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.yellow)
                                
                                .frame(width:25,height:25)

                    }
                    
                    
                    
                    
                    
                }
                
            }
                
            
            ZStack {
                
                Rectangle()
                    .foregroundColor(.green.opacity(0.2))
                    .cornerRadius(15)
                
                    .frame(height:160)
                    .overlay {
                        VStack(alignment:.leading,spacing: 15){
                            
                            HStack(spacing:27) {
                                
//                                StockImage(symbol: stock.symbol.lowercased(), name: stock.company)
                                
                                
                                VStack(alignment:.leading) {
                                    Text(model.currentStock.symbol)
                                        .font(.title3)
                                        .bold()
                                    Text(model.currentStock.company)
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                }
                                
                                
                                
                                Spacer()
                                

                                
                                
                            }
                            
                            Divider()
                            
                            HStack{
                                VStack(alignment: .leading, spacing:7) {
                                    
                                    Text("Industry")
                                        .foregroundColor(.secondary)
                                    
                                    Text(model.currentStock.industry)
                                        .foregroundColor(.green)
                                    
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing:7) {
                                    
                                    Text("Index")
                                        .foregroundColor(.secondary)
                                    
                                    Text(model.currentStock.exchange)
                                        .foregroundColor(.green)
                                    
                                }
                                
                                Spacer()
                                
                            }
                            
                            
                            

                            
                            Spacer()
                        }
                        .padding(.all,20)
                        .padding(.top,20)
                    }
                
                
                
   
                
                
            }
            
            VStack(alignment:.leading){
                HStack {
                    Text("Price Graph")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                }
                
                
                
                VStack {
                    
                    Picker("Time Period", selection: $selectedPeriod) {
                        
                        ForEach(periods, id: \.self) { period in
                            Text(period)
                        }
                        
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    
                    
                    GraphView(stock: model.currentStock, selectedPeriod: $selectedPeriod)
                        .frame(height: 220)

                    
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            }
            
            
            
            
            
            
            VStack(alignment:.leading){
                HStack {
                    Text("Metrics")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    
                }
                
                ScrollView(showsIndicators:false) {
                    
                    LazyVGrid(columns: gridItems) {
                        
                        ForEach(allMetrics, id: \.self) { metric in
                            
                        
                            Rectangle()
                                .foregroundColor(.green.opacity(0.2))
                                .cornerRadius(15)
                            
                                .frame(height:100)
                                .overlay {
                                    
                                    VStack(alignment:.leading,spacing:15) {
                                        
                                        HStack {
                                            
                                            Text(metric)
                                                .foregroundColor(.secondary)
                                            Spacer()
                                        }
                                        
                                        Text(model.currentStock.getMetric(metric: metric))

                                        
                                        Spacer()
                                    }
                                    .padding(.all,20)
                                }
                            
                            
                            
                        }
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                
                
                
            }
            
            
            
                
            Spacer()

                
            
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .padding(.horizontal,20)
        .padding(.top,20)
        
        
    }
}

struct StockAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        StockAnalysisView(isShowing: .constant(true))
    }
    
}
