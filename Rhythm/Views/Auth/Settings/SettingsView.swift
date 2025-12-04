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
    @ObservedObject private var themeManager = ThemeManager.shared
    @Binding var showSignInView: Bool
    @State private var showDeleteAlert: Bool = false
    @State private var isDeleting: Bool = false
    
    var body: some View {
        ZStack {
            themeManager.backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    accountHeaderView
                    
                    VStack(spacing: 15) {
                        settingsGroupTitle("APPEARANCE")
                        HStack {
                            HStack(spacing: 15) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.purple.opacity(0.2))
                                        .frame(width: 36, height: 36)
                                    Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.purple)
                                }
                                Text("Dark Mode")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(themeManager.textColor)
                            }
                            Spacer()
                            
                            Toggle("", isOn: $themeManager.isDarkMode)
                                .labelsHidden()
                        }
                        .padding()
                        .background(themeManager.secondaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        

                        settingsGroupTitle("PREFERENCES") // Hoặc "Cài đặt chung"
                        NavigationLink {
                            LanguageView()
                        } label: {
                            HStack(spacing: 15) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.blue.opacity(0.2))
                                        .frame(width: 36, height: 36)
                                    Image(systemName: "globe")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.blue)
                                }
                                
                                Text(.localized("Language")) // Nhớ dùng .localized()
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(themeManager.textColor)
                                
                                Spacer()
                                
                                // Hiển thị ngôn ngữ hiện tại
                                Text(Language(rawValue: LanguageManager.shared.selectedLanguage)?.displayName ?? "English")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                            .padding()
                            .background(themeManager.secondaryColor)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        settingsGroupTitle("APP INFO")
                        SettingsRow(icon: "shield.fill", title: "Privacy Policy", color: .accentColor) {}
                        SettingsRow(icon: "doc.text.fill", title: "Terms of Use", color: .accentColor) {}
                        
                        if viewModel.authUser != nil {
                            settingsGroupTitle("ACCOUNT")
                            
                            SettingsRow(icon: "rectangle.portrait.and.arrow.right", title: "Sign out", color: .orange) {
                                try? viewModel.signOut()
                            }
                            
                            SettingsRow(icon: "trash.fill", title: "Delete Account", color: .red, isDestructive: true) {
                                showDeleteAlert = true
                            }
                        }
                        
                        if viewModel.authUser?.isAnonymous == true {
                            settingsGroupTitle("LINK ACCOUNT")
                            SettingsRow(icon: "g.circle.fill", title: "Link Google Account", color: .white) {
                                Task { try? await viewModel.linkGoogleAccount() }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .font(.headline)
            }
        }
        .onAppear {
            viewModel.loadAuthUser()
        }
        .onChange(of: showSignInView) { _, newValue in
            if !newValue { viewModel.loadAuthUser() }
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        .alert("Delete Account", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task { await deleteAccount() }
            }
        } message: {
            Text("Are you sure you want to delete your account permanently? This action cannot be undone.")
        }
    }
}

// MARK: - Subviews & Components

extension SettingsView {
    private var accountHeaderView: some View {
        VStack(spacing: 15) {
            Button {
                if viewModel.authUser == nil { showSignInView = true }
            } label: {
                ZStack {
                    if let photoUrl = viewModel.authUser?.photoUrl, let url = URL(string: photoUrl) {
                        WebImage(url: url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 2))
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            )
                    }
                    
//                    // Nút edit nhỏ (Optional)
//                    if viewModel.authUser != nil {
//                        Image(systemName: "pencil.circle.fill")
//                            .foregroundStyle(.white, .blue)
//                            .font(.title2)
//                            .offset(x: 35, y: 35)
//                    }
                }
            }
            
            VStack(spacing: 5) {
                if let user = viewModel.authUser {
                    Text(user.name ?? "User")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(user.email ?? "Anonymous User")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text("Guest User")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Button("Sign in now") { showSignInView = true }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(themeManager.secondaryColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
    
    private func settingsGroupTitle(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 10)
            .padding(.leading, 10)
    }
    
    private func deleteAccount() async {
        isDeleting = true
        defer { isDeleting = false }
        do {
            if viewModel.authUser?.isAnonymous == true {
                try viewModel.signOut()
            } else {
                try await viewModel.deleteAccount()
                try viewModel.signOut()
            }
            viewModel.authUser = nil
        } catch {
            print("Error deleting account: \(error)")
        }
        viewModel.loadAuthUser()
    }
}

// MARK: - Custom Settings Row Component
struct SettingsRow: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    
    let icon: String
    let title: String
    let color: Color
    var isDestructive: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isDestructive ? .red : themeManager.textColor)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding()
            .background(themeManager.secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
        .preferredColorScheme(.dark)
}
