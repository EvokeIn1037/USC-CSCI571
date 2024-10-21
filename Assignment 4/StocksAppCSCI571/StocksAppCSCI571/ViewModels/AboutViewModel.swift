//
//  AboutViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/30/24.
//

import Foundation
import SwiftUI

class AboutViewModel: ObservableObject {
    @Published var aboutInfo: SummaryData = SummaryData(h: 0.0, l: 0.0, o: 0.0, pc: 0.0, ipo: "", finnhubIndustry: "", weburl: "", peers: [])
    let apiUrlBase = "https://assignment-3-419113.wl.r.appspot.com/api/"
    @Published var loaded: Bool = false
    
    func getSummary(for ticker: String) async {
        let url = apiUrlBase + "summary?param=" + ticker
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
                    let decodedData = try JSONDecoder().decode(SummaryData.self, from: data)
                    DispatchQueue.main.async {
                        self.aboutInfo = decodedData
                        self.loaded = true
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}
