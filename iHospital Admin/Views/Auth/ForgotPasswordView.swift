//
//  ForgotPasswordView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 07/07/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var isLoading: Bool = false
    
    
    var body: some View {
        HStack {
            VStack {
                Image("fp")
                    .resizable()
                    .scaledToFit()
            }
            
            
            VStack {
                Spacer()
                Text("Forgot Password?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Kindly enter the Email to reset the password!")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.top, 1)
                    .padding(.bottom, 20)
                
                TextField("Enter your Email", text: .constant(""))
                    .paddedTextFieldStyle()
                    .padding(.vertical)
                
                
                LoaderButton(isLoading: $isLoading, action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isLoading = false
                        
                    }
                }) {
                    Text("Reset Password")
                }
                Spacer()
            }.frame(maxWidth: .infinity, alignment: .leading)
        }.padding()
            .padding(.trailing, 40)
    }
}

#Preview {
    ForgotPasswordView()
}
