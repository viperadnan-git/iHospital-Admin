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
                    GeometryReader { geometry in
                        let screenWidth = geometry.size.width
                        let boxWidth = screenWidth * 0.4
                        let remainingWidth = screenWidth * 0.6
                        
                        VStack(alignment: .leading) {
                            HStack(spacing: 10) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Current Patient")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Spacer()
                                    
                                    if let firstAppointment = appointments.first {
                                        HStack {
                                            Image(systemName: "phone.fill")
                                                .resizable()
                                                .frame(width: 22, height: 22)
                                            Text(firstAppointment.patient.phoneNumber.string)
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                        }
                                        HStack(alignment: .bottom) {
                                            Text(firstAppointment.patient.name)
                                                .foregroundColor(.white)
                                                .font(.title)
                                                .bold()
                                            Spacer()
                                            HStack(spacing: 5) {
                                                Image(systemName: "clock.fill")
                                                    .resizable()
                                                    .frame(width: 22, height: 22)
                                                    .font(.system(size: 15))
                                                Text(firstAppointment.date.timeString)
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 15))
                                            }
                                            .padding(.bottom, 10)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    } else {
                                        Text("No current appointment")
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding()
                                .frame(width: boxWidth, height: 180)
                                .background(Color(hex: "ef9c66"))
                                .cornerRadius(10)
                                
                                HStack(spacing: 10) { // Adjusted spacing
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.blue)
                                        .overlay(
                                            VStack(alignment: .leading, spacing: 10) {
                                                Text("5")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 60, weight: .bold))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .bold()
                                                Text("Appointments Left")
                                                    .font(.title2)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top, 40)
                                                Spacer()
                                            }
                                                .padding()
                                        )
                                        .frame(width: remainingWidth / 2.25, height: 180)
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.purple)
                                        .overlay(
                                            VStack(alignment: .leading, spacing: 10) {
                                                Text("$1000")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 60, weight: .bold))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top, 1)
                                                Text("Revenue")
                                                    .font(.title2)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top, 40)
                                                Spacer()
                                            }
                                                .padding()
                                        )
                                        .frame(width: remainingWidth / 2.25, height: 180)
                                }
                            }
                            .padding(.horizontal, 10)
                            
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
    }
#Preview {
    DoctorDashboardView()
}
