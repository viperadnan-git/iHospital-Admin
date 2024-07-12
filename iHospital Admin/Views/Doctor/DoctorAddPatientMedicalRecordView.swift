//
//  DoctorAddPatientMedicalRecord.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI
import PencilKit

struct DoctorAddPatientMedicalRecordView: View {
    @Environment(\.displayScale) var displayScale
    @EnvironmentObject private var doctorViewModel: DoctorViewModel
    @EnvironmentObject private var navigation: NavigationManager
    
    @Binding var isPresented: Bool
    @Binding var note: String
    @Binding var canvasView: PKCanvasView
    @Binding var medicines: [Medicine]
    @Binding var labTests: [LabTestItem]
    @Binding var canvasHeight: CGFloat

    @State private var dragOffset: CGSize = .zero
    @StateObject private var errorAlertMessage = ErrorAlertMessage()

    let predefinedLabTests = ["Complete Blood Count", "Blood Sugar", "Lipid Profile", "Liver Function Test", "Kidney Function Test"]
    let usageTypes = ["Oral", "Injection", "Topical"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notes")) {
                    TextEditor(text: $note)
                        .frame(height: 150)
                        .padding(.horizontal, 4)
                }

                Section(header: Text("Pencil Notes")) {
                    VStack {
                        DrawingCanvasView(canvasView: $canvasView)
                            .frame(height: canvasHeight)
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)

                        Image(systemName: "ellipsis.rectangle.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color(.systemGray))
                            .padding(.top, 6)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                        let newHeight = canvasHeight + dragOffset.height
                                        if newHeight >= 100 && newHeight <= 600 {
                                            canvasHeight = newHeight
                                        }
                                    }
                                    .onEnded { _ in
                                        dragOffset = .zero
                                    }
                            )
                    }
                }

                Section(header: Text("Medicines")) {
                    ForEach($medicines) { $medicine in
                        VStack {
                            HStack {
                                TextField("Medicine Name", text: $medicine.name)
                                    .padding(.vertical, 4)
                                Picker("Dosage", selection: $medicine.dosage) {
                                    ForEach(MedicineDosage.allCases, id: \.self) {
                                        Text($0.rawValue)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(.vertical, 4)
                                Divider()
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        if let index = medicines.firstIndex(where: { $0.id == medicine.id }) {
                                            medicines.remove(at: index)
                                        }
                                    }
                            }
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
                            Divider()
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red).onTapGesture {
                                    if let index = labTests.firstIndex(where: { $0.id == labTest.id }) {
                                        labTests.remove(at: index)
                                    }
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
        guard let appointment = doctorViewModel.appointments.first else {
            return
        }
        
        Task {
            do {
                let response = try await MedicalRecord.new(
                    note: note,
                    image: canvasView.drawing.image(from: canvasView.bounds, scale: 1).pngData()!,
                    medicines: medicines,
                    appointment: appointment
                )
                print(response)
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
    
    func unwind() {
        isPresented = false
        navigation.path.removeLast(navigation.path.count)
    }
}

enum MedicineDosage:String, Codable, CaseIterable {
    case onceADay = "Once a day"
    case twiceADay = "Twice a day"
    case thriceADay = "Three times a day"
}


struct Medicine: Identifiable {
    let id: UUID
    var name: String
    var dosage: MedicineDosage

    init(id: UUID = UUID(), name: String = "", dosage: MedicineDosage = .onceADay) {
        self.id = id
        self.name = name
        self.dosage = dosage
    }
    
    var text: String {
        "\(name) - \(dosage.rawValue)"
    }

    static var sample = Medicine(name: "Paracetamol", dosage: .onceADay)
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
