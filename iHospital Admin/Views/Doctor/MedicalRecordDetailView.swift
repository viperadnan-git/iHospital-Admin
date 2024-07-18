//
//  MedicalRecordDetailView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 17/07/24.
//

import SwiftUI

struct MedicalRecordDetailView: View {
    var medicalRecord: MedicalRecord
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Doctor Information")) {
                    HStack {
                        Text("Doctor")
                        Spacer()
                        Text(medicalRecord.appointment.doctor.name)
                    }
                    HStack {
                        Text("Patient")
                        Spacer()
                        Text(medicalRecord.patient.name)
                    }
                    HStack {
                        Text("Appointment Date")
                        Spacer()
                        Text(medicalRecord.appointment.date.dateTimeString)
                    }
                }
                
                Section(header: Text("Medical Note")) {
                    Text(medicalRecord.note)
                }
                
                Section(header: Text("Pencil Note")) {
                    Image.asyncImage(loadData: medicalRecord.loadImage)
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                
                if !medicalRecord.medicines.isEmpty {
                    Section(header: Text("Medicines")) {
                        ForEach(medicalRecord.medicines, id: \.self) { medicine in
                            Text(medicine)
                        }
                    }
                }
            }
            .navigationTitle("Medical Record")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
        }
    }
}

#Preview {
    MedicalRecordDetailView(medicalRecord: .sample)
}
