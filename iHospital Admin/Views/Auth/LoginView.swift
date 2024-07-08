//
//  LoginView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var isLoading = false
    @StateObject private var errorAlertMessage = ErrorAlertMessage()
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                if geometry.size.width > 600 {
                    VStack {
                        Spacer()
                        HStack{
                            Image(systemName: "heart.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 50)
                                .padding(.top, 100)
                            
                            Text("iHospital")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .frame(width: 200, height: 50)
                                .padding(.top, 100)
                                
                        }
                        
                        Image("hospital")
                            .resizable()
                            .scaledToFit()
                            .padding(50)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                }
                
                VStack {
                    Spacer()
                    
                    Text("Login")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
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
                                Text("Forgot Password?")
                                    .foregroundColor(.blue)
                            }
                            .padding(.trailing)
                        }
                    }
                    .padding(.top, 20)
                    
                    LoaderButton(isLoading: $isLoading, action: onLogin) {
                        Text("Login")
                            .font(.system(size: 20, weight: .medium))
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding()
                .frame(width: geometry.size.width > 600 ? geometry.size.width * 0.5 : geometry.size.width)
                
            }.errorAlert(errorAlertMessage: errorAlertMessage)
        }.onOpenURL(perform: handleOpenURL)
    }
    
    private func onLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            errorAlertMessage.message = "Please enter your email and password."
            email = ""
            password = ""
            return
        }
        
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                try await SupaUser.login(email: email.trimmed, password: password)
                try await authViewModel.updateSupaUser()
            } catch {
                errorAlertMessage.message = error.localizedDescription
                password = ""
            }
        }
    }


    private func handleOpenURL(_ url: URL) {
        Task {
            do {
                try await supabase.auth.session(from: url)
                authViewModel.shouldChangePassword = true
                try await authViewModel.updateSupaUser()
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    LoginView()
}
