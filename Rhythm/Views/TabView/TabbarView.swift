import SwiftUI
import SwiftfulRouting

struct TabbarView: View {
    @State private var selectedTab: TabEnum = .home
    @State private var showMiniPlayer: Bool = true
    @StateObject private var playerVM = PlayerViewModel()
    @StateObject private var mediaPlayerState = MediaPlayerState()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.black
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                ForEach(TabEnum.defaultTabs, id: \.self) { tab in
                    RouterView(addNavigationStack: true, addModuleSupport: false) { router in
                        tab.view(router: router)
                            .environmentObject(mediaPlayerState)
                    }
                    .tabItem { Image(systemName: tab.image) }
                    .tag(tab)
                }
            }
            .environmentObject(playerVM)
            .environmentObject(mediaPlayerState)
            
            if mediaPlayerState.isMediaPlayerShown {
                VStack {
                    PlayerMusicView()
                        .frame(height: mediaPlayerState.isMediaPlayerExpanded ? nil : 60)
                        .cornerRadius(mediaPlayerState.isMediaPlayerExpanded ? 40 : 15)
                        .padding(.horizontal, mediaPlayerState.isMediaPlayerExpanded ? 0 : 5)
                        .padding(.bottom, mediaPlayerState.isMediaPlayerExpanded ? -20 : 40)
                        .padding(.top, mediaPlayerState.isMediaPlayerExpanded ? 60 : 40)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mediaPlayerState.isMediaPlayerExpanded.toggle()
                            }
                        }
                        .environmentObject(mediaPlayerState)
                }
                .frame(maxHeight: .infinity, alignment: mediaPlayerState.isMediaPlayerExpanded ? .top : .bottom)
                .padding(.bottom)
                .ignoresSafeArea(edges: mediaPlayerState.isMediaPlayerExpanded ? .all : .top)
            }
        }
        
    }
}

#Preview {
    RootView {
        TabbarView()
    }
}

