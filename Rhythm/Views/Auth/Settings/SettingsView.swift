//
//  SettingsView.swift
//  Rhythm
//
//  Created by MacMini A6 on 5/11/25.
//

import SwiftUI
import SwiftfulRouting
import SDWebImageSwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    @State private var showDeleteAlert: Bool = false
    @State private var isDeleting: Bool = false
    
    var body: some View {
        List {
            // MARK: Account section
            Section {
                Button {
                    if viewModel.authUser == nil {
                        showSignInView = true
                    }
                } label: {
                    HStack(spacing: 15) {
                        if let photoUrl = viewModel.authUser?.photoUrl,
                           let url = URL(string: photoUrl) {
                            WebImage(url: url)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray.opacity(0.6))
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(viewModel.authUser?.email ?? (viewModel.authUser?.isAnonymous == true ? "Anonymous" : "Login"))
                                .font(.headline)
                                .foregroundColor(.primary)
                            if viewModel.authUser != nil {
//                                Text("Tap to view account")
//                                    .font(.subheadline)
//                                    .foregroundColor(.secondary)
                                Text(viewModel.authUser?.name ?? "Unkown")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Tap to sign in")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        if viewModel.authUser == nil {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            
            
            
            if viewModel.authUser?.isAnonymous == true {
                anonymousSection
            }

            // MARK: - App Info Section
            Section("App Info") {
                Button {
                    
                } label: {
                    Label(.localized("Privacy Policy"), systemImage: "shield.fill")
                        .foregroundStyle(.white)
                }
                .labelStyle(.titleAndIcon)
                
                Button {
                    
                } label: {
                    Label(.localized("Terms of Use"), systemImage: "list.bullet.clipboard.fill")
                        .foregroundStyle(.white)
                }
                .labelStyle(.titleAndIcon)
            }
            
            // MARK: - Account Management Section
            if viewModel.authUser != nil {
                Section("Account Settings") {
                    Button{
                        do {
                            try viewModel.signOut()
                            viewModel.loadAuthUser()
                            viewModel.loadAuthProviders()
                        } catch {
                            print(error)
                        }
                    } label: {
                        Label(.localized("Sign out"), systemImage: "iphone.and.arrow.right.outward")
                            .foregroundStyle(.white)
                    }
                    
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Label("Delete Account", systemImage: "trash.fill")
                            .foregroundStyle(.red)
                    }
                    .alert("Delete Account", isPresented: $showDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            Task {
                                await deleteAccount()
                            }
                        }
                    } message: {
                        Text("Are you sure you want to permanently delete your account? This action cannot be undone.")
                    }

                }
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .onChange(of: showSignInView) { newValue in
            if newValue == false {
                viewModel.loadAuthUser()
                viewModel.loadAuthProviders()
            }
        }
        .navigationTitle("Settings")
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

// MARK: Function
extension SettingsView {
    @MainActor
    private func deleteAccount() async {
        isDeleting = true
        defer { isDeleting = false }

        if viewModel.authUser?.isAnonymous == true {
            // Anonymous users: chỉ signOut, không xóa tài khoản Firebase
            do {
                try viewModel.signOut()
                viewModel.authUser = nil
                viewModel.authProviders.removeAll()
                print("Anonymous account signed out.")
            } catch {
                print("SignOut error: \(error.localizedDescription)")
            }
        } else {
            // Người dùng thật: Xóa tài khoản Firebase
            do {
                try await viewModel.deleteAccount()
                try viewModel.signOut() // Đảm bảo đăng xuất sau khi xóa
                viewModel.authUser = nil
                viewModel.authProviders.removeAll()
                print("Firebase account deleted successfully.")
            } catch {
                print("Delete account error: \(error.localizedDescription)")
            }
        }

        // ✅ Reset view để cập nhật lại UI
        await MainActor.run {
            viewModel.loadAuthUser()
            viewModel.loadAuthProviders()
        }
    }

}

// MARK: Subviews
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
    
    private var anonymousSection: some View {
        Section("Create Account") {
            Button {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("google link")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text(.localized("Link Google Account"))
                    .foregroundStyle(.white)
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("apple link")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text(.localized("Link Apple Account"))
                    .foregroundStyle(.white)
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.linkEmailAccount()
                        print("email link")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text(.localized("Link Email Account"))
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}
