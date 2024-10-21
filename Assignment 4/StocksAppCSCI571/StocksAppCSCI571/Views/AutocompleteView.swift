//
//  AutocompleteView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/29/24.
//

import SwiftUI

struct AutocompleteView: View {
    var autocompleteContent: SearchResult
    
    var body: some View {
        VStack {
            Text(autocompleteContent.symbol)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(autocompleteContent.description)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

//#Preview {
//    AutocompleteView(autocompleteContent: )
//}
