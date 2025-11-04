//
//  ProfileView.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI

enum SettingField: String, CaseIterable, Hashable {
    case feedback
    case rateApp
    case shareApp
    case privacy
    case termOfUse
    
    var iconName: String {
        switch self {
        case .feedback:         return "envelope"
        case .rateApp:          return "star"
        case .shareApp:         return "link"
        case .privacy:          return "lock"
        case .termOfUse:        return "info.circle"
        }
    }
    
    var title: String {
        switch self {
        case .feedback:         return .localized("Feedback")
        case .rateApp:          return .localized("Rate App")
        case .shareApp:         return .localized("Share App")
        case .privacy:          return .localized("Privacy Policy")
        case .termOfUse:        return .localized("Term Of Use")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.hex291F2A, .hex0F0E13], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    headerView
                    settingsList
                        .padding(.top, 30)
                }
            }
            .ignoresSafeArea()
        }
    }
    
    private var headerView: some View {
        ZStack(alignment: .bottom) {
            Image("banner")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .stretchy()
            
            Image("image1")
                .resizable()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay(alignment: .bottomTrailing) {
                    ZStack {
                        Circle()
                            .fill(.thinMaterial)
                            .overlay(
                                Circle().fill(Color.black.opacity(0.3))
                            )
                            .frame(width: 40, height: 40)
                            .shadow(radius: 3)
                        
                        Image(systemName: "pencil.line")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
//                    .offset(x: -10, y: -10)
                }
                .shadow(radius: 10)
                .offset(y: 80)
        }
        .padding(.bottom, 50)
    }
    
    private var settingsList: some View {
        VStack(spacing: 3) {
            ForEach(SettingField.allCases, id: \.self) { field in
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 36, height: 36)
                        Image(systemName: field.iconName)
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                    }
                    
                    Text(field.title)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .regular))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray.opacity(0.8))
                        .font(.system(size: 14))
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(Color.white.opacity(0.05))
                .cornerRadius(8)
                .onTapGesture {
                    handleTap(field)
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: Actions
    private func handleTap(_ field: SettingField) {
        switch field {
        case .feedback:
            print("📧 Feedback tapped")
        case .rateApp:
            print("⭐ Rate app tapped")
        case .shareApp:
            print("🔗 Share app tapped")
        case .privacy:
            print("🔒 Privacy Policy tapped")
        case .termOfUse:
            print("📜 Term of Use tapped")
        }
    }
}

#Preview {
    ProfileView()
}
