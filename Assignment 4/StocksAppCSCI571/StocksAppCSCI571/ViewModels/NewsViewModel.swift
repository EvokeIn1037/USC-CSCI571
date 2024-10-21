//
//  NewsViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import Foundation
import SwiftUI

class NewsViewModel: ObservableObject {
    @Published var newsInfo: [NewsData] = []
    let apiUrlBase = "https://assignment-3-419113.wl.r.appspot.com/api/"
    @Published var loaded: Bool = false
    
    func getNews(for ticker: String) async {
        let url = apiUrlBase + "news?param=" + ticker
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
                    let decodedData = try JSONDecoder().decode([NewsData].self, from: data)
                    DispatchQueue.main.async {
                        self.newsInfo = decodedData
                        self.loaded = true
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}
