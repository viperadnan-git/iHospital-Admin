//
//  PrescriptionView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI

struct PrescriptionPDFView: View {
    var note: String
    var canvasImage: UIImage
    var medicines: [Medicine]
    var labTests: [LabTestItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Prescription")
                .font(.largeTitle)
                .bold()
                .accessibilityLabel("Prescription Title")
            
            Text("Notes")
                .font(.headline)
                .accessibilityLabel("Notes Header")
            
            Text(note)
                .accessibilityLabel("Prescription Notes")
                .accessibilityHint("Description of the patient's condition or additional instructions")
            
            Image(uiImage: canvasImage)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)
                .accessibilityLabel("Prescription Image")
                .accessibilityHint("An image associated with the prescription")
            
            if !medicines.isEmpty {
                Text("Medicines")
                    .font(.headline)
                    .accessibilityLabel("Medicines Header")
                
                ForEach(medicines) { medicine in
                    Text(medicine.text)
                        .accessibilityLabel("Medicine: \(medicine.text)")
                }
            }
            
            if !labTests.isEmpty {
                Text("Lab Tests")
                    .font(.headline)
                    .accessibilityLabel("Lab Tests Header")
                
                ForEach(labTests) { labTest in
                    Text(labTest.name)
                        .accessibilityLabel("Lab Test: \(labTest.name)")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .accessibilityLabel("Prescription View")
        .accessibilityHint("Displays the prescription details including notes, medicines, and lab tests")
    }
}
