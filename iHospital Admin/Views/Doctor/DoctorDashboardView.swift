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
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                if let firstAppointment = appointments.first {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("\(firstAppointment.patient.name)")
                                            .foregroundColor(.white)
                                            .font(.title)
                                            .padding(.top , 10)
                                            .bold()
                                        Spacer()
                                        HStack {
                                            Image(systemName: "phone.fill")
                                                .frame(width:20 , height: 20)
                                            Text("\(firstAppointment.patient.phoneNumber.string)")
                                                .foregroundColor(.white)
                                                .font(.caption)
                                            Spacer()
                                            HStack(spacing: 5) {
                                                Image(systemName: "clock.fill")
                                                    .frame(width: 20, height: 20)
                                                Text("\(firstAppointment.date.timeString)")
                                                    .foregroundColor(.white)
                                                    .font(.caption)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                } else {
                                    Text("No current appointment")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.4 - 20, height: 180)
                            .background(Color(hex: "ef9c66"))
                            .cornerRadius(10)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                                .overlay(
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Appointments Left")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("5")
                                            .foregroundColor(.white)
                                            .font(.title)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.top ,10)
                                            .bold()
                                        Spacer()
                                    }
                                    .padding()
                                )
                                .frame(maxWidth: .infinity, maxHeight: 180)
                            
                          
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.purple)
                                .overlay(
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Revenue")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("$1000")
                                            .foregroundColor(.white)
                                            .font(.title)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.top,8)
                                            .bold()
                                        Spacer()
                                    }
                                    .padding()
                                )
                                .frame(maxWidth: .infinity, maxHeight: 180)
                        }
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
                        }
                        .padding()
                        
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
