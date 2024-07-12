import SwiftUI

struct AdminBedView: View {
    @State var searchtext = ""
    @State private var showAddBedForm = false
    @State private var searchBed = ""
    @State private var selectedFloor = "All Floors"
    let floors = ["All Floors", "Floor 1", "Floor 2", "Floor 3"]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
       
            ScrollView {
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
                        
                        Spacer().frame(height: 30)
                        
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(0..<6) { index in
                                BedDetailCard(bedNumber: "Bed No.  \(index + 1)", roomNumber: "Room No.\(index + 1)", bedType: "Type of Bed \(index + 1)")
                                    .buttonStyle(PlainButtonStyle())
                                    .frame(height: 150)
                                    .padding(.horizontal, 4)
                            }
                        }
                        
                    }.frame(maxWidth: .infinity,maxHeight: .infinity)
                    .padding(20)
                }
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


struct BedInfoView: View{
    var body: some View{
        VStack{
            NavigationView{
                VStack{
                    Text("bed no. ")
                    Text("ward type")
                    Text("bed no. ")
                    Text("ward type")
                    
                }
            }
            
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color(uiColor: .systemGray6))
        .navigationTitle("bed no.")
        
        
    }
}






#Preview {
    AdminBedView()
}
