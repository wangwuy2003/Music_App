//
//  AuthenticationView.swift
//  Rhythm
//
//  Created by MacMini A6 on 5/11/25.
//
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import MarqueeText

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    @Environment(\.colorScheme) var colorScheme
    
    @State private var animateGradient = false
    @State private var animateLogo = false
    
    let logoGradient = [Color.pink, Color.purple, Color.blue, Color.cyan]
    
    var body: some View {
        ZStack {
            backgroundLayer
            
            VStack(spacing: 25) {
                Spacer()
                
                logoAndTitleSection
                    .opacity(animateLogo ? 1 : 0)
                    .offset(y: animateLogo ? 0 : 20)
                    .animation(.easeOut(duration: 0.8), value: animateLogo)
                
                Spacer()
                
                // MARK: Button Section
                VStack(spacing: 16) {
                    // mail
                    NavigationLink {
                        SignInEmailView(showSignInView: $showSignInView)
                    } label: {
                        customButtonLabel(title: .localized("Sign in with Email"), icon: "envelope.fill", isPrimary: true)
                    }
                    
                    // google
                    Button {
                        Task {
                            try? await viewModel.signInGoogle()
                            showSignInView = false
                        }
                    } label: {
                        customButtonLabel(title: .localized("Sign in with Google"), icon: "google_ic", isSystemImage: false)
                    }
                    
                    // Guest Mode
                    Button {
                        Task {
                            try? await viewModel.signInAnonymous()
                            showSignInView = false
                        }
                    } label: {
                        Text(.localized("Continue as Guest"))
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(colorScheme == .dark ? .gray : .secondary)
                            .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                footerSection
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            animateGradient = true
            animateLogo = true
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showSignInView = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
        }
    }
}

// MARK: - Subviews & Components
extension AuthenticationView {
    private var backgroundLayer: some View {
        ZStack {
            if colorScheme == .dark {
                LinearGradient(
                    colors: [.hex291F2A, .hex0F0E13],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                LinearGradient(
                    colors: [Color.white, Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            
            // Thêm các đốm sáng (Orbs) trang trí
            GeometryReader { proxy in
                Circle()
                    .fill(Color.purple.opacity(colorScheme == .dark ? 0.3 : 0.15))
                    .frame(width: 300, height: 300)
                    .blur(radius: 60)
                    .offset(x: animateGradient ? -50 : 50, y: animateGradient ? -100 : -50)
                
                Circle()
                    .fill(Color.blue.opacity(colorScheme == .dark ? 0.3 : 0.15))
                    .frame(width: 250, height: 250)
                    .blur(radius: 60)
                    .offset(x: proxy.size.width - 150, y: proxy.size.height - 200)
            }
            .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: animateGradient)
        }
        .ignoresSafeArea()
    }
    
    private var logoAndTitleSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: logoGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 85, height: 85)
                    .blur(radius: 10)
                    .opacity(0.6)
                
                LinearGradient(
                    colors: logoGradient,
                    startPoint: animateGradient ? .topLeading : .bottomTrailing,
                    endPoint: animateGradient ? .bottomTrailing : .topLeading
                )
                .mask(
                    Image(systemName: "music.quarternote.3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                )
                .frame(width: 80, height: 80)
                .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            VStack(spacing: 8) {
                Text(.localized("Welcome to Rhythm"))
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                
                Text(.localized("Sign in to personalize your music experience"))
                    .font(.body)
                    .foregroundColor(colorScheme == .dark ? .gray : .secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
    }
    
    // 3. Footer (Marquee)
    private var footerSection: some View {
        VStack {
            MarqueeText(
                text: .localized("By continuing, you agree to our Terms and Privacy Policy."),
                font: .systemFont(ofSize: 13),
                leftFade: 16,
                rightFade: 16,
                startDelay: 3
            )
            .foregroundStyle(colorScheme == .dark ? .gray : .secondary)
            .frame(height: 30) // Cố định chiều cao tránh nhảy layout
        }
        .padding(.horizontal)
    }
    
    // 4. Custom Button Label Builder
    @ViewBuilder
    private func customButtonLabel(title: String, icon: String, isPrimary: Bool = false, isSystemImage: Bool = true) -> some View {
        HStack {
            if isSystemImage {
                Image(systemName: icon)
                    .font(.headline)
            } else {
                Image(icon) // Cho icon Google custom
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .foregroundStyle(isPrimary ? Color.white : (colorScheme == .dark ? .white : .black))
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .background {
            if isPrimary {
                // Style nút chính (Email) -> Gradient
                LinearGradient(colors: [.pink, .purple], startPoint: .leading, endPoint: .trailing)
            } else {
                // Style nút phụ (Google) -> Glassmorphism
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: isPrimary ? .blue.opacity(0.3) : .black.opacity(0.05), radius: 8, x: 0, y: 4)
        .scaleEffect(1.0) // Placeholder cho button press effect nếu cần
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(true))
        // Thử đổi sang .light để xem theme sáng
            .preferredColorScheme(.dark)
    }
}
