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
        HomeView()
            .environmentObject(homeVM)
    }
}
