//
//  SearchViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/28/24.
//

import Foundation
import SwiftUI

class SearchViewModel: ObservableObject
{
    @Published var autocompleteSuggestions: [SearchResult] = []
    let apiUrlBase = "https://assignment-3-419113.wl.r.appspot.com/api/"
    
    func autocomplete(for searchText: String) async
    {
        let url = apiUrlBase + "autofill?param=" + searchText
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
                    let decodedData = try JSONDecoder().decode([SearchResult].self, from: data)
                    DispatchQueue.main.async {
                        self.autocompleteSuggestions = decodedData
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}
