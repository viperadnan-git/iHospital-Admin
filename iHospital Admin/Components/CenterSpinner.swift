//
//  CenterSpinner.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 15/07/24.
//

import SwiftUI

struct CenterSpinner: View {
    var color: Color = .accentColor  // Default color for the spinner
    var scale: CGFloat = 2.0        // Default scale for the spinner
    
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: color)) // Custom spinner color
                .scaleEffect(scale) // Custom scale
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    CenterSpinner()
}
