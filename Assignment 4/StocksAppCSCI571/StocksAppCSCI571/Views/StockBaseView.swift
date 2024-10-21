//
//  StockBaseView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/29/24.
//

import SwiftUI

struct StockBaseView: View {
    let baseInfo: BaseResult
    
//    @ObservedObject var viewModel = BaseViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text(baseInfo.name)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                if !baseInfo.logo.isEmpty {
                    AsyncImage(url: URL(string: baseInfo.logo)) {
                        image in
                        image
                            .image?.resizable()
                            .frame(maxWidth: 50, maxHeight: 50, alignment: .trailing)
                            .clipShape(.rect(cornerRadius: 8))
                    }
                        .padding()
                }
            }
            
            HStack {
                Text("$\(baseInfo.c)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                if let stockState = Float(baseInfo.d) {
                    if stockState > 0 {
                        Image(systemName: "arrow.up.right")
                            .font(.title2)
                            .foregroundColor(.green)
                        Text("$\(baseInfo.d) (\(baseInfo.dp)%)")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                    else if stockState == 0 {
                        Image(systemName: "minus")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("$\(baseInfo.d) (\(baseInfo.dp)%)")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    else {
                        Image(systemName: "arrow.down.right")
                            .font(.title2)
                            .foregroundColor(.red)
                        Text("$\(baseInfo.d) (\(baseInfo.dp)%)")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
//            HighchartTabView(hourlyApiUrl: viewModel.hourlyApiUrl, ticker: ticker)
        }
        .onAppear {
            Task {
//                await viewModel.getBase(for: ticker)
            }
        }
    }
}

//#Preview {
//    StockBaseView()
//}
