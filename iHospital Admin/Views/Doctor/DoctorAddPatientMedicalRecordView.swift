//
//  DoctorAddPatientMedicalRecord.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI
import PencilKit

struct DoctorAddPatientMedicalRecordView: View {
    @Binding var isPresented: Bool
    var patient: Patient
    
    @State private var note: String = ""
    @State private var canvasChanged = false
    @State private var canvasImage: UIImage? = nil
    @State private var medicines: [Medicine] = []
    @State private var labTests: [LabTestItem] = [LabTestItem()]

    let predefinedLabTests = ["Complete Blood Count", "Blood Sugar", "Lipid Profile", "Liver Function Test", "Kidney Function Test"]
    let dosageTimings = ["Once a day", "Twice a day", "Three times a day"]
    let usageTypes = ["Oral", "Injection", "Topical"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notes")) {
                    TextEditor(text: $note)
                        .frame(height: 150)
                        .padding(.horizontal, 4)
                }

                Section(header: Text("Penic Notes")) {
                    DrawingCanvasView(canvasChanged: $canvasChanged, canvasImage: $canvasImage)
                        .frame(height: 200)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                }

                Section(header: Text("Medicines")) {
                    ForEach($medicines) { $medicine in
                        VStack {
                            TextField("Medicine Name", text: $medicine.name)
                                .padding(.vertical, 4)
                            Picker("Usage", selection: $medicine.usage) {
                                ForEach(usageTypes, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.vertical, 4)
                            Picker("Dosage", selection: $medicine.dosage) {
                                ForEach(dosageTimings.indices, id: \.self) {
                                    Text(dosageTimings[$0])
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.vertical, 4)
                        }
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            medicines.append(Medicine())
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Medicine")
                            }
                        }
                    }
                }

                Section(header: Text("Lab Tests")) {
                    ForEach($labTests) { $labTest in
                        HStack {
                            TextField("Lab Test Name", text: $labTest.name)
                            Spacer()
                            Menu {
                                ForEach(predefinedLabTests, id: \.self) { test in
                                    Button(action: {
                                        labTest.selectedTest = test
                                        labTest.name = test
                                    }) {
                                        Text(test)
                                    }
                                }
                            } label: {
                                Text(labTest.selectedTest.isEmpty ? "Select Test" : labTest.selectedTest)
                            }
                        }
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            labTests.append(LabTestItem())
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Lab Test")
                            }
                        }
                    }
                }
            }
            .interactiveDismissDisabled()
            .navigationTitle("New Prescription")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }, trailing: Button(action: onAdd) {
                Text("Add")
            })
        }
    }
    
    func onAdd() {
        defer {
            isPresented = false
        }
        
        print(note)
        
        for medicine in medicines {
            print(medicine.name)
            print(medicine.usage)
            print(medicine.dosage)
        }

        for labTest in labTests {
            print(labTest.name)
        }
        
        if let pngData = canvasImage?.pngData() {
            print("png data")
            print(pngData)
        }
    }
}

struct Medicine: Identifiable {
    let id: UUID
    var name: String
    var usage: String
    var dosage: Int
    
    init(id: UUID = UUID(), name: String = "", usage: String = "", dosage: Int = 0) {
        self.id = id
        self.name = name
        self.usage = usage
        self.dosage = dosage
    }
    
    static var sample = Medicine(name: "Paracetamol", usage: "Oral", dosage: 1)
}

struct LabTestItem: Identifiable {
    let id: UUID
    var name: String
    var selectedTest: String
    
    init(id: UUID = UUID(), name: String = "", selectedTest: String = "") {
        self.id = id
        self.name = name
        self.selectedTest = selectedTest
    }
    
    static var sample = LabTestItem(name: "Complete Blood Count", selectedTest: "Complete Blood Count")
}


#Preview {
    DoctorAddPatientMedicalRecordView(isPresented: .constant(true), patient: Patient.sample)
}
