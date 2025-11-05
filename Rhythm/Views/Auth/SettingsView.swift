//
//  SettingsView.swift
//  Rhythm
//
//  Created by MacMini A6 on 5/11/25.
//

import SwiftUI
import SwiftfulRouting

@MainActor
final class SettingsViewModel: ObservableObject {
    
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "hello123@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "Hello123!"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
}


struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            
            emailSection
            
        }
        .navigationTitle("Settings")
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section("Email functions") {
            Button("Reset password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("password reset")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Update password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("password updated")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Update email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("email updated")
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}
