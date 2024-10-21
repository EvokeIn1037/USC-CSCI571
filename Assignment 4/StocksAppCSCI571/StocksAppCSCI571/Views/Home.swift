//
//  Home.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/28/24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()
    @ObservedObject var hViewModel = HomeViewModel()
    @State private var searchText = ""
    @State private var onDOp = false
    
//    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            if !(hViewModel.loaded1 && hViewModel.loaded2 && hViewModel.loaded3) {
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
            
            NavigationView {
                if !searchText.isEmpty {
                    List(viewModel.autocompleteSuggestions, id: \.symbol) { result in
                        NavigationLink {
                            StockDetailView(symbol: result.symbol)
                        } label: {
                            AutocompleteView(autocompleteContent: result)
                        }
                    }
                    .navigationTitle("Stocks")
                }
                else {
                    List {
                        CurrentTimeView()
                        
                        Section(header: Text("PORTFOLIO")) {
                            HStack {
                                VStack {
                                    Text("Net Worth")
                                        .font(.title2)
                                    Text("$" + String(format: "%.2f", hViewModel.netb))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                VStack {
                                    Text("Cash Balance")
                                        .font(.title2)
                                    Text("$" + String(format: "%.2f", hViewModel.blnc))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            ForEach(hViewModel.portfolioInfo, id: \.self) { item in
                                let destinationView = StockDetailView(symbol: item.ticker)
                                NavigationLink {
//                                    let tickerParam = item.ticker
//                                    StockDetailView(symbol: tickerParam)
                                    destinationView
                                } label: {
                                    HomePortView(item: item)
                                }
                            }
                            .onDelete(perform: deleteItemsP)
                            .onMove(perform: moveItemsP)
                        }
                        
                        Section(header: Text("FAVORITES")) {
                            ForEach(hViewModel.watchlistInfo, id: \.self) { item in
                                let destinationView = StockDetailView(symbol: item.ticker)
                                NavigationLink {
//                                    let tickerParam = item.ticker
//                                    StockDetailView(symbol: tickerParam)
                                    destinationView
                                } label: {
                                    HomeWatchView(item: item)
                                }
                            }
                            .onDelete(perform: deleteItemsW)
                            .onMove(perform: moveItemsW)
                        }
                        
                        Link("Powered by Finnhub.io", destination: URL(string: "https://finnhub.io")!)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    }
                    .navigationTitle("Stocks")
                    .onAppear {
                        Task {
                            await hViewModel.getWatchInfo()
                            await hViewModel.getPortInfo()
//                            await hViewModel.getBlnc()
                        }
                    }
                    .onChange(of: hViewModel.loaded2) { oldValue, newValue in
                        Task {
                            await hViewModel.getBlnc()
                        }
                    }
                    .onChange(of: hViewModel.portfolioInfo) { oldValue, newValue in
                        Task {
                            if !onDOp {
                                await hViewModel.getBlnc()
                            }
                        }
                    }
//                    .onReceive(timer) { _ in
//                        Task {
//                            await hViewModel.getWatchInfo()
//                            await hViewModel.getPortInfo()
//                            await hViewModel.getBlnc()
//                        }
//                    }
                    .toolbar{
                        #if os(iOS)
                        EditButton()
                        #endif
                    }
                }
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) {
                oldValue, newValue in
                Task {
                    if !newValue.isEmpty {
                        await viewModel.autocomplete(for: newValue)
                    }
                    else {
                        viewModel.autocompleteSuggestions = []
                    }
                }
            }
        }
    }
    
    private func deleteItemsP(at offsets: IndexSet) {
        onDOp = true
        let index = (offsets.first!)
        let content = hViewModel.portfolioInfo[index]
        let nBlnc = hViewModel.blnc
        hViewModel.portfolioInfo.remove(atOffsets: offsets)
        let getSell = (Double(content.Quantity)!) * (Double(content.c)!)
        Task {
            await hViewModel.sellStock(infoParam: content, blnc: nBlnc)
        }
        hViewModel.blnc += getSell
    }

    private func moveItemsP(from source: IndexSet, to destination: Int) {
        hViewModel.portfolioInfo.move(fromOffsets: source, toOffset: destination)
    }
    
    private func deleteItemsW(at offsets: IndexSet) {
        let index = (offsets.first!)
        let content = hViewModel.watchlistInfo[index]
        hViewModel.watchlistInfo.remove(atOffsets: offsets)
        Task {
            await hViewModel.unlikeStock(infoParam: content)
        }
    }

    private func moveItemsW(from source: IndexSet, to destination: Int) {
        hViewModel.watchlistInfo.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    SearchView()
}
