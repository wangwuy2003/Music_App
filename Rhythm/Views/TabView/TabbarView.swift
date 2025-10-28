import SwiftUI
import SwiftfulRouting
import LNPopupUI

struct TabbarView: View {
    @State private var selectedTab: TabEnum = .home
    @State private var showMiniPlayer: Bool = false
    @StateObject private var playerVM = PlayerViewModel()
    
//    init() {
//        UITabBar.appearance().backgroundColor = UIColor.black
//        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
//    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                ForEach(TabEnum.defaultTabs, id: \.self) { tab in
                    RouterView(addNavigationStack: true, addModuleSupport: false) { router in
                        tab.view(router: router)
                            .environmentObject(playerVM)
                    }
                    .tabItem { Image(systemName: tab.image) }
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

