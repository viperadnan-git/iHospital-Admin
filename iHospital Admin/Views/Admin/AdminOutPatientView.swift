//
//  AdminOutPatientView.swift
//  iHospital Admin
//
//  Created by Aditya on 06/07/24.
//

import SwiftUI

struct AdminOutPatientView: View {
    @State var searchtext = ""
    var body: some View {
        VStack{
            HStack{
                SearchBar(searchText: $searchtext).padding(.top)
                
//                HStack{
//                    Image(systemName: "plus")
//                        .padding()
//                        .bold()
//                    Text("Add Patient")
//                        .padding()
//                        .bold()
//                }
//                .background(Color.mainDark)
//                .background(Color.gray)
//                .clipShape(RoundedRectangle(cornerRadius: 12))
//                .padding()
                
            }
            ScrollView{
                PatientDetailsList(searchText: $searchtext)
            }
 
            
        }
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
    }
}

struct PatientDetailsList: View {
    @Binding var searchText: String
    var body: some View {
        
        LazyVStack {
            HStack{
                Text("Patient ID").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Patient Name").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Mobile Number").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Admitted date").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Doctor").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Status").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
            }.padding()
            
            
//            ForEach(0..<10) { _ in
//                HStack{
//                    Text("1234").frame(maxWidth: .infinity,alignment: .leading)
//                    Text("Aditya").frame(maxWidth: .infinity,alignment: .leading)
//                    Text("1234567890").frame(maxWidth: .infinity,alignment: .leading)
//                    Text("12/07/2024").frame(maxWidth: .infinity,alignment: .leading)
//                    Text("Dr. XYZ").frame(maxWidth: .infinity,alignment: .leading)
//                    Text("Admitted").frame(maxWidth: .infinity,alignment: .leading)
//                }.padding()
//                Divider()
//            }
//            ForEach(filteredPatients()) { patient in
//                PatientDetailsRow(patientdetails: patient)
//            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
    }
    
//    func filteredPatients() -> [Patient] {
//        if searchText.isEmpty {
//            return totalPatients
//        } else {
//            return totalPatients.filter { $0.name.lowercased().contains(searchText.lowercased()) }
//        }
//    }
}


//For bed booking
struct PatientDetailsRow: View {
    var patientdetails : Patient
    var body: some View {
        HStack{
            Text("\(patientdetails.userId)")
            Text("\(patientdetails.name)")
            Text("mobile number") // mobile number
            Text("admitted date") // will show admitted date
            Text("doctor") // will show doctor handlleing him
            Text("status") // admitted or discharged
            
//            Text("\(calculateAge(from: patientdetails.dateOfBirth))")
//            
//            // i need to show appointment date
//            Text("\(patientdetails.phoneNumber)")
        }
    }
}

//for calculating age from dob
func calculateAge(from dob: Date) -> Int {
    let calendar = Calendar.current
    let now = Date()
    let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
    return ageComponents.year!
}


//for getting only date from full date
func formattedDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}


#Preview {
    AdminOutPatientView()
}
