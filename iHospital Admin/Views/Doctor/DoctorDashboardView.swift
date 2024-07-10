import SwiftUI

struct DoctorDashboardView: View {
    @StateObject private var doctorDetailViewModel = DoctorDetailViewModel()
    @State private var searchText = ""
    @State private var appointments: [Appointment] = []
    
    var body: some View {
            if doctorDetailViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(2)
            } else {
                NavigationStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 20) {
                        
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Current Patient")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                if let firstAppointment = appointments.first {
                                    Text("\(firstAppointment.patient.name)")
                                        .foregroundColor(.white)
                                        .font(.title)
                                    Text("Age: \(firstAppointment.patient.dateOfBirth.age)")
                                        .foregroundColor(.white)
                                    Text("Phone: \(firstAppointment.patient.phoneNumber)")
                                        .foregroundColor(.white)
                                    Text("Time: \(firstAppointment.date.timeString)")
                                        .foregroundColor(.white)
                                } else {
                                    Text("No current appointment")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.4 - 20)
                            .background(Color.red.opacity(0.5))
                            .cornerRadius(10)
                            
                            // Blue Box 1 (occupy rest of the available space)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                                .overlay(
                                    VStack(alignment: .leading) {
                                        Text("Appointments Left")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .padding(.top, 10)
                                        Spacer()
                                    }
                                    .padding()
                                )
                                .frame(maxWidth: .infinity, maxHeight: 180)
                            
                            // Blue Box 2 (occupy rest of the available space)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                                .overlay(
                                    VStack(alignment: .leading) {
                                        Text("Revenue")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .padding(.top, 10)
                                        Spacer()
                                    }
                                    .padding()
                                )
                                .frame(maxWidth: .infinity, maxHeight: 180)
                        }
                        .frame(height: 180)
                        .padding(.horizontal, 20)
                        
                        HStack {
                            Text("Appointments")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            NavigationLink {
                                DoctorAppointmentsView().environmentObject(doctorDetailViewModel)
                            } label: {
                                Text("View All")
                            }
                        }.padding()
                        
                        DoctorAppointmentsTable()
                            .onAppear {
                                Task {
                                    do {
                                        appointments = try await Appointment.fetchAppointments()
                                    } catch {
                                        print("Error fetching appointments: \(error.localizedDescription)")
                                    }
                                }
                            }
                        
                        Spacer()
                    }
                    .padding()
                    .navigationTitle("Hello \(doctorDetailViewModel.doctor?.firstName ?? "Doctor")")
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarItems(
                        trailing: NavigationLink(destination: DoctorSettingView().environmentObject(doctorDetailViewModel)) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                    )
                    .environmentObject(doctorDetailViewModel)
                }
            }
        }
    }

#Preview {
    DoctorDashboardView()
}
