//
//  HomeViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var watchlistInfo: [DWatchlistData] = []
    @Published var portfolioInfo: [DPortfolioData] = []
    @Published var blnc: Double = 0.0
    @Published var netb: Double = 0.0
    let apiUrlBase = "https://assignment-3-419113.wl.r.appspot.com/api/"
    @Published var loaded1: Bool = false
    @Published var loaded2: Bool = false
    @Published var loaded3: Bool = false
    
    func getWatchInfo() async {
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
                        self.loaded1 = true
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    func unlikeStock(infoParam: DWatchlistData) async {
        let nameStr = infoParam.name
        let nameUrlStr = nameStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url1 = apiUrlBase + "opWatchlist?t=" + infoParam.ticker
        let url2 = "&n=" + nameUrlStr
        let url3 = "&c=" + infoParam.c + "&d=" + infoParam.d + "&dp=" + infoParam.dp + "&op=0"
        let url = url1 + url2 + url3
        guard let apiUrl = URL(string: url) else {
            return
        }
        URLSession.shared.dataTask(with: apiUrl) {
            data, _, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
        }.resume()
    }
    
    func getPortInfo() async {
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
                        self.loaded2 = true
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    func getBlnc() async {
        let url0 = "https://assignment-3-419113.wl.r.appspot.com/api/fetchContent?param=0"
        guard let apiUrl0 = URL(string: url0) else {
            return
        }
        URLSession.shared.dataTask(with: apiUrl0) {
            data0, _, error0 in
            if let error0 = error0 {
                print("Error fetching data: \(error0)")
                return
            }
            
            if let data0 = data0 {
                do {
                    let decodedData0 = try JSONDecoder().decode(Double.self, from: data0)
                    DispatchQueue.main.async {
                        self.blnc = decodedData0
                        self.netb = self.blnc
                        let size = self.portfolioInfo.count
                        var i = 0
                        while i < size {
                            self.netb = self.netb + Double(self.portfolioInfo[i].Mv)!
                            i = i + 1
                        }
                        self.loaded3 = true
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    func sellStock(infoParam: DPortfolioData, blnc: Double) async {
        let qty = 0
        let tvn = 0
        let avg = 0
        let mkv = 0
        let ablc = blnc + (Double(infoParam.Quantity)!) * (Double(infoParam.c)!)
        let nameStr = infoParam.name
        let nameUrlStr = nameStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url1 = apiUrlBase + "opPortfolio?t=" + infoParam.ticker
        let url2 = "&n=" + nameUrlStr
        let url3 = "&c=" + infoParam.c + "&d=" + infoParam.d
        let url4 = "&quantity=" + String(qty)
        let url5 = "&avg=" + String(avg)
        let url6 = "&total=" + String(tvn)
        let url7 = "&mv=" + String(mkv)
        let url8 = "&blc=" + String(ablc) + "&op=0"
        let url = url1 + url2 + url3 + url4 + url5 + url6 + url7 + url8
        guard let apiUrl = URL(string: url) else {
            return
        }
        URLSession.shared.dataTask(with: apiUrl) {
            data, _, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
        }.resume()
    }
}
