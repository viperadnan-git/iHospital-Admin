//
//  DoctorAddPatientMedicalRecord.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI
import PencilKit

struct DoctorAddPatientMedicalRecordView: View {
    var appointment: Appointment
    
    @Environment(\.displayScale) var displayScale
    @EnvironmentObject private var doctorViewModel: DoctorViewModel
    @EnvironmentObject private var navigation: NavigationManager
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isPresented: Bool
    @Binding var note: String
    @Binding var canvasView: PKCanvasView
    @Binding var medicines: [Medicine]
    @Binding var labTests: [LabTestItem]
    @Binding var canvasHeight: CGFloat

    @State private var dragOffset: CGSize = .zero
    @State private var labTestTypes: [LabTestType] = LabTestType.all
    @StateObject private var errorAlertMessage = ErrorAlertMessage()
    @State private var showAlert = false
    @State private var isLoading = false
    @State private var noteError: String?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notes")) {
                    TextEditor(text: $note)
                        .frame(height: 150)
                        .padding(.horizontal, 4)
                        .onChange(of: note) { _ in validateNote() }
                        .overlay(Image.validationIcon(for: noteError), alignment: .trailing)
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
                                Menu {
                                    ForEach(MedicineDosage.allCases, id: \.self) { dosage in
                                        Button(action: {
                                            medicine.dosage = dosage
                                        }) {
                                            Text(dosage.rawValue)
                                        }
                                    }
                                } label: {
                                    Text(medicine.dosage.rawValue)
                                        .padding(.vertical, 4)
                                }
                                Divider()
                                Button {
                                    if let index = medicines.firstIndex(where: { $0.id == medicine.id }) {
                                        medicines.remove(at: index)
                                    }
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                }.buttonStyle(.borderless)
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
                            Menu {
                                ForEach(labTestTypes, id: \.id) { test in
                                    Button(action: {
                                        labTest.selectedTest = test.id.string
                                        labTest.name = test.name
                                    }) {
                                        Text(test.name)
                                    }
                                }
                            } label: {
                                Text(labTest.selectedTest.isEmpty ? "Select Test" : labTest.name)
                            }
                            Spacer()
                            Divider()
                            Button {
                                if let index = labTests.firstIndex(where: { $0.id == labTest.id }) {
                                    labTests.remove(at: index)
                                }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                            }.buttonStyle(.borderless)
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
                if !isLoading {
                    isPresented = false
                }
            }.disabled(isLoading), trailing: Button(action: {
                validateNote()
                
                guard noteError == nil else {
                    errorAlertMessage.message = "Please fill all the fields correctly"
                    return
                }
                
                showAlert = true
            }) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Add")
                }
            })
            .errorAlert(errorAlertMessage: errorAlertMessage)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Confirm Save"),
                    message: Text("Are you sure you want to save this prescription?"),
                    primaryButton: .default(Text("Save")) {
                        onAdd()
                    },
                    secondaryButton: .cancel()
                )
            }.onAppear {
                Task {
                    do {
                        labTestTypes = try await LabTestType.fetchAll()
                    } catch {
                        errorAlertMessage.message = error.localizedDescription
                    }
                }
            }
        }
    }

    private func validateNote() {
        if note.isEmpty {
            noteError = "Note is required."
        } else {
            noteError = nil
        }
    }

    func onAdd() {
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                let selectedLabTestIds = labTests.filter { !$0.selectedTest.isEmpty }.compactMap { Int($0.selectedTest) ?? 0 }
                let backgroundColor = colorScheme == .dark ? UIColor.black : UIColor.white
                let imageData = canvasView.drawingImage(from: canvasView.bounds, scale: displayScale, backgroundColor: backgroundColor)?.pngData()
                
                try await MedicalRecord.new(
                    note: note,
                    image: imageData!,
                    medicines: medicines,
                    labTests: selectedLabTestIds,
                    appointment: appointment
                )
                try await doctorViewModel.markStatusCompleted(for: appointment)
                unwind()
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

enum MedicineDosage: String, Codable, CaseIterable {
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

#Preview {
    DoctorAddPatientMedicalRecordView(
        appointment: Appointment.sample,
        isPresented: .constant(true),
        note: .constant(""),
        canvasView: .constant(PKCanvasView()),
        medicines: .constant([]),
        labTests: .constant([]),
        canvasHeight: .constant(300)
    )
    .environmentObject(DoctorViewModel())
    .environmentObject(NavigationManager())
}
