//
//  BaseViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/29/24.
//

import Foundation
import SwiftUI

class BaseViewModel: ObservableObject {
    @Published var baseInfo: BaseResult = BaseResult(ticker: "", name: "", exchange: "", logo: "", c: "", d: "", dp: "", t: 0, timestampForm: "", op: 0)
    let apiUrlBase = "https://assignment-3-419113.wl.r.appspot.com/api/"
    @Published var hourlyApiUrl: String = "https://assignment-3-419113.wl.r.appspot.com/api/hourly?param="
    @Published var loaded: Bool = false
    
    func getBase(for ticker: String) async {
        let url = apiUrlBase + "base?param=" + ticker
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
                    let decodedData = try JSONDecoder().decode(BaseResult.self, from: data)
                    DispatchQueue.main.async {
                        self.baseInfo = decodedData
                        if self.baseInfo.op == 0 {
                            let date = Date(timeIntervalSince1970: TimeInterval(self.baseInfo.t))
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            self.hourlyApiUrl = self.hourlyApiUrl + self.baseInfo.ticker + "&op=0&closeDate=" + dateFormatter.string(from: date)
                        }
                        else {
                            self.hourlyApiUrl = self.hourlyApiUrl + self.baseInfo.ticker
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
