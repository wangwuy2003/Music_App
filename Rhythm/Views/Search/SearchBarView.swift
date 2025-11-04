//
//  SearchBarView.swift
//  Rhythm
//
//  Created by MacMini A6 on 3/11/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ? Color.secondary : .white
                )
            
            TextField(.localized("Search..."), text: $searchText)
                .foregroundStyle(.white)
            
                .onAppear {
                    UITextField.appearance().tintColor = .white
                }
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundStyle(.white)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                }
        }
        .font(.headline)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.hex7A51E2.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.hex7A51E2, lineWidth: 1.5)
                )
                .shadow(color: .hexCBB7FF.opacity(0.2), radius: 10, x: 0, y: 0)
        )
        .padding(.horizontal)
    }
}
