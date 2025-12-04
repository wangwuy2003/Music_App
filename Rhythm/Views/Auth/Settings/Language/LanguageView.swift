//
//  LanguageView.swift
//  Rhythm
//
//  Created by MacMini A6 on 4/12/25.
//
import SwiftUI

struct LanguageView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var languageManager = LanguageManager.shared
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            themeManager.backgroundColor.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text(.localized("Select Language"))
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(themeManager.textColor)
                    .padding(.top)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(Language.allCases) { language in
                            Button {
                                withAnimation {
                                    languageManager.selectedLanguage = language.rawValue
                                }
                            } label: {
                                HStack {
                                    Text(language.icon)
                                        .font(.title)
                                    
                                    Text(language.displayName)
                                        .font(.headline)
                                        .foregroundStyle(themeManager.textColor)
                                    
                                    Spacer()
                                    
                                    if languageManager.selectedLanguage == language.rawValue {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.blue)
                                            .font(.title3)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundStyle(.gray)
                                            .font(.title3)
                                    }
                                }
                                .padding()
                                .background(themeManager.secondaryColor)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(languageManager.selectedLanguage == language.rawValue ? Color.blue : Color.clear, lineWidth: 1)
                                )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundStyle(themeManager.textColor)
                }
            }
        }
        // Force Redraw ID: Mẹo nhỏ để ép giao diện vẽ lại ngay khi đổi ngôn ngữ
        .id(languageManager.selectedLanguage)
    }
}

#Preview {
    NavigationStack {
        LanguageView()
    }
}
