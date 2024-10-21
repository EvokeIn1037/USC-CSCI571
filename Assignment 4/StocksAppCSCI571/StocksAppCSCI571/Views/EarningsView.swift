//
//  EarningsView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import SwiftUI
import WebKit

struct ErnsHighchartsView: UIViewRepresentable {
    let html: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}

struct EarningsView: View {
    let htmlED: String
    
//    @ObservedObject var viewModel = EarningsViewModel()
    
    var body: some View {
        VStack {
            ErnsHighchartsView(html: htmlED)
                .onAppear {
                    Task {
//                        await viewModel.getErnsChart(for: ticker)
                    }
                }
                .padding(.horizontal)
                .frame(height: 330, alignment: .center)
        }
    }
}

//#Preview {
//    EarningsView()
//}
