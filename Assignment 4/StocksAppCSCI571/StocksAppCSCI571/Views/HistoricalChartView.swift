//
//  HistoricalChartView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/30/24.
//

import SwiftUI
import WebKit

struct HistoricalHighchartsView: UIViewRepresentable {
    let html: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}

struct HistoricalChartView: View {
    let htmlHstD: String
    
//    @ObservedObject var viewModel = HistoricalViewModel()
    
    var body: some View {
        VStack{
            HistoricalHighchartsView(html: htmlHstD)
                .onAppear {
                    Task {
//                        await viewModel.getHistoricalChart(for: ticker)
                    }
                }
                .padding(.horizontal)
                .frame(height: 330, alignment: .center)
        }
    }
}

//#Preview {
//    HistoricalChartView()
//}
