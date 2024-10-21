//
//  StockDetailView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/29/24.
//

import SwiftUI

struct StockDetailView: View {
    let symbol: String
    
    @ObservedObject var viewModel = DWatchlistViewModel()
    @ObservedObject var lViewModel = LikeViewModel()
    @ObservedObject var bViewModel = BaseViewModel()
    @ObservedObject var hlyViewModel = HourlyViewModel()
    @ObservedObject var hstViewModel = HistoricalViewModel()
    @ObservedObject var dPflViewModel = DPortfolioViewModel()
    @ObservedObject var abtViewModel = AboutViewModel()
    @ObservedObject var istViewModel = InsightsViewModel()
    @ObservedObject var rcmdViewModel = RecommendViewModel()
    @ObservedObject var ernsViewModel = EarningsViewModel()
    @ObservedObject var nsViewModel = NewsViewModel()
    
    @State private var showingSheetIntoDP = false
    @State private var addFav = false
    
    var body: some View {
        ZStack {
            if !(viewModel.loaded && bViewModel.loaded && hlyViewModel.loaded && hstViewModel.loaded && dPflViewModel.loaded1 && dPflViewModel.loaded2 && abtViewModel.loaded && istViewModel.loaded && rcmdViewModel.loaded && ernsViewModel.loaded && nsViewModel.loaded) {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(1)
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.gray)
                        .padding()
                        .background(Color.white)
                        .transition(.scale)
                    Text("Fetching Data...")
                        .foregroundColor(.gray)
                }
                .zIndex(2)
            }
            
            if addFav {
                VStack {
                    Spacer()
                    Text("Adding " + symbol + " to Favorites")
                        .frame(width: 250, height: 25)
                        .padding()
                        .background(Color.gray)
                        .opacity(0.8)
                        .foregroundColor(Color.white)
                        .cornerRadius(25)
                        .transition(.slide)
                        .zIndex(1)
                }
                .zIndex(1)
            }
            
            ScrollView {
                VStack {
                    StockBaseView(baseInfo: bViewModel.baseInfo)
                    
                    VStack {
                        TabView {
                            HourlyChartView(htmlHD: hlyViewModel.html)
                                .tabItem {
                                    Label("Hourly", systemImage: "chart.xyaxis.line")
                                }
                            HistoricalChartView(htmlHstD: hstViewModel.html)
                                .tabItem {
                                    Label("Historical", systemImage: "clock")
                                }
                        }
                        .frame(width: 400, height: 400, alignment: .center)
                    }
                    
                    DetailPortfolioView(portfolioInfo: dPflViewModel.portfolioInfo, balanceLeft: dPflViewModel.balanceLeft, exist: dPflViewModel.exist, baseInfoDP: bViewModel.baseInfo, showingSheetDP: $showingSheetIntoDP)
                    
                    AboutView(aboutInfo: abtViewModel.aboutInfo)
                    
                    InsightsView(insightsInfo: istViewModel.insightsInfo)
                    
                    RecommendChartView(htmlRcmdD: rcmdViewModel.html)
                    
                    EarningsView(htmlED: ernsViewModel.html)
                    
                    NewsView(newsInfo: nsViewModel.newsInfo)
                }
            }
            .navigationTitle("\(symbol)")
            .onAppear {
                Task {
                    await viewModel.getWatchInfo(for: symbol)
                    await bViewModel.getBase(for: symbol)
                    await hlyViewModel.getHourlyChart(for: bViewModel.hourlyApiUrl)
                    await hstViewModel.getHistoricalChart(for: symbol)
                    await dPflViewModel.getPortInfoD(for: symbol)
                    await dPflViewModel.getBlncInfoD()
                    await abtViewModel.getSummary(for: symbol)
                    await istViewModel.getInsights(for: symbol)
                    await rcmdViewModel.getRcmdChart(for: symbol)
                    await ernsViewModel.getErnsChart(for: symbol)
                    await nsViewModel.getNews(for: symbol)
                }
            }
            .onChange(of: bViewModel.hourlyApiUrl) { oldValue, newValue in
                Task {
                    await hlyViewModel.getHourlyChart(for: newValue)
                }
            }
            .onChange(of: showingSheetIntoDP) { oldValue, newValue in
                Task {
                    if !newValue {
                        await dPflViewModel.getPortInfoD(for: symbol)
                        await dPflViewModel.getBlncInfoD()
                    }
                }
            }
            .toolbar {
                if viewModel.exist >= 0 {
                    Button(action: {
                        Task {
                            await lViewModel.unlikeStock(infoParam: bViewModel.baseInfo)
                        }
                        viewModel.exist = -1
                        addFav = false
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                else {
                    Button(action: {
                        Task {
                            await lViewModel.likeStock(infoParam: bViewModel.baseInfo)
                        }
                        viewModel.exist = 0
                        addFav = true
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    StockDetailView(symbol: "AAPL")
}
