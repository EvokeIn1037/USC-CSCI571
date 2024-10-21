//
//  InsightsViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import Foundation
import SwiftUI

class InsightsViewModel: ObservableObject {
    @Published var insightsInfo: InsightsData = InsightsData(name: "", totalMSPR: 0.0, totalChange: 0, positiveMSPR: 0.0, positiveChange: 0, negativeMSPR: 0.0, negativeChange: 0)
    let apiUrlBase = "https://assignment-3-419113.wl.r.appspot.com/api/"
    @Published var loaded: Bool = false
    
    func getInsights(for ticker: String) async {
        let url = apiUrlBase + "insiderSentiment?param=" + ticker
        guard let apiUrl = URL(string: url) else {
            return
        }
        URLSession.shared.dataTask(with: apiUrl) {
            data, _, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(InsightsData.self, from: data)
                    DispatchQueue.main.async {
                        self.insightsInfo = decodedData
                        self.loaded = true
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}
