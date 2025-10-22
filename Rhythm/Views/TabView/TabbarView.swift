import SwiftUI
import SwiftfulRouting
import LNPopupUI

struct TabbarView: View {
    @State private var selectedTab: TabEnum = .home
    @State private var showMiniPlayer: Bool = true
    @StateObject private var playerVM = PlayerViewModel()
    @State var currentSong: RandomTitleSong = .init(id: 1, title: "helfawe", subtitle: "fjaweiofjaewio")
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(TabEnum.defaultTabs, id: \.self) { tab in
                RouterView(addNavigationStack: true, addModuleSupport: false) { router in
                    tab.view(router: router)
                }
                .tabItem { Image(systemName: tab.image) }
                .tag(tab)
            }
        }
        .environmentObject(playerVM)
//        .onChange(of: currentSong) { newValue in
//            playerVM.isBarPresented = newValue != nil
//        }
//        .onChange(of: playerVM.isPopupOpen) { newValue in
//            if newValue == false {
//                currentSong = nil
//            }
//        }
//        .popup(
//            isBarPresented: $playerVM.isBarPresented,
//            isPopupOpen: $playerVM.isPopupOpen
//        ) {
//            if let currentSong = currentSong {
//                PlayerMusicView(song: currentSong)
//                    .environmentObject(playerVM)
//                    .ignoresSafeArea()
//            }
//        }
    }
}

#Preview {
    RootView {
        TabbarView()
    }
}

