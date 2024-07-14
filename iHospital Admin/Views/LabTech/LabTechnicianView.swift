//
//  LabTechnicianView.swift
//  iHospital Admin
//
//  Created by Aditya on 13/07/24.
//

import SwiftUI
var dummyData = [
    LabTest(id: 1, name: "X-Ray", patient: Patient.sample, status: .pending, appointment: Appointment.sample, reportPath: "something"),
    LabTest(id: 2, name: "Blood Test", patient: Patient.sample, status: .completed, appointment: Appointment.sample, reportPath: "something"),
    LabTest(id: 3, name: "Urine Test", patient: Patient.sample, status: .pending, appointment: Appointment.sample, reportPath: "something"),
    LabTest(id: 4, name: "CT Scan", patient: Patient.sample, status: .completed, appointment: Appointment.sample, reportPath: "something"),
    LabTest(id: 5, name: "MRI", patient: Patient.sample, status: .pending, appointment: Appointment.sample, reportPath: "something"),

]

struct LabTechnicianView: View {
   
    
    @State private var sampleButtonAlertBox:Bool = false
    @State private var sampleButton:Bool = true
    @State private var uploadButton:Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack{
                LabTechCard(title:"24", subtitle: "sample collected", color: .red)
                LabTechCard(title:"4", subtitle: "Sample Left", color: .purple)
                
            }
            .padding()
            
            Text("Today's Lab Tests")
                .font(.title)
                .bold()
                .padding()
            
            Table(dummyData) {
                TableColumn("Name", value: \.patient.name)
                TableColumn("Gender", value: \.name)
                TableColumn("Status") { labtest in
                    
                    if sampleButton {
                        Button(action: {
                            print("Sample Collected")
                            sampleButtonAlertBox.toggle()
                            
                            
                        }) {
                            Text("Sample Collected")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(5)
                        }
                        .alert(isPresented: $sampleButtonAlertBox, content: {
                            Alert(title: Text("Sample Collection"), message: Text("Are you sure want to confirm the sample collection"), primaryButton: .destructive(Text("Confirm"),action: {
                                sampleButtonAlertBox.toggle()
                                uploadButton.toggle()
                                sampleButton.toggle()
//                                labtests.status = .inProgress
                            }), secondaryButton: .cancel())
                        })
                    }
                    else if uploadButton{
                        
                        Button(action: {
                            print("Report Uploaded")
//                            labtests.status = .completed
//                            sampleButton.toggle()
                        }) {
                            Text("Upload Report")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(5)
                        }
                    }
                    else{
                        Text("Completed")
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

