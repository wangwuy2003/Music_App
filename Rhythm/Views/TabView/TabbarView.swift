import SwiftUI
import SwiftfulRouting

struct TabbarView: View {
    @State private var selectedTab: TabEnum = .home
    
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
    }
}

#Preview {
    TabbarView()
}

