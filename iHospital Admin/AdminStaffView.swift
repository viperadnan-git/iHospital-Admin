//
//  AdminStaffView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 05/07/24.
//

import SwiftUI

struct AdminStaffView: View {
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
                                   NavigationLink(destination: Detailed(cardIndex: index)) {
                                       Cards(cardIndex: index)
                                   }
                                   .buttonStyle(PlainButtonStyle())
                                   .frame(height: 150)
                                   .padding(.all)
                               }
                           }
                           .padding()
                }
        .navigationTitle("Staff Departments")
        
        
            }
        }

        struct Cards: View {
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

        struct Detailed: View {
            let cardIndex: Int
            
            @State private var showingForm = false
               
            let columns = [
                   GridItem(.flexible()),
                   GridItem(.flexible()),
                   GridItem(.flexible())
               ]
            
            //navigated to next slide where list of staff will be shown
            
            var body: some View {
                ScrollView {
                                   LazyVGrid(columns: columns, spacing: 15
                                   ) {
                                       ForEach(0..<9) { index in
                                           NavigationLink(destination: StaffDetailed(cardIndex: index)) {
                                               CardStaffDetail(cardIndex: index)
                                           }
                                           .buttonStyle(PlainButtonStyle())
                                           .frame(height: 150)
                                           .padding(.all)
                                       }
                                   }
                                   .padding()
                        }
                    .navigationTitle("Staff List")
                    .navigationBarItems(trailing: Button(action: {
                               showingForm = true
                           }) {
                               Image(systemName: "plus")
                                   .font(.title2)
                           })
                    .sheet(isPresented: $showingForm) {
                        AdminStaffAddView()
                           }
            }
        }


//cards on list of staff page
struct CardStaffDetail: View {
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

// profile detail page of staff

struct StaffDetailed: View {
    let cardIndex: Int
    
    @State private var showingForm = false
       
    
    var body: some View {
        VStack {
            Text("Profile \(cardIndex + 1)")
                .font(.largeTitle)
                .padding()
            Spacer()
            }
            .navigationTitle("Pofile")
            .navigationBarItems(trailing: Button(action: {
                       showingForm = true
                   }) {
                       Text("Edit")
                           .font(.title2)
                   })
            
    }
}


#Preview {
    AdminStaffView()
}
