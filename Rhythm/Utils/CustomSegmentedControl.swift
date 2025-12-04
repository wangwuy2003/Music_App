//
//  CustomSegmentedControl.swift
//  Rhythm
//
//  Created by MacMini A6 on 4/12/25.
//
import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var selectedMode: AuthMode
    
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AuthMode.allCases) { mode in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedMode = mode
                    }
                } label: {
                    Text(mode.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(selectedMode == mode ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            ZStack {
                                if selectedMode == mode {
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.accentColor)
                                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                                }
                            }
                        )
                }
            }
        }
        .padding(4)
        .background(Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    CustomSegmentedControl(selectedMode: .constant(.signIn))
        .padding()
}
