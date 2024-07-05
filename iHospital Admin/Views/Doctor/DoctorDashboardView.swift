import SwiftUI
struct DoctorDashboardView: View {
    @StateObject private var doctorDetailViewModel = DoctorDetailViewModel()
    @State private var searchText = ""

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
                            .fill(Color(hex: "5AC7DD"))
                            .frame(height: 180)
                            .overlay(
                                VStack(alignment: .leading) {
                                    Text("Current Patient")
                                        .font(.title3) // Larger font size
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.top, 10) // Adjusted top padding
                                    Spacer() // Pushes text to the top edge
                                }
                                .padding()
                            )
                        
                        // Second Box: Appointments Left
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "5AC7DD"))
                            .frame(height: 180)
                            .overlay(
                                VStack(alignment: .leading) {
                                    Text("Appointments Left")
                                        .font(.title3) // Larger font size
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.top, 10) // Adjusted top padding
                                    Spacer() // Pushes text to the top edge
                                }
                                .padding()
                            )
                        
                        // Third Box: Revenue
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "5AC7DD"))
                            .frame(height: 180)
                            .overlay(
                                VStack(alignment: .leading) {
                                    Text("Revenue")
                                        .font(.title3) // Larger font size
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.top, 10) // Adjusted top padding
                                    Spacer() // Pushes text to the top edge
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
                        .padding([.leading, .trailing])

                    TableView()
                        .padding([.leading, .trailing])
                    
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
            }
        }
    }
}

// Hex Color Extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            let red = Double((hexNumber & 0xff0000) >> 16) / 255.0
            let green = Double((hexNumber & 0x00ff00) >> 8) / 255.0
            let blue = Double(hexNumber & 0x0000ff) / 255.0
            
            self.init(red: red, green: green, blue: blue)
            return
        }
        
        self.init(red: 0, green: 0, blue: 0)
    }
}

let appointment = Appointment(id: UUID(), patient: Patient(patientId: UUID(), userId: UUID(), name: "Patient", phoneNumber: 232, bloodGroup: .ABPositive, dateOfBirth: Date(), height: nil, weight: 34.3, address: "Asa"), phoneNumber: "asa", doctor: Doctor(userId: UUID(), name: "Name", dateOfBirth: Date(), gender: .male, phoneNumber: 232, email: "aksajs", qualification: "aksaj", experienceSince: Date(), dateOfJoining: Date(), departmentId: UUID()), appointmentTime: Date())

let appointments: [Appointment] = [appointment, appointment, appointment]

struct TableView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Table Headers
            HStack {
                Text("Name")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20) // Adjusted padding for Name
                Text("Age")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20) // Adjusted padding for Age
                Text("Gender")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20) // Adjusted padding for Gender
                Text("Time")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20) // Adjusted padding for Time
                Text("Edit")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 18)
            }
            .background(Color(hex: "5AC7DD")) // Matching box color
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 8) // Adjust margin from left and right
            
            // Empty Row Content (Placeholder)
            VStack {
                ForEach(Array(appointments)) { appointment in
                    HStack {
                        Text(appointment.patient.name)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                        Text("\(appointment.patient.dateOfBirth)")
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                        Text("M")
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                        Text("\(appointment.appointmentTime)")
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

