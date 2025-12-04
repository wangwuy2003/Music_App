import SwiftUI
import SwiftfulRouting
import LNPopupUI

struct TabbarView: View {
    @State private var selectedTab: TabEnum = .home
    @State private var showMiniPlayer: Bool = false
    @EnvironmentObject var playerVM: PlayerViewModel
    @ObservedObject private var themeManager = ThemeManager.shared
    
    init() {
        TabbarView.configureTabBar(isDarkMode: ThemeManager.shared.isDarkMode)
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
            .id(themeManager.isDarkMode)
            
            .environmentObject(playerVM)
            .popup(isBarPresented: $playerVM.isBarPresented, isPopupOpen: $playerVM.isPopupOpen) {
                PlayerView()
                    .environmentObject(playerVM)
            }
            .popupBarShineEnabled(true)
            .popupBarProgressViewStyle(.bottom)
        }
        .onChange(of: themeManager.isDarkMode) { _, newValue in
            TabbarView.configureTabBar(isDarkMode: newValue)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = newValue ? .dark : .light
                }
            }
        }
    }
    
    static func configureTabBar(isDarkMode: Bool) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = isDarkMode ? .black : .white
        
        let itemAppearance = UITabBarItemAppearance()
        
        itemAppearance.normal.iconColor = .gray
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        let accentColor = UIColor(named: "AccentColor") ?? .systemBlue
        itemAppearance.selected.iconColor = accentColor
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: accentColor]
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        UITabBar.appearance().tintColor = accentColor
        UITabBar.appearance().unselectedItemTintColor = .gray
    }
}

#Preview {
    TabbarView()
}

