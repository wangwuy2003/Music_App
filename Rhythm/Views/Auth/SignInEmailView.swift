//
//  SignInEmailView.swift
//  Rhythm
//
//  Created by MacMini A6 on 5/11/25.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
            
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}

struct SignInEmailView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.hex2C2F30, .hex1F1922], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                TextField("Email...", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                SecureField("Password...", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button {
                    Task {
                        do {
                            try await viewModel.signUp()
                            showSignInView = false
                            return
                        } catch {
                            print(error)
                        }
                        
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                            return
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Sign In With Email")
        .navigationBarBackButtonHidden()
        .enableSwipeBack()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                }

            }
        }
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}
