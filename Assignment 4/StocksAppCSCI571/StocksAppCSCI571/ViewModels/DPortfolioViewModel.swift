//
//  DPortfolioViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import Foundation
import SwiftUI

class DPortfolioViewModel: ObservableObject {
    @Published var portfolioInfo: [DPortfolioData] = []
    @Published var balanceLeft = 0.0
    @Published var exist = -1
    let apiUrlBase = "https://assignment-3-419113.wl.r.appspot.com/api/fetchContent?param=2"
    @Published var loaded1: Bool = false
    @Published var loaded2: Bool = false
    
    func getPortInfoD(for ticker: String) async {
        let url = "https://assignment-3-419113.wl.r.appspot.com/api/fetchContent?param=2"
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
                    let decodedData = try JSONDecoder().decode([DPortfolioData].self, from: data)
                    DispatchQueue.main.async {
                        self.portfolioInfo = decodedData
                        let size = self.portfolioInfo.count
                        var i = 0
                        while i < size {
                            if self.portfolioInfo[i].ticker == ticker {
                                self.exist = i
                            }
                            i = i + 1
                        }
                        self.loaded1 = true
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    func getBlncInfoD() async {
        let url = "https://assignment-3-419113.wl.r.appspot.com/api/fetchContent?param=0"
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
                    let decodedData = try JSONDecoder().decode(Double.self, from: data)
                    DispatchQueue.main.async {
                        self.balanceLeft = decodedData
                        self.loaded2 = true
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    func isStringOnlyNumbers(_ string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
