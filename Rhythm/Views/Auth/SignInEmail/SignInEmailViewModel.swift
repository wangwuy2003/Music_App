//
//  SignInEmailViewModel.swift
//  Rhythm
//
//  Created by MacMini A6 on 4/12/25.
//
import Foundation
import SwiftUI

enum AuthMode: String, CaseIterable, Identifiable {
    case signIn
    case signUp
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .signIn:       return .localized("Sign In")
        case .signUp:       return .localized("Sign Up")
        }
    }
}

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var mode: AuthMode = .signIn
    
    @Published var errorMessage: String? = nil
    @Published var showErrorAlert: Bool = false
    
    func action() async {
        guard validateInput() else { return }
        
        do {
            switch mode {
            case .signUp:
                try await AuthenticationManager.shared.createUser(email: email, password: password)
            case .signIn:
                try await AuthenticationManager.shared.signInUser(email: email, password: password)
            }
        } catch {
            self.errorMessage = error.localizedDescription
            self.showErrorAlert = true
        }
    }
    
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
    
    private func validateInput() -> Bool {
        if email.isEmpty {
            errorMessage = .localized("Please enter email.")
            showErrorAlert = true
            return false
        }
        
        if password.isEmpty {
            errorMessage = .localized("Please enter password.")
            showErrorAlert = true
            return false
        }
        
        if mode == .signUp {
            if password.count < 6 {
                errorMessage = .localized("Password must be at least 6 characters.")
                showErrorAlert = true
                return false
            }
            
            if confirmPassword.isEmpty {
                errorMessage = .localized("Please re-enter password.")
                showErrorAlert = true
                return false
            }
            
            if password != confirmPassword {
                errorMessage = .localized("The re-entered password does not match.")
                showErrorAlert = true
                return false
            }
        }
        
        return true
    }
}
