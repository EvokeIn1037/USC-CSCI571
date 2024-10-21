//
//  NewsView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import SwiftUI

struct NewsView: View {
    let newsInfo: [NewsData]
    
//    @ObservedObject var viewModel = NewsViewModel()
    
    @State private var showingSheet = false
    @State private var nowContent: NewsData = NewsData(image: "", source: "", datetime: "", headline: "", summary: "", url: "", differNow: "")
    
    var body: some View {
        VStack {
            Text("News")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            ForEach(newsInfo.indices, id: \.self) { index in
                if index == 0 {
                    VStack {
                        if !newsInfo[index].image.isEmpty {
                            AsyncImage(url: URL(string: newsInfo[index].image)) {
                                image in
                                image
                                    .image?.resizable()
                                    .frame(maxWidth: 500, maxHeight: 200, alignment: .center)
                                    .clipShape(.rect(cornerRadius: 8))
                            }
                                .padding()
                        }
                        VStack {
                            (Text(newsInfo[index].source)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            + Text("  ") + Text(newsInfo[index].differNow)
                                    .foregroundColor(.gray))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text(newsInfo[index].headline)
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Divider()
                    }
                    .onTapGesture {
                        showingSheet = true
                        nowContent = newsInfo[index]
                    }
                    .sheet(isPresented: $showingSheet) {
                        SheetView(contentData: nowContent, showingSheet: $showingSheet)
                    }
                }
                else {
                    HStack {
                        VStack {
                            (Text(newsInfo[index].source)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            + Text("  ") + Text(newsInfo[index].differNow)
                                    .foregroundColor(.gray))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text(newsInfo[index].headline)
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        if !newsInfo[index].image.isEmpty {
                            AsyncImage(url: URL(string: newsInfo[index].image)) {
                                image in
                                image
                                    .image?.resizable()
                                    .frame(maxWidth: 85, maxHeight: 85, alignment: .center)
                                    .clipShape(.rect(cornerRadius: 8))
                            }
                                .padding()
                        }
                    }
                    .onTapGesture {
                        showingSheet = true
                        nowContent = newsInfo[index]
                    }
                    .sheet(isPresented: $showingSheet) {
                        SheetView(contentData: nowContent, showingSheet: $showingSheet)
                    }
                }
            }
        }
        .onAppear {
            Task {
//                await viewModel.getNews(for: ticker)
            }
        }
        .padding(.horizontal)
    }
}

struct SheetView: View {
    let contentData: NewsData
    
    @Binding var showingSheet: Bool
    
    var body: some View {
        VStack {
            NewsSheetView(contentData: contentData, showingSheet: $showingSheet)
            Spacer()
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    NewsView(ticker: "AAPL")
//}
