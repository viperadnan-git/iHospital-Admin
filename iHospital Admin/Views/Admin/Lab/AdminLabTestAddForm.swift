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
    
    @State private var nameError: String?
    @State private var priceError: String?
    @State private var descriptionError: String?
    
    @FocusState private var focusedField: Field?
    @State private var isSaving = false
    
    enum Field {
        case name
        case price
        case description
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Lab Test Details")) {
                    TextField("Name", text: $name)
                        .focused($focusedField, equals: .name)
                        .onChange(of: name) { _ in validateName() }
                        .overlay(Image.validationIcon(for: nameError), alignment: .trailing)
                        .accessibilityLabel("Lab Test Name")
                        .accessibilityHint("Enter the name of the lab test")
                    
                    TextField("Price", text: $price)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .price)
                        .onChange(of: price) { _ in validatePrice() }
                        .overlay(Image.validationIcon(for: priceError), alignment: .trailing)
                        .accessibilityLabel("Lab Test Price")
                        .accessibilityHint("Enter the price of the lab test")
                    
                    TextField("Description", text: $description)
                        .focused($focusedField, equals: .description)
                        .onChange(of: description) { _ in validateDescription() }
                        .overlay(Image.validationIcon(for: descriptionError), alignment: .trailing)
                        .accessibilityLabel("Lab Test Description")
                        .accessibilityHint("Enter a description for the lab test")
                }
                
                if let labTestType = labTestType {
                    Section {
                        Button("Delete \"\(labTestType.name)\"", role: .destructive) {
                            showAlert.toggle()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Delete Lab Test"),
                                message: Text("Are you sure you want to delete \"\(labTestType.name)\" lab test?"),
                                primaryButton: .destructive(Text("Delete"), action: delete),
                                secondaryButton: .cancel()
                            )
                        }
                        .accessibilityLabel("Delete Lab Test")
                        .accessibilityHint("Deletes the current lab test")
                    }
                }
            }
            .navigationTitle("\(labTestType == nil ? "Add New":"Edit") Lab Test Type")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    print("Cancel button tapped")
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(isSaving)
                .accessibilityLabel("Cancel")
                .accessibilityHint("Cancels adding or editing the lab test"),
                trailing: Button("Save") {
                    save()
                }
                .disabled(isSaving)
                .accessibilityLabel("Save")
                .accessibilityHint("Saves the lab test")
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
        validateName()
        validatePrice()
        validateDescription()
        
        guard nameError == nil,
              priceError == nil,
              descriptionError == nil,
              !name.isEmpty,
              !price.isEmpty,
              !description.isEmpty else {
            errorAlertMessage.message = "Please fill all the fields correctly"
            return
        }
        
        guard let price = Int(price) else {
            errorAlertMessage.message = "Invalid price"
            return
        }
        
        isSaving = true
        defer {
            isSaving = false
        }
        
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
    
    private func validateName() {
        if name.isEmpty {
            nameError = "Name is required."
        } else if name.count < 3 {
            nameError = "Name must be at least 3 characters."
        } else if name.count > 50 {
            nameError = "Name must be less than 50 characters."
        } else {
            nameError = nil
        }
    }

    private func validatePrice() {
        if price.isEmpty {
            priceError = "Price is required."
        } else if let priceValue = Int(price), priceValue < 50 {
            priceError = "Price must be equal or greater than 50."
        } else {
            priceError = nil
        }
    }

    private func validateDescription() {
        if description.isEmpty {
            descriptionError = "Description is required."
        } else {
            descriptionError = nil
        }
    }
}

#Preview {
    NavigationView {
        AdminLabTestAddForm()
    }
}
