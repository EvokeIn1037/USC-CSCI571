//
//  HomeWatchView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import SwiftUI

struct HomeWatchView: View {
    let item: DWatchlistData
    
    var body: some View {
        HStack {
            VStack {
                Text(item.ticker)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(item.name)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack {
                if Double(item.dp)! > 0.0 {
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(.green)
                    VStack {
                        Text("$\(item.c)")
                            .fontWeight(.bold)
                        Text("$\(item.d)")
                            .foregroundColor(.green)
                        Text("(\(item.dp)%)")
                            .foregroundColor(.green)
                    }
                }
                else if Double(item.dp)! == 0.0 {
                    Image(systemName: "minus")
                        .foregroundColor(.gray)
                    VStack {
                        Text("$\(item.c)")
                            .fontWeight(.bold)
                        Text("$\(item.d)")
                            .foregroundColor(.gray)
                        Text("(\(item.dp)%)")
                            .foregroundColor(.gray)
                    }
                }
                else {
                    Image(systemName: "arrow.down.right")
                        .foregroundColor(.red)
                    VStack {
                        Text("$\(item.c)")
                            .fontWeight(.bold)
                        Text("$\(item.d)")
                            .foregroundColor(.red)
                        Text("(\(item.dp)%)")
                            .foregroundColor(.red)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

//#Preview {
//    HomeWatchView()
//}
