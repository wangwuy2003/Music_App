//
//  SignInEmailView.swift
//  Rhythm
//
//  Created by MacMini A6 on 5/11/25.
//

import SwiftUI

struct SignInEmailView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
//            Circle()
//                .fill(Color.blue.opacity(0.1))
//                .frame(width: 300)
//                .blur(radius: 60)
//                .offset(x: -100, y: -200)
            
            VStack(spacing: 25) {
                Text(viewModel.mode == .signIn ? .localized("Welcome back.") : .localized("Create new account."))
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                
                CustomSegmentedControl(selectedMode: $viewModel.mode)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 15) {
                        CustomTextField(
                            title: "Email address",
                            iconName: "envelope",
                            text: $viewModel.email
                        )
                        
                        CustomTextField(
                            title: "Password",
                            iconName: "lock",
                            text: $viewModel.password,
                            isSecure: true
                        )
                        
                        if viewModel.mode == .signUp {
                            CustomTextField(
                                title: "Confirm Password",
                                iconName: "lock.shield",
                                text: $viewModel.confirmPassword,
                                isSecure: true
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.mode)
                }
                
                Button {
                    Task {
                        await viewModel.action()
                        if !viewModel.showErrorAlert {
                            showSignInView = false
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.mode == .signIn ? "Sign In" : "Sign Up")
                            .font(.headline)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(colors: [Color.accentColor, Color.purple], startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
            }
        }
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
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

struct CustomTextField: View {
    var title: String
    var iconName: String
    @Binding var text: String
    var isSecure: Bool = false
    @State private var isVisible: Bool = false
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon đầu dòng
            Image(systemName: iconName)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
                .frame(width: 24)
            
            // Nội dung nhập liệu
            if isSecure && !isVisible {
                SecureField(title, text: $text)
                    .foregroundColor(.white)
            } else {
                TextField(title, text: $text)
                    .foregroundColor(.white)
                    .textInputAutocapitalization(.never)
                    .keyboardType(isSecure ? .default : .emailAddress)
            }
            
            // Nút con mắt (chỉ hiện nếu là SecureField)
            if isSecure {
                Button {
                    withAnimation { isVisible.toggle() }
                } label: {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .padding()
        // NỀN ĐẸP: Dùng UltraThinMaterial để tạo hiệu ứng kính mờ
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        // VIỀN SÁNG: Tạo điểm nhấn sang trọng
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct PasswordField: View {
    let title: String
    @Binding var text: String
    @State private var isVisible: Bool = false // Trạng thái ẩn/hiện
    
    var body: some View {
        HStack {
            if isVisible {
                TextField(title, text: $text)
                    .foregroundColor(.white)
            } else {
                SecureField(title, text: $text)
                    .foregroundColor(.white)
            }
            
            // Nút con mắt
            Button {
                isVisible.toggle()
            } label: {
                Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}
