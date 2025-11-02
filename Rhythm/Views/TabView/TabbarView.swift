import SwiftUI
import SwiftfulRouting
import LNPopupUI

struct TabbarView: View {
    @State private var selectedTab: TabEnum = .home
    @State private var showMiniPlayer: Bool = false
    @EnvironmentObject var playerVM: PlayerViewModel
//    @StateObject private var playerVM = PlayerViewModel()
    
//    init() {
//        UITabBar.appearance().backgroundColor = UIColor.black
//        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
//    }
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        
        // Màu icon
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        UITabBar.appearance().tintColor = UIColor.accent
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                ForEach(TabEnum.defaultTabs, id: \.self) { tab in
                    RouterView(addNavigationStack: true, addModuleSupport: false) { router in
                        tab.view(router: router)
                            .environmentObject(playerVM)
                    }
                    .tabItem {
                        Image(systemName: tab.image)
                        Text(tab.title)
                    }
                    .tag(tab)
                }
            }
            .environmentObject(playerVM)
            .popup(isBarPresented: $playerVM.isBarPresented, isPopupOpen: $playerVM.isPopupOpen) {
                PlayerView()
                    .environmentObject(playerVM)
            }
            .popupBarShineEnabled(true)
            .popupBarProgressViewStyle(.bottom)
        }
    }
}

#Preview {
    TabbarView()
}

