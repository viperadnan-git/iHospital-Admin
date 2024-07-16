//
//  AdminPatientDetailsView.swift
//  iHospital Admin
//
//  Created by Aditya on 07/07/24.
//

import SwiftUI

struct AdminPatientDetailsView: View {
    var patient:Patient
    var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person")
                        .resizable()
                        .frame(maxWidth: 100,maxHeight: 100)
                        .padding(40)
                    VStack(alignment: .leading, spacing: 8){
                        Text("\(patient.name)").font(.title)
                            .bold()
                        Text("\(patient.userId)").font(.system(size: 12))
                        Text("Age: \(patient.dateOfBirth.ago)")
                        Text("Phone No:  \(patient.phoneNumber.string)")
                        Text("Address: \(patient.address)")
                    }
                    .padding()
                    Divider().padding()
                    VStack(alignment: .leading, spacing: 8){
                        Text("Other Info").font(.title3)
                            .bold()
                        Text("Blood Group: \(patient.bloodGroup)")
                        Text("Height: \(patient.height ?? 00)")
                        Text("Weight: \(patient.weight ?? 00)")
                    }
                    .padding()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 220,alignment: .leading)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
                
                Text("Billing History")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.horizontal)
                BillingList(patient: patient)
            }.navigationTitle("Patient Details")
            .navigationBarTitleDisplayMode(.inline)
    }
}


struct BillingList:View {
    var patient:Patient
    @State private var invoices:[Invoice] = []
    @State private var isLoading = true
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed to fetch invoices")
    
    var body: some View {
        VStack {
            if isLoading {
                CenterSpinner()
            } else if invoices.isEmpty {
                Text("No invoices found")
            } else {
                Table(invoices) {
                    TableColumn("Invoice ID", value:\.id.string)
                    TableColumn("Amount") {
                        Text($0.amount.formatted(.currency(code: Constants.currencyCode)))
                    }
                    TableColumn("Payment Type", value: \.paymentType.name)
                    TableColumn("Date", value: \.createdAt.dateTimeString)
                    TableColumn("Status") {
                        InvoiceStatusIndicator(status: $0.status)
                    }
                }
            }
        }.errorAlert(errorAlertMessage: errorAlertMessage)
        .onAppear(perform: fetchInvoices)
    }
    
    private func fetchInvoices() {
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                let invoices = try await patient.fetchInvoices()
                self.invoices = invoices
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}


struct InvoiceStatusIndicator: View {
    var status: PaymentStatus
    var body: some View {
        HStack {
            Circle()
                .fill(status.color)
                .frame(width: 10, height: 10)
            Text(status.rawValue)
        }
    }
}
