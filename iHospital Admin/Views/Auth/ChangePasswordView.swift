//
//  ChangePasswordView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 09/07/24.
//

import SwiftUI

struct ChangePasswordView: View {
    var shouldDismiss = false
    
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @StateObject private var errorAlertMessage = ErrorAlertMessage()
    
    @Environment(\.dismiss) var dismiss
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
                Image("fp2")
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel("Password reset image")
            }
            VStack {
                Text("Change Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .accessibilityLabel("Change Password")
                
                Text("Enter your new password")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.top, 1)
                    .padding(.bottom, 20)
                    .accessibilityLabel("Enter your new password")
                
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
                            .accessibilityLabel("New Password")
                            .accessibilityHint("Enter your new password")
                        
                        if let passwordError = passwordError {
                            Text(passwordError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading, 2)
                                .accessibilityLabel(passwordError)
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
                            .accessibilityLabel("Confirm Password")
                            .accessibilityHint("Re-enter your new password to confirm")
                        
                        if let confirmPasswordError = confirmPasswordError {
                            Text(confirmPasswordError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading, 2)
                                .accessibilityLabel(confirmPasswordError)
                        } else {
                            Spacer().frame(height: 16)
                        }
                    }
                    
                    LoaderButton(isLoading: $isLoading, action: onUpdatePassword) {
                        Text("Change Password")
                            .accessibilityLabel("Change Password Button")
                            .accessibilityHint("Tap to update your password")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
        .padding(.trailing, 40)
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .accessibilityLabel("Change Password View")
        .accessibilityHint("Change your account password here")
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
                
                if shouldDismiss {
                    dismiss()
                }
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
