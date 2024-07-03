//
//  AdminLogin.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 04/07/24.
//

import SwiftUI

struct AdminLogin: View {
    var body: some View {
        HStack(spacing: 0) {
                    // Left side
                    VStack {
                        Text("iHospital")
                            .font(.system(size: 60,weight:.black,design: .default))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .position(CGPoint(x: 350, y: 170))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.maincolor)
                    // Right side
            VStack{
                Text("Get Better Care For Your Health")
                                    .font(.system(size: 55))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.maincolor)
                                    .padding(.top, 130)
                Spacer()
                    .frame(height: 100)

                    Text("Login")
                        .font(.system(size: 45))
                        .fontWeight(.bold)
                        .foregroundColor(Color(.textcolor))
                        
                Spacer()
                    .frame(height: 20)
                       

                    TextField("Username", text: .constant(""))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                Spacer()
                    .frame(height: 20)

                    SecureField("Password", text: .constant(""))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                Spacer()
                    .frame(height: 15)
                    
                    Button(action: {
                        // Handle forgot password action
                    }) {
                        Text("Forgot Password?")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 80)}
                Spacer()
                    .frame(height: 15)

                    Button(action: {
                        // Handle login action
                    }) {
                        Text("Login")
                            .font(.system(size: 30,weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.maincolor )
                            .cornerRadius(8)
                            .padding(.horizontal, 40)
                    }
                Spacer()
                    .frame(height: 15)
                
                    HStack{
                        
                        Text("New member?")
                            .font(.system(size: 15))
                            .fontWeight(.regular)
                        
                        
                        Button(action: {
                            // Handle forgot password action
                        }) {
                            Text("Sign Up")
                                .font(.system(size: 20,weight: .medium))
                                .foregroundColor(.blue)
                                .padding(.leading,0)}
                    }
                
                Spacer()
                   
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                    }
                }
                .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    AdminLogin()
}
