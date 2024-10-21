//
//  TimeViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/29/24.
//

import Foundation
import SwiftUI

class TimeViewModel: ObservableObject {
    func showCurrentTime() -> String
    {
        let dateForm = DateFormatter()
        dateForm.dateFormat = "MMMM d, yyyy"
        let currentTime = Date()
        return dateForm.string(from: currentTime)
    }
}
