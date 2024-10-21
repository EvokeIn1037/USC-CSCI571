//
//  LikeViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import Foundation
import SwiftUI

class LikeViewModel: ObservableObject {
    let apiUrlBase = "https://assignment-3-419113.wl.r.appspot.com/api/"
    @Published var loaded: Bool = false
    
    func likeStock(infoParam: BaseResult) async {
        let nameStr = infoParam.name
        let nameUrlStr = nameStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url1 = apiUrlBase + "opWatchlist?t=" + infoParam.ticker
        let url2 = "&n=" + nameUrlStr
        let url3 = "&c=" + infoParam.c + "&d=" + infoParam.d + "&dp=" + infoParam.dp + "&op=1"
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
    
    func unlikeStock(infoParam: BaseResult) async {
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
}
