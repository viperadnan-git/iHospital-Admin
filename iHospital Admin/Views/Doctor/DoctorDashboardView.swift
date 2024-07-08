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
                    Text("Today's Overview")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding([.top, .leading])
                    
                    HStack(spacing: 20) {
                        // First Box: Current Patient
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.accent))
                            .frame(height: 180)
                            .overlay(
                                VStack(alignment: .leading) {
                                    Text("Current Patient")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                    Spacer()
                                }
                                    .padding()
                            )
                        
                        // Second Box: Appointments Left
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.accent))
                            .frame(height: 180)
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
                        
                        // Third Box: Revenue
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.accent))
                            .frame(height: 180)
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
                    }
                    .padding([.leading, .trailing])
                    
                    Text("Today's Schedule")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding([.top, .leading])
                    
                    SearchBar(searchText: $searchText)
                        .padding(.horizontal)
                    
                    DoctorAppointmentsTable()
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    trailing: NavigationLink(destination: DoctorSettingView().environmentObject(doctorDetailViewModel)) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                )
                .environmentObject(doctorDetailViewModel)
                .onAppear(perform: doctorDetailViewModel.fetchAppointments)
            }
        }
    }
}


struct DoctorAppointmentsTable: View {
    @EnvironmentObject var doctorDetailViewModel: DoctorDetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Table Headers
            HStack {
                Text("Name")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                Text("Age")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                Text("Gender")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                Text("Time")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                Text("Edit")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 18)
            }
            .background(Color(.accent))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 8)
            
            VStack {
                ForEach(doctorDetailViewModel.appointments, id: \.id) { appointment in
                    HStack {
                        Text(appointment.patient.name)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                        Text("\(appointment.patient.dateOfBirth)")
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                        Text("Male")
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                        Text("\(appointment.createdAt)")
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                        Text("")
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                    }
                    .padding(.vertical, 8)
                }
            }
            .frame(maxHeight: 200)
            .background(Color.white)
            .cornerRadius(10)
        }
        .padding(.vertical)
    }
}

struct DoctorDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorDashboardView()
    }
}
