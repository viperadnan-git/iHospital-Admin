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
                Image(systemName: "xmark.bin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                    .foregroundColor(.gray)
                
                Text("No doctors found in \(department.name) department")
                    .font(.title)
                    .foregroundColor(.gray)
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
                .scaledToFit()
                .foregroundColor(Color(.systemGray))
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            Text(doctor.name)
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            HStack(spacing: 2) {
                Image(systemName: "envelope.fill")
                Text(doctor.email)
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            
            HStack(spacing: 2) {
                Image(systemName: "phone.fill")
                Text(String(doctor.phoneNumber))
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    AdminDoctorListView(department: Department(id: UUID(), name: "Cardiology", phoneNumber: nil))
}

