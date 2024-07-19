//
//  AdminLabTechTypeView.swift
//  iHospital Admin
//
//  Created by Aditya on 16/07/24.
//

import SwiftUI

struct AdminLabTechTypeView: View {
    @StateObject private var viewModel = LabTestTypeViewModel()
    
    @State private var showForm = false
    @State private var selectedLabTestType: LabTestType?
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(2)
                    .accessibilityLabel("Loading")
            } else if viewModel.labTestTypes.isEmpty {
                Text("No Lab Tests Found")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color(.systemGray))
                    .accessibilityLabel("No lab tests found")
            } else {
                Table(filterLabTestTypes) {
                    TableColumn("Test Id", value: \.id.string)
                    TableColumn("Name", value: \.name)
                    TableColumn("Price") {
                        Text($0.price.formatted(.currency(code: Constants.currencyCode)))
                    }
                    TableColumn("Description", value: \.description)
                    TableColumn("") { labTestType in
                        Button("Edit") {
                            selectedLabTestType = labTestType
                            DispatchQueue.main.async {
                                showForm = true
                            }
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel("Edit lab test \(labTestType.name)")
                    }
                }
                .refreshable {
                    viewModel.fetchAll(showLoader: false)
                }
            }
        }
        .navigationTitle("Lab Tests")
        .navigationBarItems(trailing: Button(action: {
            print("Plus button tapped")
            selectedLabTestType = nil
            DispatchQueue.main.async {
                showForm = true
            }
        }) {
            Image(systemName: "plus")
                .font(.title3)
                .accessibilityLabel("Add new lab test")
        })
        .sheet(isPresented: $showForm) {
            if let labTestType = selectedLabTestType {
                AdminLabTestAddForm(labTestType: labTestType)
                    .environmentObject(viewModel)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Edit lab test form for \(labTestType.name)")
            } else {
                AdminLabTestAddForm()
                    .environmentObject(viewModel)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Add new lab test form")
            }
        }
        .searchable(text: $searchText)
    }
    
    private var filterLabTestTypes: [LabTestType] {
        if searchText.isEmpty {
            return viewModel.labTestTypes
        } else {
            return viewModel.labTestTypes.filter { labTestType in
                labTestType.name.lowercased().contains(searchText.lowercased())
                || labTestType.id.string.lowercased().contains(searchText.lowercased())
                || labTestType.description.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

#Preview {
    AdminLabTechTypeView()
}
