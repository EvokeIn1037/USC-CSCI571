//
//  InsightsView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import SwiftUI

struct InsightsView: View {
    let insightsInfo: InsightsData
    
//    @ObservedObject var viewModel = InsightsViewModel()
    
    var body: some View {
        VStack {
            Text("Insights")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Insider Sentiments")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                VStack {
                    Text(insightsInfo.name)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text("Total")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text("Positive")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text("Negative")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                }
                VStack {
                    Text("MSPR")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text(String(format: "%.2f", insightsInfo.totalMSPR))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text(String(format: "%.2f", insightsInfo.positiveMSPR))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text(String(format: "%.2f", insightsInfo.negativeMSPR))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                }
                VStack {
                    Text("Change")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text("\(insightsInfo.totalChange)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text("\(insightsInfo.positiveChange)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text("\(insightsInfo.negativeChange)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                }
            }
        }
        .onAppear {
            Task {
//                await viewModel.getInsights(for: ticker)
            }
        }
        .padding(.leading)
        .padding(.vertical)
    }
}

//#Preview {
//    InsightsView()
//}
