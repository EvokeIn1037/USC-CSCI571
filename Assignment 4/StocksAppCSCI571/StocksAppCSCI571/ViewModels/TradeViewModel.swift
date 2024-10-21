//
//  TradeViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import Foundation
import SwiftUI

class TradeViewModel: ObservableObject {
    let apiUrlBase = "https://assignment-3-419113.wl.r.appspot.com/api/"
    @Published var loaded: Bool = false
    
    func buyStockD(number: Int, chosenP: Double, infoParam: DPortfolioData, blnc: Double) async {
        let qty = Int(infoParam.Quantity)! + number
        let tvn = Double(infoParam.Total)! + chosenP
        let avg = tvn / Double(qty)
        let mkv = Double(qty) * Double(infoParam.c)!
        let ablc = blnc - chosenP
        let nameStr = infoParam.name
        let nameUrlStr = nameStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url1 = apiUrlBase + "opPortfolio?t=" + infoParam.ticker
        let url2 = "&n=" + nameUrlStr
        let url3 = "&c=" + infoParam.c + "&d=" + infoParam.d
        let url4 = "&quantity=" + String(qty)
        let url5 = "&avg=" + String(avg)
        let url6 = "&total=" + String(tvn)
        let url7 = "&mv=" + String(mkv)
        let url8 = "&blc=" + String(ablc) + "&op=1"
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
    
    func sellStockD(number: Int, chosenP: Double, infoParam: DPortfolioData, blnc: Double) async {
        let qty = Int(infoParam.Quantity)! - number
        let tvn = Double(infoParam.Total)! - chosenP
        let avg = tvn / Double(qty)
        let mkv = Double(qty) * Double(infoParam.c)!
        let ablc = blnc + chosenP
        var opn = 1
        if qty == 0 {
            opn = 0
        }
        let nameStr = infoParam.name
        let nameUrlStr = nameStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url1 = apiUrlBase + "opPortfolio?t=" + infoParam.ticker
        let url2 = "&n=" + nameUrlStr
        let url3 = "&c=" + infoParam.c + "&d=" + infoParam.d
        let url4 = "&quantity=" + String(qty)
        let url5 = "&avg=" + String(avg)
        let url6 = "&total=" + String(tvn)
        let url7 = "&mv=" + String(mkv)
        let url8 = "&blc=" + String(ablc) + "&op=" + String(opn)
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
