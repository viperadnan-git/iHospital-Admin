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
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.red.opacity(0.5))
                            .overlay(
                                VStack(alignment: .leading) {
                                    Text("32")
                                        .font(.system(size: 45, weight: .bold))
                                    Text("Current Patient")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }.frame(maxWidth: .infinity)
                            )
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.accent))
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
                    }.frame(height: 180)
                   
                    
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
