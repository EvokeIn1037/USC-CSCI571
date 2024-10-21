//
//  NewsSheetView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import SwiftUI

struct NewsSheetView: View {
    let contentData: NewsData
    
    @Binding var showingSheet: Bool
    
    var body: some View {
        Button(action: {
            showingSheet = false
        }) {
            Image(systemName: "xmark")
                .foregroundColor(.black)
                .padding()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        
        Text(contentData.source)
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
        Text(contentData.datetime)
            .font(.title3)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
        Divider()
        Text(contentData.headline)
            .font(.title2)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
        Text(contentData.summary)
            .frame(maxWidth: .infinity, alignment: .leading)
        if !contentData.url.isEmpty {
            HStack(spacing: 0, content: {
                Text("For more details click ")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Link("here", destination: URL(string: contentData.url)!)
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
            .padding(.vertical)
            
            let xLink = "https://twitter.com/intent/tweet?original_referer=https%3A%2F%2Fdeveloper.twitter.com%2F&ref_src=twsrc%5Etfw%7Ctwcamp%5Ebuttonembed%7Ctwterm%5Eshare%7Ctwgr%5E&text=" + contentData.headline + "&url=" + contentData.url
            let fbLink = "https://www.facebook.com/sharer/sharer.php?u=" + contentData.url
            HStack {
                Button(action: {
                    if let xUrl = URL(string: xLink) {
                        UIApplication.shared.open(xUrl)
                    }
                }) {
                    Image("X")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding()
                }
                
                Button(action: {
                    if let fbUrl = URL(string: fbLink) {
                        UIApplication.shared.open(fbUrl)
                    }
                }) {
                    Image("Facebook")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding()
                }
                
                Spacer()
            }
        }
    }
}

//#Preview {
//    NewsSheetView()
//}
