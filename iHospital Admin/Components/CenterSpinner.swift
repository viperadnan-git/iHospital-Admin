//
//  CenterSpinner.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 15/07/24.
//

import SwiftUI

struct CenterSpinner: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(2)
            Spacer()
        }
    }
}

#Preview {
    CenterSpinner()
}
