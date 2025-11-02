//
//  ToastModifier.swift
//  Rhythm
//
//  Created by Apple on 2/11/25.
//
import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let style: ToastStyle
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                VStack {
                    Spacer()
                    ToastView(message: message, style: style)
                        .onTapGesture {
                            withAnimation { isPresented = false }
                        }
                        .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: isPresented)
            }
        }
    }
}
