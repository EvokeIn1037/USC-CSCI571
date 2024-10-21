//
//  HighchartTabView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/29/24.
//

import SwiftUI

struct HighchartTabView: View {
    var body: some View {
        VStack {
            TabView {
                HourlyChartView(htmlHD: "Hello world!")
                    .tabItem {
                        Label("Hourly", systemImage: "chart.xyaxis.line")
                    }
                HistoricalChartView(htmlHstD: "Hello world!")
                    .tabItem {
                        Label("Historical", systemImage: "clock")
                    }
            }
            .frame(width: 400, height: 400, alignment: .center)
        }
    }
}

#Preview {
    HighchartTabView()
}
