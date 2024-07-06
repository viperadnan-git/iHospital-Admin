//
//  AdminInPatientView.swift
//  iHospital Admin
//
//  Created by Aditya on 06/07/24.
//

import SwiftUI

struct AdminInPatientView: View {
    @State var searchtext = ""
    var body: some View {
        VStack{
            
            HStack{
                SearchBar(searchText: $searchtext).padding(.top)
//                HStack{
//                    Image(systemName: "plus").padding()
//                    Text("Add Patient").padding()
//                }
//                .background(Color.gray)
//                .padding()
            }
            ScrollView{
                PatientDetailsList(searchText: $searchtext)
            }
        }
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
            

        

    }
}

#Preview {
    AdminInPatientView()
}
