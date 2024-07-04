//
//  LoginView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var isLoading = false
    @State private var errorTitle: String?
    @State private var errorMessage: String?

    var body: some View {
        GeometryReader { geometry in
            HStack {
                if geometry.size.width > 600 {
                    VStack {
                        Image(systemName: "heart.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.top, 100)
                        
                        Image("doctors")
                            .resizable()
                            .scaledToFit()
                            .padding(.bottom, 100)
                    }
                    .frame(width: geometry.size.width * 0.5)
                    .background(Color(UIColor.systemTeal).opacity(0.3))
                }
                
                VStack {
                    Spacer()
                    
                    Text("Get Better Care For Your Health")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Login")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        TextField("Enter Your Email", text: $email)
                            .paddedTextFieldStyle()
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                        
                        SecureField("Enter Your Password", text: $password)
                            .paddedTextFieldStyle()
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                // Handle forgot password
                            }) {
                                Text("Forget Password?")
                                    .foregroundColor(.blue)
                            }
                            .padding(.trailing)
                        }
                    }
                    .padding(.top, 20)
                    
                    LoaderButton(isLoading: $isLoading, action: onLogin) {
                        Text("Login")
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding()
                .frame(width: geometry.size.width > 600 ? geometry.size.width * 0.5 : geometry.size.width)
                
            }.errorAlert(title: $errorTitle, message: $errorMessage)
        }
    }
    
    func onLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            return
        }
        
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                if let user = try await SupaUser.login(email: email, password: password) {
                    SupaUser.shared = user
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    LoginView()
}
