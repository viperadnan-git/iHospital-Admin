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
                Section(header: Text("Doctor Information").accessibilityAddTraits(.isHeader)) {
                    HStack {
                        Text("Doctor")
                        Spacer()
                        Text(medicalRecord.appointment.doctor.name)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Doctor")
                    .accessibilityValue(medicalRecord.appointment.doctor.name)
                    
                    HStack {
                        Text("Patient")
                        Spacer()
                        Text(medicalRecord.patient.name)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Patient")
                    .accessibilityValue(medicalRecord.patient.name)
                    
                    HStack {
                        Text("Appointment Date")
                        Spacer()
                        Text(medicalRecord.appointment.date.dateTimeString)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Appointment Date")
                    .accessibilityValue(medicalRecord.appointment.date.dateTimeString)
                }
                
                Section(header: Text("Medical Note").accessibilityAddTraits(.isHeader)) {
                    Text(medicalRecord.note)
                        .accessibilityLabel("Medical Note")
                        .accessibilityValue(medicalRecord.note)
                }
                
                Section(header: Text("Pencil Note").accessibilityAddTraits(.isHeader)) {
                    Image.asyncImage(loadData: medicalRecord.loadImage, cacheKey: "MRIMAGE#\(medicalRecord.id)")
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .accessibilityLabel("Pencil Note Image")
                }
                
                if !medicalRecord.medicines.isEmpty {
                    Section(header: Text("Medicines").accessibilityAddTraits(.isHeader)) {
                        ForEach(medicalRecord.medicines, id: \.self) { medicine in
                            Text(medicine)
                                .accessibilityLabel("Medicine")
                                .accessibilityValue(medicine)
                        }
                    }
                }
            }
            .navigationTitle("Medical Record")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            }
            .accessibilityLabel("Close")
            .accessibilityHint("Close the medical record detail view"))
        }
    }
}

#Preview {
    MedicalRecordDetailView(medicalRecord: .sample)
}
