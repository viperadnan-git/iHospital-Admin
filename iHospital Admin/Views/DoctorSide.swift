
import SwiftUI

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        let r = Double((hexNumber & 0xff0000) >> 16) / 255
        let g = Double((hexNumber & 0x00ff00) >> 8) / 255
        let b = Double(hexNumber & 0x0000ff) / 255
        self.init(red: r, green: g, blue: b, opacity: opacity)
    }
}

struct doctorView: View {
    @State private var searchText = ""
    @State private var selectedDate = Date()
    @State private var showDatePicker = false

    let patients = [
        Patient(patientID: "001", name: "Shweta", age: 25, gender: "Female", startTime: doctorView.timeFormatter.date(from: "11:00 AM")!, endTime: doctorView.timeFormatter.date(from: "11:30 AM")!, appointmentDate: Date()),
        Patient(patientID: "002", name: "Rohit", age: 28, gender: "Male", startTime: doctorView.timeFormatter.date(from: "12:00 PM")!, endTime: doctorView.timeFormatter.date(from: "12:30 PM")!, appointmentDate: Date()),
        Patient(patientID: "003", name: "Rohan", age: 22, gender: "Male", startTime: doctorView.timeFormatter.date(from: "1:00 PM")!, endTime: doctorView.timeFormatter.date(from: "1:30 PM")!, appointmentDate: Date()),
        Patient(patientID: "004", name: "Shayaan", age: 28, gender: "Male", startTime: doctorView.timeFormatter.date(from: "2:30 PM")!, endTime: doctorView.timeFormatter.date(from: "3:00 PM")!, appointmentDate: Date()),
        Patient(patientID: "005", name: "Nitin", age: 24, gender: "Male", startTime: doctorView.timeFormatter.date(from: "4:00 PM")!, endTime: doctorView.timeFormatter.date(from: "5:30 PM")!, appointmentDate: Date()),
        Patient(patientID: "006", name: "Sunny", age: 30, gender: "Male", startTime: doctorView.timeFormatter.date(from: "9:00 AM")!, endTime: doctorView.timeFormatter.date(from: "9:30 AM")!, appointmentDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
        Patient(patientID: "007", name: "Vicky", age: 32, gender: "Male", startTime: doctorView.timeFormatter.date(from: "9:30 AM")!, endTime: doctorView.timeFormatter.date(from: "10:00 AM")!, appointmentDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
        Patient(patientID: "008", name: "Rajesh", age: 29, gender: "Male", startTime: doctorView.timeFormatter.date(from: "10:00 AM")!, endTime: doctorView.timeFormatter.date(from: "10:30 AM")!, appointmentDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!),
        Patient(patientID: "009", name: "Priya", age: 26, gender: "Female", startTime: doctorView.timeFormatter.date(from: "10:30 AM")!, endTime: doctorView.timeFormatter.date(from: "11:00 AM")!, appointmentDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!),
        Patient(patientID: "010", name: "Amit", age: 33, gender: "Male", startTime: doctorView.timeFormatter.date(from: "11:00 AM")!, endTime: doctorView.timeFormatter.date(from: "11:30 AM")!, appointmentDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!),
        Patient(patientID: "011", name: "Anjali", age: 28, gender: "Female", startTime: doctorView.timeFormatter.date(from: "11:30 AM")!, endTime: doctorView.timeFormatter.date(from: "12:00 PM")!, appointmentDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!),
        Patient(patientID: "012", name: "Sanjay", age: 31, gender: "Male", startTime: doctorView.timeFormatter.date(from: "12:00 PM")!, endTime: doctorView.timeFormatter.date(from: "12:30 PM")!, appointmentDate: Calendar.current.date(byAdding: .day, value: 4, to: Date())!),
        Patient(patientID: "013", name: "Pooja", age: 27, gender: "Female", startTime: doctorView.timeFormatter.date(from: "12:30 PM")!, endTime: doctorView.timeFormatter.date(from: "1:00 PM")!, appointmentDate: Calendar.current.date(byAdding: .day, value: 4, to: Date())!),
        Patient(patientID: "014", name: "Rahul", age: 34, gender: "Male", startTime: doctorView.timeFormatter.date(from: "1:00 PM")!, endTime: doctorView.timeFormatter.date(from: "1:30 PM")!, appointmentDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!),
        Patient(patientID: "015", name: "Neha", age: 29, gender: "Female", startTime: doctorView.timeFormatter.date(from: "1:30 PM")!, endTime: doctorView.timeFormatter.date(from: "2:00 PM")!, appointmentDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!)
    ]

    var filteredPatients: [Patient] {
        // Filter patients based on searchText and selectedDate
        let filtered = patients.filter { patient in
            let isMatchingDate = Calendar.current.isDate(patient.appointmentDate, inSameDayAs: selectedDate)
            return isMatchingDate && (searchText.isEmpty ||
                patient.name.localizedCaseInsensitiveContains(searchText) ||
                patient.gender.localizedCaseInsensitiveContains(searchText) ||
                patient.patientID.localizedCaseInsensitiveContains(searchText) ||
                "\(patient.age)".localizedCaseInsensitiveContains(searchText))
        }
        return filtered
    }

    var nextPatient: Patient? {
        // Return the first patient of today's schedule
        return patients.first(where: { Calendar.current.isDate($0.appointmentDate, inSameDayAs: Date()) })
    }

    var totalAppointmentsToday: Int {
        // Calculate the total appointments for today
        let todayPatients = patients.filter { Calendar.current.isDate($0.appointmentDate, inSameDayAs: Date()) }
        return todayPatients.count
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("iHospital")
                        .font(.largeTitle)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.trailing)
                }
                .padding(.top)
                
                Rectangle()
                    .fill(Color(hex: "EAE7FD")) // Lighter color for the main box
                    .frame(height: 250)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .overlay(
                        VStack(alignment: .leading) {
                            Text("Today's Overview")
                                .font(.title2)
                                .padding(.leading)
                                .padding(.top, 10)
                            
                            Spacer()
                            
                            HStack {
                                VStack(alignment: .center) {
                                    Text("Appointments left")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .padding(.top, -30)
                                    Text("\(filteredPatients.count)")
                                        .font(.system(size: 50))
                                        .fontWeight(.regular)
                                        .padding(.top, 10)
                                }
                                .frame(width: 230, height: 170)
                                .background(Color(hex: "D9D6FC"))
                                .cornerRadius(16)
                                .padding(.horizontal, 8)
                                
                                VStack(alignment: .center) {
                                    Text("Total appointments")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .padding(.top, -30)
                                    Text("\(totalAppointmentsToday)")
                                        .font(.system(size: 50))
                                        .fontWeight(.regular)
                                        .padding(.top, 10)
                                }
                                .frame(width: 230, height: 170)
                                .background(Color(hex: "C466F0"))
                                .cornerRadius(16)
                                .padding(.horizontal, 8)
                                
                                VStack(alignment: .center) {
                                    Text("Next Patient")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .padding(.top, -30)
                                    Text(nextPatient?.name ?? "N/A")
                                        .font(.system(size: 30))
                                        .fontWeight(.regular)
                                        .padding(.top, 10)
                                }
                                .frame(width: 230, height: 170)
                                .background(Color(hex: "F60000", opacity: 0.7))
                                .cornerRadius(16)
                                .padding(.horizontal, 8)
                            }
                            .padding([.leading, .trailing, .bottom])
                        }
                    )
                    .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    HStack {
                        Text("My Schedule")
                            .font(.title2)
                            .padding(.leading)
                        
                        Spacer()
                        
                        Button(action: {
                            self.showDatePicker.toggle()
                        }) {
                            HStack {
                                if Calendar.current.isDate(selectedDate, inSameDayAs: Date()) {
                                    Text("Today")
                                } else {
                                    Text(dateFormatter.string(from: selectedDate))
                                }
                                Image(systemName: "chevron.down")
                            }
                            .padding(.horizontal)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                        }
                        .padding(.trailing)
                    }
                    .padding([.leading, .trailing, .top])
                    
                    ZStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                            
                            TextField("Search Patients", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(8)
                                .background(Color.white)
                        }
                        .padding([.leading, .trailing])
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    }
                    .padding([.leading, .trailing, .top])
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .overlay(
                            VStack {
                                HStack {
                                    Text("Patient ID").bold().frame(maxWidth: .infinity, alignment: .center)
                                    Text("Name").bold().frame(maxWidth: .infinity, alignment: .center)
                                    Text("Age").bold().frame(maxWidth: .infinity, alignment: .center)
                                    Text("Gender").bold().frame(maxWidth: .infinity, alignment: .center)
                                    Text("Time").bold().frame(maxWidth: .infinity, alignment: .center)
                                    Spacer() // New column for the emoji menu
                                }
                                .font(.subheadline) // Smaller font for header
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                
                                List(filteredPatients) { patient in
                                    HStack {
                                        Text(patient.patientID).frame(maxWidth: .infinity, alignment: .center)
                                        Text(patient.name).frame(maxWidth: .infinity, alignment: .center)
                                        Text("\(patient.age)").frame(maxWidth: .infinity, alignment: .center)
                                        Text(patient.gender).frame(maxWidth: .infinity, alignment: .center)
                                        Text(doctorView.timeRangeFormatter.string(from: patient.startTime, to: patient.endTime))
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .fixedSize(horizontal: true, vertical: false)
                                        
                                        Spacer() // New column for the emoji menu
                                        
                                        Menu {
                                            Button(action: {
                                                // Action for cancel
                                            }) {
                                                Text("Cancel")
                                                Image(systemName: "xmark.circle")
                                            }
                                            Button(action: {
                                                // Action for reschedule
                                            }) {
                                                Text("Reschedule")
                                                Image(systemName: "calendar")
                                            }
                                        } label: {
                                            Text("⋮")
                                                .font(.title)
                                                .foregroundColor(.blue)
                                                .padding(.horizontal)
                                        }
                                    }
                                    .foregroundColor(.gray) // Set text color to gray
                                    .font(.subheadline) // Smaller font for rows
                                    .padding(.vertical, 4) // Smaller row size
                                    .background(self.searchText.isEmpty ? Color.clear : Color.gray.opacity(0.3)) // Highlight matching rows
                                }
                                .listStyle(PlainListStyle())
                                .frame(maxHeight: .infinity)
                            }
                        )
                        .padding()
                }
                .padding()
            }
            .padding()
            
            if showDatePicker {
                ZStack {
                    Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding()
                            .frame(maxWidth: 400)
                        
                        Button("Done") {
                            showDatePicker = false
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    private static let timeRangeFormatter: DateIntervalFormatter = {
        let formatter = DateIntervalFormatter()
        formatter.dateTemplate = "h:mm a"
        return formatter
    }()
}

struct doctorView_Previews: PreviewProvider {
    static var previews: some View {
        doctorView()
    }
}

