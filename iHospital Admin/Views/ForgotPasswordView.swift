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
        HStack(spacing: 0) {
            // Left side
            
            VStack {
                
                Image("fp")
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            
            
            // Right side
            VStack{
                
                Spacer()
                    .frame(height: 300)
                
                Text("Forgot Password?")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                
                
                Spacer()
                    .frame(height: 15)
                
                Text("Kindly enter the Email to reset the password!")
                    .font(.system(size: 20))
                    .fontWeight(.regular)
                    .foregroundColor(Color.black)
                    .padding(.horizontal,10)
                
                Spacer()
                    .frame(height: 20)
                
                TextField("Enter your Email", text: .constant(""))
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
                
                
                Spacer()
                    .frame(height: 20)
                
                LoaderButton(isLoading: $isLoading, action: {
                    // Simulate network call
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isLoading = false
                        // Handle password reset logic
                    }
                }) {
                    Text("Reset Password")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .cornerRadius(8)

                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ForgotPasswordView()
}
