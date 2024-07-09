//
//  ChangePasswordView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 09/07/24.
//

import SwiftUI

struct ChangePasswordView: View {
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @StateObject private var errorAlertMessage = ErrorAlertMessage()
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @FocusState private var focusedField: Field?
    
    @State private var passwordError: String?
    @State private var confirmPasswordError: String?
    
    enum Field {
        case password
        case confirmPassword
    }
    
    var body: some View {
        HStack {
            VStack {
                Image("fp")
                    .resizable()
                    .scaledToFit()
            }
            VStack {
                Text("Update Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Enter your new password")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.top, 1)
                    .padding(.bottom, 20)
                
                VStack(spacing: 4) {
                    VStack(alignment: .leading, spacing: 4) {
                        SecureField("New Password", text: $password)
                            .paddedTextFieldStyle()
                            .focused($focusedField, equals: .password)
                            .submitLabel(.next)
                            .onSubmit {
                                validatePassword()
                                focusedField = .confirmPassword
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
                            Spacer().frame(height: 16)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        SecureField("Confirm Password", text: $confirmPassword)
                            .paddedTextFieldStyle()
                            .focused($focusedField, equals: .confirmPassword)
                            .submitLabel(.done)
                            .onSubmit {
                                validateConfirmPassword()
                                onUpdatePassword()
                            }
                            .onChange(of: confirmPassword) { _ in
                                validateConfirmPassword()
                            }
                        
                        if let confirmPasswordError = confirmPasswordError {
                            Text(confirmPasswordError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading, 2)
                        } else {
                            Spacer().frame(height: 16)
                        }
                    }
                    
                    LoaderButton(isLoading: $isLoading, action: onUpdatePassword) {
                        Text("Update Password")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
        .padding(.trailing, 40)
        .errorAlert(errorAlertMessage: errorAlertMessage)
    }
    
    func validatePassword() {
        if password.isEmpty {
            passwordError = "Password is required."
        } else {
            passwordError = nil
        }
    }

    func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = "Confirm password is required."
        } else if confirmPassword != password {
            confirmPasswordError = "Passwords do not match."
        } else {
            confirmPasswordError = nil
        }
    }
    
    func onUpdatePassword() {
        validatePassword()
        validateConfirmPassword()
        
        guard passwordError == nil, confirmPasswordError == nil else {
            return
        }
        
        isLoading = true
        Task {
            do {
                try await SupaUser.shared?.updatePassword(password: password)
                errorAlertMessage.title = "Password Updated"
                errorAlertMessage.message = "Your password has been updated successfully"
                authViewModel.shouldChangePassword = false
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    ChangePasswordView()
}
