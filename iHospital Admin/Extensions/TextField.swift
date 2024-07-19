//
//  TextField.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 09/07/24.
//

import SwiftUI

extension TextField {
    // Adds an icon to the TextField
    func withIcon(_ icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.secondary)
            self
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 0)
                .foregroundColor(.black)
        )
    }
}

#Preview {
    VStack {
        TextField("Password", text: .constant(""))
            .withIcon("lock")
            .accessibility(label: Text("Password"))
            .padding()
        
        TextField("Username", text: .constant(""))
            .withIcon("person")
            .accessibility(label: Text("Username"))
            .padding()
    }
    .padding()
}
