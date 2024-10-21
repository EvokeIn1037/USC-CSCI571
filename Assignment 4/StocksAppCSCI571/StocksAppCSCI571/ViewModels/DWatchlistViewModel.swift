//
//  DWatchlistViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import Foundation
import SwiftUI

class DWatchlistViewModel: ObservableObject {
    @Published var watchlistInfo: [DWatchlistData] = []
    @Published var exist = -1
    let apiUrlBase = "https://assignment-3-419113.wl.r.appspot.com/api/fetchContent?param=1"
    @Published var loaded: Bool = false
    
    func getWatchInfo(for ticker: String) async {
        let url = "https://assignment-3-419113.wl.r.appspot.com/api/fetchContent?param=1"
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
                    let decodedData = try JSONDecoder().decode([DWatchlistData].self, from: data)
                    DispatchQueue.main.async {
                        self.watchlistInfo = decodedData
                        let size = self.watchlistInfo.count
                        var i = 0
                        while i < size {
                            if self.watchlistInfo[i].ticker == ticker {
                                self.exist = i
                            }
                            i = i + 1
                        }
                        self.loaded = true
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}
