//
//  Dashboard.swift
//  iHospital Admin
//
//  Created by Aditya on 03/07/24.
//

import SwiftUI

struct Dashboard: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
//                Text("Dashboard")
//                    .font(.largeTitle)
//                    .bold()
                HStack(spacing: 30){
                    VStack(alignment:.leading,spacing: 15) {
                        // First two cards
                        Text("Today's Overview")
                            .font(.title)
                            .padding(.top)
                            .padding(.leading,30)
                            
                        HStack(spacing: 20) {
                            OverviewCard(title: "100", subtitle: "Appointments", color: .pink)
                                .frame(maxWidth: .infinity)
                            OverviewCard(title: "20", subtitle: "New Patients", color: .purple)
                                .frame(maxWidth: .infinity)
                            
                            
                        }
                        .padding([.leading,.trailing],30)
                        .frame(maxWidth: .infinity) // Take 50% of HStack width

                        // Second two cards
                        HStack(spacing: 20) {
                            OverviewCard(title: "43", subtitle: "Available Doctors", color: .yellow)
                            OverviewCard(title: "13", subtitle: "Lab Tests", color: .blue)
                        }
                        .padding(.top,0)
                        .padding([.leading,.trailing],30)
                        .padding(.bottom,20)
//                       .padding([.leading,.bottom,.trailing],20)
                        .padding(.top,14)
                        .frame(maxWidth: .infinity) // Take 50% of HStack width

                        
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.dashboard)
                    .cornerRadius(12)
                    

// Add padding to the HStack
                    
                        
                    VStack(alignment: .leading, spacing: 10) {
                            
                            Text("Today's Revenue")
                            .font(.title)
                            .padding(.top)
                            .padding(.leading,30)
//                            .padding([.top,.bottom,.trailing],20)
                        VStack(){
                            OverviewCard(title: "$XYZ", subtitle: "Total Revenue", color: .purple)
                                .padding([.leading,.trailing],30)
                                .padding(.top,10)
                    
                        
                        
                            OverviewCard(title: "$YYY", subtitle: "Total Revenue", color: .purple)
                                .padding([.leading,.trailing],30)
                                .padding(.bottom,25)
                                .padding(.top,10)
                        }
                     
                                
                        
                        }
//                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                    .background(Color.dashboard)
                    .cornerRadius(12)

                     // Take 50% of HStack width
                }
                

                

                // Second Section
                VStack(alignment: .leading){
                    Text("Today's Appointments")
                        .padding()
                        .font(.title3)
                        .bold()
//                        .padding(.top,0)

                    SearchBar()

                    AppointmentsList()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding()
                    
                        
                    
                }
                .background(Color.card)
                .cornerRadius(12)
                
            }
            .padding()
            .navigationTitle("Dashboard")
        }
    }
}
//Ui for Card
struct OverviewCard: View {
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .bold()
            Text(subtitle)
                .font(.subheadline)
        }
        /*padding()*/
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(color)
        .cornerRadius(12)
        .foregroundColor(.white)
    }
}


//Ui for search bar
struct SearchBar: View {
    @State private var searchText = ""

    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            Button(action: {
                // Add search action here
                print(searchText)
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
    }
}



struct AppointmentsList: View {
    var body: some View {
        LazyVStack {
            ForEach(0..<10) { _ in
                AppointmentRow()
            }
        }
    }
}


struct AppointmentRow: View {
    var body: some View {
        HStack {
            Text("341").padding(.trailing,40)
            Text("Amit Verma").padding(.trailing,40)
            Text("+91 XXXXXXXXXXX").padding(.trailing,40)
            Text("24/06/2024 11:00 am").padding(.trailing,50)
            Text("Dr. Harry Singh").padding(.trailing,40)
            StatusIndicator(status: "Upcoming").padding(.trailing,40)
        }
        .padding()

    }
}
//For Small circle that is showing before upcomoing
struct StatusIndicator: View {
    let status: String

    var body: some View {
        HStack {
            Circle()
                .fill(statusColor(status: status))
                .frame(width: 10, height: 10)
            Text(status)
                .font(.footnote)
        }
    }
//For Different colors for different things
    func statusColor(status: String) -> Color {
        switch status {
        case "Upcoming":
            return .green
        case "Completed":
            return .blue
        case "Cancelled":
            return .red
        case "Pending":
            return .orange
        default:
            return .gray
        }
    }
}

#Preview {
    Dashboard()
}
