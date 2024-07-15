import SwiftUI

struct Bed: Identifiable {
    var id = UUID()
    var bedNumber: UUID
    var wardType: String
    var roomNumber: String
    var floorNumber: String
    var status: String
    var statusColor: Color
}

struct AdminBedView: View {
    @State var searchtext = ""
    @State private var showAddBedForm = false
    @State private var searchBed = ""
    @State private var selectedFloor = "All Floors"
    let floors = ["All Floors", "Floor 1", "Floor 2", "Floor 3"]
    
    @State var beds = [
            Bed(bedNumber: UUID(), wardType: "General", roomNumber: "101", floorNumber: "1", status: "Available", statusColor: .green),
            Bed(bedNumber: UUID(), wardType: "ICU", roomNumber: "202", floorNumber: "2", status: "Occupied", statusColor: .red),
            Bed(bedNumber: UUID(), wardType: "Private", roomNumber: "303", floorNumber: "3", status: "Under Maintenance", statusColor: .yellow)
        ]

    var body: some View {
                VStack {
                    HStack {
                        BedCard(title: .constant("250"), subtitle: "Total Beds", color: .purple)
                            .padding(.trailing, 10)
                        
                        BedCard(title: .constant("94"), subtitle: "Available Beds", color: .green)
                            .padding(.trailing, 10)
                        
                        BedCard(title: .constant("56"), subtitle: "Occupied Beds", color: .orange)
                            .padding(.trailing, 10)
                        
                        Button(action: {
                            showAddBedForm = true
                        }) {
                            AddBedCard()
                        }
                        .padding(.trailing, 10)
                        .sheet(isPresented: $showAddBedForm) {
                            AddBedDetailsView()
                        }
                    }
                    .navigationTitle("Bed Management")
                    .padding(.horizontal, 25)
                    .padding(.top, 40)
                    
                    VStack {
                        Spacer().frame(height: 20)
                        Text("Bed Details")
                            .padding(.leading,0)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                        
                        HStack {
                            Picker("Floor", selection: $selectedFloor) {
                                ForEach(floors, id: \.self) { floor in
                                    Text(floor)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.trailing, 10)
                            
                            SearchBar(text: $searchtext)
                                .background(Color(uiColor: .systemGray6))
                                .cornerRadius(8)
                                .padding(.trailing, 10)
                            
                            
                        }
                        .padding(.horizontal,20)
                          }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    Table(beds) {
                        TableColumn("Name", value: \.wardType)
                            TableColumn("Gender", value: \.wardType)
                            TableColumn("Phone No.", value:  \.wardType)
                            TableColumn("Address", value: \.wardType)
                    }
                    .padding(.horizontal,30)
                    

            }
    }
}

struct BedCard: View {
    @Binding var title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Text(subtitle)
                .font(.title2)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(color)
        .cornerRadius(8)
        .foregroundColor(.white)
    }
}

struct AddBedCard: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 35)
                    .padding(.top, 20)
                    .foregroundColor(.white)
            }
            Text("Add Bed Details")
                .font(.title2)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(Color.blue)
        .cornerRadius(8)
        .foregroundColor(.white)
    }
}

struct AddBedDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var bedNumber = ""
    @State private var ward = ""
    @State private var roomNum = ""
    @State private var typeOfBed = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bed Details")) {
                    TextField("Bed Number", text: $bedNumber).frame(height: 50)
                    TextField("Ward Type", text: $ward).frame(height: 50)
                    TextField("Room No.", text: $roomNum).frame(height: 50).frame(height: 50)
                    TextField("Type of Bed", text: $typeOfBed).frame(height: 50)
                }
            }
            .navigationTitle("Add Bed Details")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Add Details") {
                // Action to add bed details
                print("Add Bed Details")
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct BedDetailCard: View {
    let bedNumber: String
    let roomNumber: String
    let bedType: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(bedNumber)
                .font(.title)
                .bold()
            Text(roomNumber)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(bedType)
                .font(.subheadline)
            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 13, height: 13)
                Text("Available")
                    .font(.title3)
                    .fontWeight(.medium)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .leading)
        .padding()
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    AdminBedView()
}
