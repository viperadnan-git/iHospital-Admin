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
                            
                            Text(patient.name)
                                .font(.title)
                                .fontWeight(.bold)
                        }.frame(maxWidth: .infinity)
                            .padding()
                    }
                    
                    Section(header: Text("Patient's Information")) {
                        HStack {
                            Text("Age")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.dateOfBirth.ago)
                        }
                        
                        HStack {
                            Text("Phone No.")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.phoneNumber.string)
                        }
                        
                        HStack {
                            Text("Height")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.height?.string ?? "Unknown")
                                .foregroundColor(patient.height == nil ? .gray : .primary)
                        }
                        
                        HStack {
                            Text("Weight")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.weight?.string ?? "Unknown")
                                .foregroundColor(patient.weight == nil ? .gray : .primary)
                        }
                        
                        HStack {
                            Text("Blood Group")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.bloodGroup.id)
                        }
                        
                        HStack {
                            Text("Address")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.address)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Medical History")
                                .font(.title3)
                                .bold()
                            Spacer()
                            Button(action: {
                                showingModal.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("New Prescription").bold()
                                }
                            }
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
                        }.padding(.trailing)
                        
                        PatientMedicalRecords(patient: patient, selectedMedicalRecord: $selectedMedicalRecord)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Test Reports")
                            .font(.title3)
                            .bold()
                        
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
                }.frame(maxWidth: .infinity)
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
            }
        }.task {
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
                    Text(medicalRecord.appointment.date.dateString)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            Text(medicalRecord.note)
                .font(.subheadline)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            Image.asyncImage(loadData: medicalRecord.loadImage, cacheKey: "MRIMAGE#\(medicalRecord.id)")
                .frame(maxWidth: .infinity)
            
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
                }.frame(maxWidth: .infinity)
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
            }
        }.task {
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
                    Text(labTest.appointment.date.dateString)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            Text(labTest.test.name)
                .font(.title)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            LabTestStatusIndicator(status: labTest.status)
            
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
