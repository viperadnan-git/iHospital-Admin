//
//  AdminPatientDetailsView.swift
//  iHospital Admin
//
//  Created by Aditya on 07/07/24.
//

import SwiftUI

struct AdminPatientDetailsView: View {
    var patient: Patient
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .padding(40)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(patient.name)")
                        .font(.title)
                        .bold()
                    
                    Text("\(patient.userId)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    // Custom view for Age, Phone Number, and Address with proper spacing
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Age")
                                .fontWeight(.bold)
                            Spacer()
                            Text(patient.dateOfBirth.ago)
                        }
                        
                        HStack {
                            Text("Phone No")
                                .fontWeight(.bold)
                            Spacer()
                            Text(patient.phoneNumber.string)
                        }
                        
                        HStack(alignment: .top) {
                            Text("Address")
                                .fontWeight(.bold)
                            Spacer()
                            Text(patient.address).multilineTextAlignment(.trailing)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()
                
                Divider()
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Other Info")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 8) // Add some space below the title
                    
                    HStack {
                        Text("Blood Group:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(patient.bloodGroup)")
                    }
                    
                    HStack {
                        Text("Height:")
                            .fontWeight(.bold)
                        Spacer()
                        Text(String(format: "%.2f", patient.height ?? 0.00))
                    }
                    
                    HStack {
                        Text("Weight:")
                            .fontWeight(.bold)
                        Spacer()
                        Text(String(format: "%.2f", patient.weight ?? 0.00))
                    }
                }
                .padding(.trailing, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: 220, alignment: .leading)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            
            Text("Billing History")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            BillingList(patient: patient)
        }
        .navigationTitle("Patient Details")
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
                Spacer()
                VStack {
                    Text("No invoices found")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                Spacer()
            } else {
                Table(invoices) {
                    TableColumn("Invoice ID", value:\.id.string)
                    TableColumn("Amount") {
                        Text($0.amount.formatted(.currency(code: Constants.currencyCode)))
                    }
                    TableColumn("Payment Type", value: \.paymentType.name)
                    TableColumn("Date", value: \.createdAt.dateTimeString)
                    TableColumn("Status") {
                        PaymentStatusIndicator(status: $0.status)
                    }
                }
            }
        }
        .errorAlert(errorAlertMessage: errorAlertMessage)
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


struct PaymentStatusIndicator: View {
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
