//
//  HourlyChartView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/29/24.
//

import SwiftUI
import WebKit

struct HighchartsView: UIViewRepresentable {
    let html: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}

struct HourlyChartView: View {
    let htmlHD: String
    
//    @ObservedObject var viewModel = HourlyViewModel()
    
    var body: some View {
        VStack {
            HighchartsView(html: htmlHD)
                .onAppear {
                    Task {
//                        await viewModel.getHourlyChart(for: apiUrl)
                    }
                }
                .padding(.horizontal)
                .frame(height: 330, alignment: .center)
        }
    }
}

//#Preview {
//    HourlyChartView()
//}
