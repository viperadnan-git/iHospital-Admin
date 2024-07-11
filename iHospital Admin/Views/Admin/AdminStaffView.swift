//
//  AdminStaffView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 05/07/24.
//

import SwiftUI

struct AdminStaffView: View {
    var StaffDepartment = ["Clinical laboratory","Nursing", "Housekeeping","Others" ]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(0..<StaffDepartment.count, id: \.self) { index in
                    NavigationLink(destination: Detailed(cardIndex: index)) {
                        Cards(cardIndex: index, departmentName: StaffDepartment[index])
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(height: 150)
                    .padding(.horizontal, 4)
                }
            }
            .padding()
        }
        .navigationTitle("Staff Departments")
    }
}

struct Cards: View {
    let cardIndex: Int
    let departmentName: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName(for: departmentName))
                    .font(.largeTitle)
                    .padding(.leading, 10)
                Spacer()
            }
            Spacer()
            HStack {
                Image(systemName: "phone.fill")
                Text("918xxxxxxxxx")
                    .font(.subheadline)
            }
            Text(departmentName)
                .font(.title3)
                .fontWeight(.bold)
                
        }
        .foregroundColor(Color(uiColor: .white))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(backgroundColor(for: departmentName))
        .cornerRadius(10)
    }

    func iconName(for departmentName: String) -> String {
        switch departmentName {
        case "Clinical laboratory":
            return "cross.case"
        case "Housekeeping":
            return "house.lodge"
        default:
            return "building.2.crop.circle"
        }
    }

    func backgroundColor(for departmentName: String) -> Color {
        switch departmentName {
        case "Clinical laboratory":
            return Color(uiColor: .brown)
        case "Nursing":
            return Color(uiColor: .systemRed)
        case "Housekeeping":
            return Color(uiColor: .systemPurple)
        case "Others":
            return Color(uiColor: .systemOrange)
        default:
            return Color.blue.opacity(0.5)
        }
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

