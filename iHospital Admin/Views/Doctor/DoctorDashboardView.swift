//
//  DoctorDashboardView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import SwiftUI

struct DoctorDashboardView: View {
    @StateObject private var doctorDetailViewModel = DoctorDetailViewModel()
    
    var body: some View {
        if doctorDetailViewModel.isLoading {
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(2)
        } else {
            NavigationStack {
                VStack {
                    ScrollView {
                        Text("Doctor Dashboard")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        
                        Spacer()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: HStack {
                        Text("Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    },
                    trailing: NavigationLink(destination: DoctorSettingView().environmentObject(doctorDetailViewModel)) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                )
            }
        }
    }
}

#Preview {
    DoctorDashboardView()
}
