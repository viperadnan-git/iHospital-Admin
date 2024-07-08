import SwiftUI

struct AdminDoctorListView: View {
    let department: Department
    @StateObject private var adminDoctorViewModel = AdminDoctorViewModel()
    @State private var showingForm = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            if adminDoctorViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = adminDoctorViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else if adminDoctorViewModel.doctors.isEmpty {
                Text("No doctors found")
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(adminDoctorViewModel.doctors, id: \.userId) { doctor in
                            DoctorView(doctor: doctor)
                        }
                        .padding(.horizontal,4)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(department.name)
        .navigationBarItems(trailing: Button(action: {
            showingForm = true
            print("Plus button tapped")
        }) {
            Image(systemName: "plus")
                .font(.title3)
        })
        .sheet(isPresented: $showingForm) {
            AdminDoctorAddView(department: department).environmentObject(adminDoctorViewModel)
        }
        .task {
            adminDoctorViewModel.fetchDoctors(department: department)
        }
    }
}

struct DoctorView: View {
    let doctor: Doctor

    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
            Text(doctor.name)
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(doctor.email)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text("\(doctor.phoneNumber.formatted(.number))")
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.card)
        .cornerRadius(10)
    }
}

#Preview {
    AdminDoctorListView(department: Department(id: UUID(), name: "Cardiology", phoneNumber: nil))
}

