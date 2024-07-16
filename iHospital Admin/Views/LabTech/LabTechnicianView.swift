//
//  LabTechnicianView.swift
//  iHospital Admin
//
//  Created by Aditya on 13/07/24.
//

import SwiftUI
var dummyData = [
    LabTest.sample, LabTest.sample, LabTest.sample, LabTest.sample, LabTest.sample
]

struct LabTechnicianView: View {
    @StateObject private var labTechViewModel = LabTechViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    LabTechCard(title: String(labTechViewModel.labTests.count), subtitle: "Tota; Tests", color: .blue)
                    LabTechCard(title:"4", subtitle: "Sample Left", color: .green)
                }
                .padding()
                
                HStack {
                    Text("Lab Tests")
                        .font(.title)
                        .bold()
                        .padding()
                    Spacer()
                    NavigationLink(destination: LabTechTable()){
                        Text("View All")
                            .font(.subheadline)
                            .padding()
                            .foregroundColor(.accentColor)
                    }
                 
                }.padding(.horizontal)
                
                
                if labTechViewModel.isLoading {
                    CenterSpinner()
                } else if labTechViewModel.labTests.isEmpty {
                    Spacer()
                    Text("No lab tests")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    Table(labTechViewModel.labTests) {
                        TableColumn("Name", value: \.patient.name)
                        TableColumn("Gender", value:\.patient.gender.id.capitalized)
                        TableColumn("Age", value: \.patient.dateOfBirth.ago)
                        TableColumn("Test", value: \.test.name)
                        TableColumn("Status") { test in
                            LabTestStatusIndicator(status: test.status)
                        }
                        TableColumn("") { test in
                            NavigationLink(destination: LabTestView(testId: test.id).environmentObject(labTechViewModel)) {
                                Image(systemName: "chevron.forward")
                            }
                        }.width(40)
                    }.refreshable {
                        labTechViewModel.fetchLabTests(showLoader: false)
                    }
                }
            }.navigationTitle("Lab Technician")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            do {
                                try await SupaUser.logout()
                            } catch {
                                print(error)
                            }
                        }
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                    }
                }
            }
        }
    }
}


struct LabTechCard: View {
    @State var title: String?
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack {
            if title != nil {
                Text(title!)
                    .font(.largeTitle)
                    .bold()
            } else {
                ProgressView()
                    .padding()
            }
            
            Text(subtitle)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(color)
        .cornerRadius(12)
        .foregroundColor(.white)
    }
}

#Preview {
    LabTechnicianView()
}

