//
//  LoginView.swift
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
    @State private var animate = false
    
    @State private var gradientShift = false
    let gradientColors = [Color.pink, Color.purple, Color.blue, Color.cyan]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.hex291F2A, .hex0F0E13],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer(minLength: 60)
                
                logoAndTitleSection
                

                Spacer()
                
                //  Sign in with Email
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView)
                } label: {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Sign in with Email")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(radius: 5)
                }
                
                //  Google Sign-In Button
                Button {
                    Task {
                        do {
                            try await viewModel.signInGoogle()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    HStack {
                        Image("google_ic")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Sign in with Google")
                            .font(.headline)
                    }
                    .foregroundStyle(.hex1F1922)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(radius: 5)
                }
                
                Button {
                    Task {
                        do {
                            try await viewModel.signInAnonymous()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Continue as Guest")
                        .underline(true, pattern: .solid, color: .secondary)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                MarqueeText(
                    text: "By continuing, you agree to our Terms and Privacy Policy.",
                    font: .systemFont(ofSize: 13),
                    leftFade: 16,
                    rightFade: 16,
                    startDelay: 5
                )
                .multilineTextAlignment(.center)
                
//                Text("By continuing, you agree to our Terms and Privacy Policy.")
//                    .lineLimit(2)
//                    .font(.footnote)
//                    .foregroundColor(.white.opacity(0.6))
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
            }
            .padding(30)
        }
        .onAppear {
            animate = true
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showSignInView = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
        }
    }
}

// MARK: Subviews
extension AuthenticationView {
    private var logoAndTitleSection: some View {
        VStack(spacing: 12) {
            LinearGradient(
                colors: gradientColors,
                startPoint: gradientShift ? .topLeading : .bottomTrailing,
                endPoint: gradientShift ? .bottomTrailing : .topLeading
            )
            .mask(
                Image(systemName: "music.quarternote.3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            )
            .frame(width: 80, height: 80)
            .shadow(radius: 10)
            .onAppear {
                withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: true)) {
                    gradientShift.toggle()
                }
            }

            Text("Welcome to Rhythm")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
            
            Text("Sign in to personalize your music experience")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(true))
            .preferredColorScheme(.dark)
    }
}
