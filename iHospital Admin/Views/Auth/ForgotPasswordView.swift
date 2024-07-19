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
                Image("fp2")
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel("Forgot password illustration")
            }
            
            VStack {
                Spacer()
                Text("Forgot Password?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .accessibilityLabel("Forgot Password Title")
                
                Text("Kindly enter the Email to reset the password!")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.top, 1)
                    .padding(.bottom, 20)
                    .accessibilityLabel("Instruction text to enter email for password reset")
                
                TextField("Enter your Email", text: $email)
                    .paddedTextFieldStyle()
                    .padding(.vertical)
                    .accessibilityLabel("Email input field")
                    .accessibilityHint("Enter the email associated with your account")
                
                LoaderButton(isLoading: $isLoading, action: {
                    // Simulate loading
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isLoading = false
                    }
                }) {
                    Text("Reset Password")
                        .accessibilityLabel("Reset Password Button")
                        .accessibilityHint("Tap to send a password reset link to the entered email")
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 50)
        }
        .padding()
        .padding(.trailing, 40)
        .accessibilityLabel("Forgot Password View")
        .accessibilityHint("Enter your email to receive a password reset link")
    }
}

#Preview {
    ForgotPasswordView()
}
