//
//  CurrentTimeView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/29/24.
//

import SwiftUI

struct CurrentTimeView: View {
    @ObservedObject var viewModel = TimeViewModel()
    
    var body: some View {
        Text(viewModel.showCurrentTime())
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.gray)
            .multilineTextAlignment(.leading)
            .padding()
    }
}

#Preview {
    CurrentTimeView()
}
