//
//  DoctorDetailsColumn.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 05/07/24.
//

import SwiftUI

struct DoctorDetailsColumn: View {
    @EnvironmentObject var doctorDetailViewModel: DoctorDetailViewModel
    
    var body: some View {
        if let doctor = doctorDetailViewModel.doctor {
            Form {
                Section {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding()
                }
                
                Section(header: Text("Doctor Details")) {
                        Text(doctor.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(doctor.email)
                    }
                    HStack {
                        Text("Phone")
                        Spacer()
                        Text("\(doctor.phoneNumber)")
                    }
                    HStack {
                        Text("Qualification")
                        Spacer()
                        Text(doctor.qualification)
                    }
                    HStack {
                        Text("Experience Since")
                        Spacer()
                        Text("\(doctor.experienceSince, formatter: DateFormatter.shortDate)")
                    }
                    HStack {
                        Text("Date of Joining")
                        Spacer()
                        Text("\(doctor.dateOfJoining, formatter: DateFormatter.shortDate)")
                    }
                }
            }
        }
    }
}

#Preview {
    DoctorDetailsColumn().environmentObject(DoctorDetailViewModel())
}

