//
//  ContentView.swift
//  StockPredictor
//
//  Created by Alfie Downing on 11/07/2023.
//

import SwiftUI
import Charts
import Foundation


struct Month: Identifiable {
    var id = UUID()
    var month: String
    var price: Double
    
}



struct HomeView: View {
    @EnvironmentObject var model: StockManager
    @State private var isShowing = false
    
    var body: some View {
        
        TabView {
            
           AllStockListView()
                .tabItem {
                Label("Home", systemImage: "house")
                }
            
            WatchlistView()
                .tabItem {
                Label("Watchlist", systemImage: "star")
                }
            
            
            
        }
        
        
        
        
        
        
        }
        
        
        
        
    }
    
    
    

        
        
    

        
    
    









struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(StockManager())
    }
}


struct StockImage: View {
    let symbol: String
    let name: String
    var body: some View {
        ZStack {
            
            Rectangle()
                .foregroundColor(.secondary.opacity(0.3))
                .cornerRadius(15)
                .frame(width:40, height:40)
            
            Image("aapl")
            
        
        }
        
        
    }
}
