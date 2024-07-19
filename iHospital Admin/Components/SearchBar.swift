//
//  SearchBar.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 10/07/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search"
    var searchIcon: String = "magnifyingglass"
    var clearIcon: String = "multiply.circle.fill"
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: searchIcon)
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: clearIcon)
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .accessibility(label: Text("Search"))
                .accessibility(value: Text(text.isEmpty ? "Empty" : text))
        }
    }
}
