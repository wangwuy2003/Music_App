//
//  RootContainer.swift
//  Rhythm
//
//  Created by Apple on 5/10/25.
//
import SwiftUI
import SwiftfulRouting

struct RootContainer: View {
    let router: AnyRouter

    @StateObject private var homeVM: HomeViewModel

    init(router: AnyRouter) {
        self.router = router
        _homeVM = StateObject(wrappedValue: HomeViewModel(router: router))
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            TabbarView()
                .transition(.move(edge: .top).combined(with: .opacity))
                .preferredColorScheme(.dark)
        }
        .environmentObject(homeVM) // 👈 truyền VM ổn định xuống toàn bộ cây view
        .preferredColorScheme(.dark)
    }
}
