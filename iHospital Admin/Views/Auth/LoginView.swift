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
    
    @FocusState private var focusedField: Field?
    
    @State private var emailError: String?
    @State private var passwordError: String?
    
    enum Field {
        case email
        case password
    }
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                HStack {
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
            .background(Color(.systemGray6))
            
            VStack {
                Spacer()
                
                Text("Login")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                VStack(spacing: 4) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Enter Your Email", text: $email)
                            .paddedTextFieldStyle()
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit {
                                validateEmail()
                                focusedField = .password
                            }
                            .onChange(of: email) { _ in
                                validateEmail()
                            }
                        
                        if let emailError = emailError {
                            Text(emailError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading, 2)
                        } else {
                            Spacer().frame(height: 17)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        SecureField("Enter Your Password", text: $password)
                            .paddedTextFieldStyle()
                            .focused($focusedField, equals: .password)
                            .submitLabel(.go)
                            .onSubmit {
                                validatePassword()
                                onLogin()
                            }
                            .onChange(of: password) { _ in
                                validatePassword()
                            }
                        
                        if let passwordError = passwordError {
                            Text(passwordError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading, 2)
                        } else {
                            Spacer().frame(height: 17)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            // Handle forgot password
                        }) {
                            Text("Forgot Password?")
                                .foregroundColor(.accentColor)
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
                Spacer()
            }.padding(40)
        }.errorAlert(errorAlertMessage: errorAlertMessage)
            .onOpenURL(perform: handleOpenURL)
            .ignoresSafeArea(.keyboard)
    }
    
    private func validateEmail() {
        if email.isEmpty {
            emailError = "Email is required."
        } else if !email.isEmail {
            emailError = "Please enter a valid email address."
        } else {
            emailError = nil
        }
    }
    
    private func validatePassword() {
        if password.isEmpty {
            passwordError = "Password is required."
        } else {
            passwordError = nil
        }
    }
    
    private func onLogin() {
        validateEmail()
        validatePassword()
        
        guard emailError == nil, passwordError == nil else {
            return
        }
        
        Task {
            focusedField = nil
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

