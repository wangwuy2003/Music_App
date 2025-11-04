//
//  View+Extst.swift
//  Rhythm
//
//  Created by Apple on 2/11/25.
//
import SwiftUI

extension View {
    func toast(
        isPresented: Binding<Bool>,
        message: String,
        style: ToastStyle = .info
    ) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message, style: style))
    }
    
    @ViewBuilder
    func conditionalClipShape(isCircle: Bool) -> some View {
        if isCircle {
            self.clipShape(Circle())
        } else {
            self.clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    func stretchy() -> some View {
        visualEffect { effect, geometry in
            let currentHeight = geometry.size.height
            let scrollOffset = geometry.frame(in: .scrollView).minY
            let positiveOffset = max(0, scrollOffset)
            
            let newHeight = currentHeight + positiveOffset
            let scaleFactor = newHeight / currentHeight
            
            return effect.scaleEffect(
                x: scaleFactor, y: scaleFactor,
                anchor: .bottom
            )
        }
    }
}
