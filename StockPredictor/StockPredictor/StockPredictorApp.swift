//
//  StockPredictorApp.swift
//  StockPredictor
//
//  Created by Alfie Downing on 11/07/2023.
//

import SwiftUI

@main
struct StockPredictorApp: App {
    let manager = StockManager()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(manager)
        }
    }
}
