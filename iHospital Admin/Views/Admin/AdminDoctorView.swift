//
//  DoctorView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 04/07/24.
//

import SwiftUI

struct AdminDoctorView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15
            ) {
                ForEach(0..<9) { index in
                    NavigationLink(destination: DetailView(cardIndex: index)) {
                        CardView(cardIndex: index)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(height: 150)
                    .padding(.all)
                }
            }
            .padding()
        }
        .navigationTitle("Departments")
    }
}

struct CardView: View {
    let cardIndex: Int
    
    var body: some View {
        VStack {
            Text("Card \(cardIndex + 1) Title")
                .font(.headline)
            Text("Card \(cardIndex + 1) Subtitle")
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.blue.opacity(0.2))
        .cornerRadius(10)
    }
}

struct DetailView: View {
    let cardIndex: Int
    
    var body: some View {
        VStack {
            Text("Details for Card \(cardIndex + 1)")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationTitle("Detail")
        .navigationBarItems(trailing: Button(action: {
            // Action for Plus button
            print("Plus button tapped")
        }) {
            Image(systemName: "plus")
                .font(.title3)
        })
    }
}


#Preview {
    AdminSidebarView()
}
