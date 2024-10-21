//
//  RecommendChartView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import SwiftUI
import WebKit

struct RcmdHighchartsView: UIViewRepresentable {
    let html: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}

struct RecommendChartView: View {
    let htmlRcmdD: String
    
//    @ObservedObject var viewModel = RecommendViewModel()
    
    var body: some View {
        VStack {
            HighchartsView(html: htmlRcmdD)
                .onAppear {
                    Task {
//                        await viewModel.getRcmdChart(for: ticker)
                    }
                }
                .padding(.horizontal)
                .frame(height: 330, alignment: .center)
        }
    }
}

//#Preview {
//    RecommendChartView()
//}
