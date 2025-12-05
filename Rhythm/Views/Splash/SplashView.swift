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
        
        await withTaskGroup(of: Void.self) { group in
            
            group.addTask {
                await homeVM.fetchData()
                await homeVM.fetchRecentMixes()
                await MainActor.run {
                    homeVM.saveCache()
                }
            }
            
            group.addTask {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
            }
            
            _ = await group.next()
            
            group.cancelAll()
        }
        
        withAnimation(.easeOut(duration: 1.0)) {
            isLoading = false
        }
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        withAnimation(.easeOut(duration: 0.5)) {
            showMainView = true
        }
    }
}
