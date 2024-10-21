//
//  AboutView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/30/24.
//

import SwiftUI

struct AboutView: View {
    let aboutInfo: SummaryData
    
//    @ObservedObject var viewModel = AboutViewModel()
    
    var body: some View {
        VStack {
            Text("Stats")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                VStack {
                    HStack {
                        Text("High Price: ")
                            .fontWeight(.bold)
                        Text("$" + String(format: "%.2f", aboutInfo.h))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Low Price: ")
                            .fontWeight(.bold)
                        Text("$" + String(format: "%.2f", aboutInfo.l))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                VStack {
                    HStack {
                        Text("Open Price: ")
                            .fontWeight(.bold)
                        Text("$" + String(format: "%.2f", aboutInfo.o))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Prev. Close: ")
                            .fontWeight(.bold)
                        Text("$" + String(format: "%.2f", aboutInfo.pc))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.bottom)
            
            Text("About")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                VStack {
                    Text("IPO Start Date: ")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Industry: ")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Webpage: ")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                VStack {
                    Text(aboutInfo.ipo)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(aboutInfo.finnhubIndustry)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if !aboutInfo.weburl.isEmpty {
                        Link(aboutInfo.weburl, destination: URL(string: aboutInfo.weburl)!)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            HStack {
                Text("Company peers: ")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(aboutInfo.peers, id: \.self) { peer in
                            NavigationLink {
                                StockDetailView(symbol: peer)
                            } label: {
                                Text(peer)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
//                await viewModel.getSummary(for: ticker)
            }
        }
        .padding(.leading)
        .padding(.vertical)
    }
}

//#Preview {
//    AboutView()
//}
