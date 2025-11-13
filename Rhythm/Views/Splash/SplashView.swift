//
//  SplashView.swift
//  Rhythm
//
//  Created by Apple on 27/10/25.
//

import SwiftUI
import Lottie
import SwiftfulLoadingIndicators

struct SplashView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @Binding var showMainView: Bool
    @State private var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                LottieView(fileName: "Music")
                
                if isLoading {
                    LoadingIndicator(animation: .text, color: .white)
                }
            }
        }
        .task {
            await preloadData()
        }
    }
    
    private func preloadData() async {
        homeVM.loadCache()
        
        Task.detached {
            await homeVM.fetchData()
            await homeVM.fetchRecentMixes()
            await MainActor.run {
                homeVM.saveCache()
            }
        }

        withAnimation(.easeOut(duration: 1.5)) {
            isLoading = false
        }
        
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        withAnimation(.easeOut(duration: 0.5)) {
            showMainView = true
        }
    }
}
