//
//  HomePortView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import SwiftUI

struct HomePortView: View {
    let item: DPortfolioData
    
    var body: some View {
        HStack {
            VStack {
                Text(item.ticker)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(item.Quantity)" + " shares")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack {
                Text("$\(item.Mv)")
                    .fontWeight(.bold)
                let cgTotal = (Double(item.Mv)!) - (Double(item.Total)!)
                let cgPerc = (cgTotal / (Double(item.Total)!)) * 100
                HStack {
                    if cgTotal > 0.0 {
                        Image(systemName: "arrow.up.right")
                            .foregroundColor(.green)
                        Text("$" + String(format: "%.2f", cgTotal) + " (" + String(format: "%.2f", cgPerc) + "%)")
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    else if cgTotal == 0.0 {
                        Image(systemName: "minus")
                            .foregroundColor(.gray)
                        Text("$" + String(format: "%.2f", cgTotal) + " (" + String(format: "%.2f", cgPerc) + "%)")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    else {
                        Image(systemName: "arrow.down.right")
                            .foregroundColor(.red)
                        Text("$" + String(format: "%.2f", cgTotal) + " (" + String(format: "%.2f", cgPerc) + "%)")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
        }
    }
}

//#Preview {
//    HomePortView()
//}
