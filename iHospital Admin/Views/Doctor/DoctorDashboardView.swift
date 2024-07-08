import SwiftUI
struct DoctorDashboardView: View {
    @StateObject private var doctorDetailViewModel = DoctorDetailViewModel()
    @State private var searchText = ""
    @State private var allAppointments: [Appointment] = appointments // Initialize with all appointments
    @State private var filteredAppointments: [Appointment] = appointments // Separate state for filtered appointments
    @State private var isDatePickerVisible = false
    @State private var selectedDate = Date()
    
    var selectedDateString: String {
             let calendar = Calendar.current
             if calendar.isDateInToday(selectedDate) {
                 return "Today"
             } else {
                 let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "MMM d" // Full weekday name
                 return dateFormatter.string(from: selectedDate)
             }
         }

         var revenue: Int {
             return 499 * allAppointments.count
         }

    var body: some View {
        if doctorDetailViewModel.isLoading {
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(2)
        } else {
            NavigationView {
                ZStack(alignment: .top) { // Use ZStack to overlay the calendar on top
                    VStack(alignment: .leading) {
                        HStack(alignment: .bottom) {
                            Text("iHospital")
                                .font(.system(size: 40, weight: .bold)) // Larger font size
                                .padding(.leading)
                            Spacer()
                            NavigationLink(destination: DoctorSettingView().environmentObject(doctorDetailViewModel)) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .padding(.trailing)
                            }
                        }
                        .padding(.top, 30) // Adjust top padding to move profile photo lower

                        Text("Today's Overview")
                            .font(.system(size: 34, weight: .semibold)) // Larger font size
                            .padding([.top, .leading])

                        HStack(spacing: 20) {
                            // First Box: Appointments Left
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: "5AC7DD"))
                                .frame(height: 160)
                                .overlay(
                                    VStack {
                                        Text("Appointments Left")
                                            .font(.title3) // Larger font size
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .padding(.top, 9) // Adjusted top padding
                                        Spacer()
                                        Text("\(allAppointments.count)/\(appointments.count)")
                                            .font(.system(size: 34, weight: .bold)) // Larger and bold font
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center) // Center align the text
                                            .padding(.horizontal, 18) // Add padding around the text
                                        Spacer()
                                    }
                                    .padding()
                                )
                                .onReceive(doctorDetailViewModel.$isLoading) { isLoading in
                                    if (!isLoading) {
                                        allAppointments = appointments // Refresh appointments when loading completes
                                        filteredAppointments = appointments // Also refresh filtered appointments
                                    }
                                }

                            // Second Box: Current Patient
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: "5AC7DD"))
                                .frame(height: 160)
                                .overlay(
                                    VStack {
                                        Text("Current Patient")
                                            .font(.title3) // Larger font size
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .padding(.top, 9) // Adjusted top padding

                                        Spacer()
                                        Text(allAppointments.first?.patient.name ?? "-")
                                            .font(.system(size: 34, weight: .bold)) // Larger and bold font
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center) // Center align the text
                                            .padding(.horizontal, 18) // Add padding around the text
                                        Spacer()
                                    }
                                    .padding()
                                )

                            // Third Box: Revenue
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: "5AC7DD"))
                                .frame(height: 160)
                                .overlay(
                                    VStack {
                                        Text("Revenue")
                                            .font(.title3) // Larger font size
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .padding(.top, 9) // Adjusted top padding
                                        Spacer() // Pushes text to the top edge
                                        Text("\(allAppointments.count * 499)")
                                            .font(.system(size: 34, weight: .bold)) // Larger and bold font
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center) // Center align the text
                                            .padding(.horizontal, 18) // Add padding around the text
                                        Spacer()
                                    }
                                    .padding()
                                )
                        }
                        .padding([.leading, .trailing])

                        HStack {
                            Text("Today's Schedule")
                                .font(.system(size: 34, weight: .semibold)) // Larger font size
                                .padding([.top, .leading])

                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: "5AC7DD"))
                                .frame(width: 130, height: 40) // Adjusted width to fit text and chevron
                                .overlay(
                                    HStack {
                                        Text(selectedDateString) // Display selected date text
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                            .padding(.trailing,3)
                                    }
                                    .padding(.horizontal, 10)
                                )
                                .padding(.top, 15) // Add more padding to align with the text
                                .onTapGesture {
                                    isDatePickerVisible.toggle()
                                }

                            Spacer()
                        }

                        SearchBar(searchText: $searchText)
                            .padding([.leading, .trailing])

                        TableView(filteredAppointments: filteredAppointments, onDelete: { appointment in
                            if let index = allAppointments.firstIndex(where: { $0.id == appointment.id }) {
                                allAppointments.remove(at: index)
                            }
                            filteredAppointments = allAppointments
                        })
                        .padding([.leading, .trailing])
                        .onAppear {
                            allAppointments = appointments // Initialize allAppointments with all appointments
                            filteredAppointments = appointments // Initialize filteredAppointments with all appointments
                        }
                        .onChange(of: searchText) { newValue in
                            if !newValue.isEmpty {
                                filteredAppointments = allAppointments.filter { appointment in
                                    appointment.patient.name.localizedCaseInsensitiveContains(newValue)
                                }
                            } else {
                                filteredAppointments = allAppointments
                            }
                        }

                        Spacer()
                    }

                    if isDatePickerVisible {
                        Color.black.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                isDatePickerVisible = false
                            }

                        VStack {
                            HStack {
                                Spacer()
                            }
                            .padding()

                            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding()
                        .shadow(radius: 10)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            .environmentObject(doctorDetailViewModel)
            .navigationViewStyle(StackNavigationViewStyle()) // Use stack navigation style
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

// Function to generate random appointment time
func randomAppointmentTime() -> Date {
    let calendar = Calendar.current
    let startHour = 9
    let endHour = 20
    let randomHour = Int.random(in: startHour..<endHour)
    let randomMinute = Int.random(in: 0..<60)
    
    let components = DateComponents(hour: randomHour, minute: randomMinute)
    return calendar.date(from: components) ?? Date()
}


let appointment1 = Appointment(id: UUID(), patient: Patient(patientId: UUID(), userId: UUID(), name: "Rohit", phoneNumber: 232, bloodGroup: .ABPositive, dateOfBirth: Date(), height: nil, weight: 34.3, address: "Asa"), phoneNumber: "asa", doctor: Doctor(userId: UUID(), name: "Name", dateOfBirth: Date(), gender: .male, phoneNumber: 232, email: "aksajs", qualification: "aksaj", experienceSince: Date(), dateOfJoining: Date(), departmentId: UUID()), appointmentTime: randomAppointmentTime())

let appointment2 = Appointment(id: UUID(), patient: Patient(patientId: UUID(), userId: UUID(), name: "Shweta", phoneNumber: 232, bloodGroup: .ABPositive, dateOfBirth: Date(), height: nil, weight: 34.3, address: "Asa"), phoneNumber: "asa", doctor: Doctor(userId: UUID(), name: "Name", dateOfBirth: Date(), gender: .female, phoneNumber: 232, email: "aksajs", qualification: "aksaj", experienceSince: Date(), dateOfJoining: Date(), departmentId: UUID()), appointmentTime: randomAppointmentTime())

let appointment3 = Appointment(id: UUID(), patient: Patient(patientId: UUID(), userId: UUID(), name: "Rohan", phoneNumber: 232, bloodGroup: .ABPositive, dateOfBirth: Date(), height: nil, weight: 34.3, address: "Asa"), phoneNumber: "asa", doctor: Doctor(userId: UUID(), name: "Name", dateOfBirth: Date(), gender: .male, phoneNumber: 232, email: "aksajs", qualification: "aksaj", experienceSince: Date(), dateOfJoining: Date(), departmentId: UUID()), appointmentTime: randomAppointmentTime())

let appointment4 = Appointment(id: UUID(), patient: Patient(patientId: UUID(), userId: UUID(), name: "Shayaan", phoneNumber: 232, bloodGroup: .ABPositive, dateOfBirth: Date(), height: nil, weight: 34.3, address: "Asa"), phoneNumber: "asa", doctor: Doctor(userId: UUID(), name: "Name", dateOfBirth: Date(), gender: .male, phoneNumber: 232, email: "aksajs", qualification: "aksaj", experienceSince: Date(), dateOfJoining: Date(), departmentId: UUID()), appointmentTime: randomAppointmentTime())

let appointment5 = Appointment(id: UUID(), patient: Patient(patientId: UUID(), userId: UUID(), name: "Aditya", phoneNumber: 232, bloodGroup: .ABPositive, dateOfBirth: Date(), height: nil, weight: 34.3, address: "Asa"), phoneNumber: "asa", doctor: Doctor(userId: UUID(), name: "Name", dateOfBirth: Date(), gender: .male, phoneNumber: 232, email: "aksajs", qualification: "aksaj", experienceSince: Date(), dateOfJoining: Date(), departmentId: UUID()), appointmentTime: randomAppointmentTime())

let appointment6 = Appointment(id: UUID(), patient: Patient(patientId: UUID(), userId: UUID(), name: "Adnan", phoneNumber: 232, bloodGroup: .ABPositive, dateOfBirth: Date(), height: nil, weight: 34.3, address: "Asa"), phoneNumber: "asa", doctor: Doctor(userId: UUID(), name: "Name", dateOfBirth: Date(), gender: .male, phoneNumber: 232, email: "aksajs", qualification: "aksaj", experienceSince: Date(), dateOfJoining: Date(), departmentId: UUID()), appointmentTime: randomAppointmentTime())

let appointment7 = Appointment(id: UUID(), patient: Patient(patientId: UUID(), userId: UUID(), name: "Nitin", phoneNumber: 232, bloodGroup: .ABPositive, dateOfBirth: Date(), height: nil, weight: 34.3, address: "Asa"), phoneNumber: "asa", doctor: Doctor(userId: UUID(), name: "Name", dateOfBirth: Date(), gender: .male, phoneNumber: 232, email: "aksajs", qualification: "aksaj", experienceSince: Date(), dateOfJoining: Date(), departmentId: UUID()), appointmentTime: randomAppointmentTime())

let appointments: [Appointment] = [appointment1, appointment2, appointment3, appointment4, appointment5, appointment6, appointment7, appointment2, appointment3, appointment1]

struct TableView: View {
    var filteredAppointments: [Appointment]
    var onDelete: (Appointment) -> Void // Closure to handle deletion

    var body: some View {
        VStack(spacing: 0) {
            // Table Headers
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    HStack {
                        Text("Name")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal, 28) // Adjusted padding for Name
                        Text("Age")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal, 28) // Adjusted padding for Age
                        Text("Gender")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal, 28) // Adjusted padding for Gender
                        Text("Time")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal, 28) // Adjusted padding for Time
                        Text("Edit")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal, 28)
                    }
                    .frame(height: 40)
                    .background(Color(hex: "5AC7DD")) // Matching box color
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(width: geometry.size.width) // Set width to screen width
                }
            }
            .frame(height: 40)
            .background(Color(hex: "5AC7DD")) // Matching box color
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 8) // Adjust margin from left and right

            // ScrollView for Table Content
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(filteredAppointments.indices, id: \.self) { index in
                        let appointment = filteredAppointments[index]
                        HStack {
                            Text(appointment.patient.name)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 28)
                            Text("\(Calendar.current.dateComponents([.year], from: appointment.patient.dateOfBirth, to: Date()).year ?? 0)") // Age calculation
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 28)
                            Text("M") // Gender as String
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 28)
                            Text(DateFormatter.localizedString(from: appointment.appointmentTime, dateStyle: .none, timeStyle: .short)) // Appointment time
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 28)
                            Menu {
                                Button("Reschedule") {
                                    // Handle reschedule action
                                }
                                .foregroundColor(.primary)
                                Button("Cancel") {
                                    onDelete(appointment) // Call onDelete closure
                                }
                                .foregroundColor(.red)
                            } label: {
                                Image(systemName: "ellipsis.circle") // Three dots in a circle icon
                                    .font(.system(size: 24))
                                    .padding(.horizontal, 28)
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.vertical, 8)
                        .background(index == 0 ? Color.gray.opacity(0.2) : Color.clear) // Gray background for first row
                        .cornerRadius(10) // Rounded corners for the selected row
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(10)
        }
        .padding(.vertical)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct DoctorDashboardView_Previews: PreviewProvider {
static var previews: some View {
DoctorDashboardView()
}
}
