//
//  AdminLabTestAddForm.swift
//  iHospital Admin
//
//  Created by Aditya on 16/07/24.
//

import SwiftUI

struct AdminLabTestAddForm: View {
    var labTestType: LabTestType? = nil
    
    @State private var name = ""
    @State private var price = ""
    @State private var description = ""
    @State private var showAlert = false
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed")
    
    @EnvironmentObject private var viewModel: LabTestTypeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Lab Test Details")) {
                    TextField("Name", text: $name)
                    TextField("Price", text: $price).keyboardType(.numberPad)
                    TextField("Description", text: $description)
                }
                if labTestType != nil {
                    Section {
                        Button("Delete Lab Test",role: .destructive) {
                            print("Delete button tapped")
                            showAlert.toggle()
                            
                        }.frame(maxWidth: .infinity,alignment: .center)
                            .alert(isPresented: $showAlert, content: {
                                Alert(title: Text("Delete Lab Test"), message: Text("Are you sure you want to delete this lab test?"), primaryButton: .destructive(Text("Delete"),action: {
                                    delete()
                                }), secondaryButton: .cancel())
                            })
                    }
                }
            }
            .navigationTitle("\(labTestType == nil ? "Add New":"Edit") Lab Test Type")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    print("Cancel button tapped")
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    save()
                }
            )
            .errorAlert(errorAlertMessage: errorAlertMessage)
            .onAppear(perform: onAppear)
        }
    }
    
    private func onAppear() {
        if let labTestType = labTestType {
            name = labTestType.name
            price = labTestType.price.string
            description = labTestType.description
        }
    }
    
    private func delete() {
        Task {
            do {
                if let labTestType = labTestType {
                    try await viewModel.delete(labTestType: labTestType)
                    presentationMode.wrappedValue.dismiss()
                }
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
    
    private func save() {
        guard let price = Int(price) else { return }
        
        Task {
            do {
                if let labTestType = labTestType {
                    labTestType.name = name
                    labTestType.price = price
                    labTestType.description = description
                    
                    try await viewModel.save(labTestType: labTestType)
                } else {
                    try await viewModel.new(name: name, price: price, description: description)
                }
                
                presentationMode.wrappedValue.dismiss()
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    NavigationView {
        AdminLabTestAddForm()
    }
}
