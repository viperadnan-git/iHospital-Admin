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
            Text("Notes")
                .font(.headline)
            Text(note)
            
            Image(uiImage: canvasImage)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)
            
            if !medicines.isEmpty {
                Text("Medicines")
                    .font(.headline)
                ForEach(medicines) { medicine in
                    Text(medicine.text)
                }
            }
            if !labTests.isEmpty {
                Text("Lab Tests")
                    .font(.headline)
                ForEach(labTests) { labTest in
                    Text(labTest.name)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
