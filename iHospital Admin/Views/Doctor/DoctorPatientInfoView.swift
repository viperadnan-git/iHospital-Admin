//
//  DoctorPatientInfoView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI
import PencilKit
import PDFKit

struct DoctorPatientInfoView: View {
    var appointment: Appointment
    @State private var showingModal = false
    @State private var documentData: Data? = nil
    
    @State private var note: String = ""
    @State private var canvasView = PKCanvasView()
    @State private var medicines: [Medicine] = []
    @State private var labTests: [LabTestItem] = []
    @State private var canvasHeight: CGFloat = 200
    @State private var showAlert = false
    @State private var selectedMedicalRecord: MedicalRecord?
    @State private var selectedLabTest: LabTest?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        let patient = appointment.patient
        GeometryReader { geometry in
            HStack(spacing: 12) {
                Form {
                    Section {
                        VStack(alignment: .center, spacing: 20) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .accessibilityHidden(true)
                            
                            Text(patient.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .accessibilityLabel("Patient name")
                                .accessibilityValue(patient.name)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    
                    Section(header: Text("Patient's Information")) {
                        HStack {
                            Text("Age")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.dateOfBirth.ago)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Age")
                        .accessibilityValue(patient.dateOfBirth.ago)
                        
                        HStack {
                            Text("Phone No.")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.phoneNumber.string)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Phone Number")
                        .accessibilityValue(patient.phoneNumber.string)
                        
                        HStack {
                            Text("Height")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.height?.string ?? "Unknown")
                                .foregroundColor(patient.height == nil ? .gray : .primary)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Height")
                        .accessibilityValue(patient.height?.string ?? "Unknown")
                        
                        HStack {
                            Text("Weight")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.weight?.string ?? "Unknown")
                                .foregroundColor(patient.weight == nil ? .gray : .primary)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Weight")
                        .accessibilityValue(patient.weight?.string ?? "Unknown")
                        
                        HStack {
                            Text("Blood Group")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.bloodGroup.id)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Blood Group")
                        .accessibilityValue(patient.bloodGroup.id)
                        
                        HStack {
                            Text("Address")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.address)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Address")
                        .accessibilityValue(patient.address)
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Medical History")
                                .font(.title3)
                                .bold()
                                .accessibilityAddTraits(.isHeader)
                            Spacer()
                            Button(action: {
                                showingModal.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("New Prescription").bold()
                                }
                            }
                            .accessibilityLabel("New Prescription")
                            .sheet(isPresented: $showingModal) {
                                DoctorAddPatientMedicalRecordView(
                                    appointment: appointment,
                                    isPresented: $showingModal,
                                    note: $note,
                                    canvasView: $canvasView,
                                    medicines: $medicines,
                                    labTests: $labTests,
                                    canvasHeight: $canvasHeight
                                )
                            }
                        }
                        .padding(.trailing)
                        
                        PatientMedicalRecords(patient: patient, selectedMedicalRecord: $selectedMedicalRecord)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Test Reports")
                            .font(.title3)
                            .bold()
                            .accessibilityAddTraits(.isHeader)
                        
                        PatientLabTestReports(patient: patient, selectedLabTest: $selectedLabTest)
                    }
                }
                .frame(width: geometry.size.width * 0.56)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            showAlert = true
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        })
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Discard Draft"),
                message: Text("Your draft prescription will be cleared if you go back. Are you sure you want to discard the draft?"),
                primaryButton: .destructive(Text("Discard")) {
                    self.presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(item: $selectedMedicalRecord) { medicalRecord in
            MedicalRecordDetailView(medicalRecord: medicalRecord)
        }
        .sheet(item: $selectedLabTest) { labTest in
            LabTestDetailView(labTest: labTest)
        }
    }
}

struct PatientMedicalRecords: View {
    var patient: Patient
    
    @State private var isLoading: Bool = false
    @State private var medicalRecords: [MedicalRecord] = []
    @Binding var selectedMedicalRecord: MedicalRecord?
    
    @StateObject private var errorMessageAlert = ErrorAlertMessage(title: "Failed to load medical records")
    
    var body: some View {
        VStack {
            if isLoading {
                CenterSpinner()
                    .accessibilityLabel("Loading medical records")
            } else if medicalRecords.isEmpty {
                VStack {
                    Spacer()
                    VStack {
                        Image(systemName: "doc.text.magnifyingglass")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        Text("No past medical records available")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .accessibilityLabel("No past medical records available")
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(medicalRecords) { medicalRecord in
                            MedicalRecordCardView(medicalRecord: medicalRecord, selectedMedicalRecord: $selectedMedicalRecord)
                                .frame(width: 250)
                                .cornerRadius(10)
                                .padding(.vertical)
                        }
                    }
                    .padding(.horizontal)
                    .errorAlert(errorAlertMessage: errorMessageAlert)
                }
                .accessibilityElement(children: .contain)
            }
        }
        .task {
            await fetchMedicalRecords()
        }
    }
    
    func fetchMedicalRecords() async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            medicalRecords = try await patient.fetchMedicalRecords()
        } catch {
            errorMessageAlert.message = error.localizedDescription
        }
    }
}

struct MedicalRecordCardView: View {
    var medicalRecord: MedicalRecord
    @Binding var selectedMedicalRecord: MedicalRecord?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("By \(medicalRecord.appointment.doctor.name)")
                        .font(.headline)
                        .accessibilityLabel("Doctor")
                        .accessibilityValue(medicalRecord.appointment.doctor.name)
                    Text(medicalRecord.appointment.date.dateString)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .accessibilityLabel("Date")
                        .accessibilityValue(medicalRecord.appointment.date.dateString)
                }
                Spacer()
            }
            
            Text(medicalRecord.note)
                .font(.subheadline)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .accessibilityLabel("Medical Note")
                .accessibilityValue(medicalRecord.note)
            
            Image.asyncImage(loadData: medicalRecord.loadImage, cacheKey: "MRIMAGE#\(medicalRecord.id)")
                .frame(maxWidth: .infinity)
                .accessibilityLabel("Medical Note Image")
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: {
                    selectedMedicalRecord = medicalRecord
                }) {
                    Text("View")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .accessibilityLabel("View Medical Record")
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .frame(width: 250)
    }
}

struct PatientLabTestReports: View {
    var patient: Patient
    
    @State private var isLoading: Bool = false
    @State private var labTests: [LabTest] = []
    @Binding var selectedLabTest: LabTest?
    
    @StateObject private var errorMessageAlert = ErrorAlertMessage(title: "Failed to load lab tests")
    
    var body: some View {
        VStack {
            if isLoading {
                CenterSpinner()
                    .accessibilityLabel("Loading lab test reports")
            } else if labTests.isEmpty {
                VStack {
                    Spacer()
                    VStack {
                        Image(systemName: "doc.text.magnifyingglass")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        Text("No past lab tests available")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .accessibilityLabel("No past lab tests available")
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(labTests) { labTest in
                            LabTestCardView(labTest: labTest, selectedLabTest: $selectedLabTest)
                                .frame(width: 250)
                                .cornerRadius(10)
                                .padding(.vertical)
                        }
                    }
                    .padding(.horizontal)
                    .errorAlert(errorAlertMessage: errorMessageAlert)
                }
                .accessibilityElement(children: .contain)
            }
        }
        .task {
            await fetchLabTests()
        }
    }
    
    func fetchLabTests() async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            labTests = try await patient.fetchLabTests()
        } catch {
            errorMessageAlert.message = error.localizedDescription
        }
    }
}

struct LabTestCardView: View {
    var labTest: LabTest
    @Binding var selectedLabTest: LabTest?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("By \(labTest.appointment.doctor.name)")
                        .font(.headline)
                        .accessibilityLabel("Doctor")
                        .accessibilityValue(labTest.appointment.doctor.name)
                    Text(labTest.appointment.date.dateString)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .accessibilityLabel("Date")
                        .accessibilityValue(labTest.appointment.date.dateString)
                }
                Spacer()
            }
            
            Text(labTest.test.name)
                .font(.title)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .accessibilityLabel("Test Name")
                .accessibilityValue(labTest.test.name)
            
            LabTestStatusIndicator(status: labTest.status)
                .accessibilityLabel("Test Status")
                .accessibilityValue(labTest.status.rawValue.capitalized)
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: {
                    selectedLabTest = labTest
                }) {
                    Text("View")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .accessibilityLabel("View Lab Test Report")
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .frame(width: 250)
    }
}

struct LabTestStatusIndicator: View {
    let status: LabTestStatus
    
    var body: some View {
        HStack {
            Circle()
                .fill(status.color)
                .frame(width: 10, height: 10)
            Text(status.rawValue.capitalized)
                .font(.footnote)
        }
    }
}

#Preview {
    DoctorPatientInfoView(appointment: Appointment.sample)
}
