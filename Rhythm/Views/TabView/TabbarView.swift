import SwiftUI
import SwiftfulRouting

struct TabbarView: View {
    @State private var selectedTab: TabEnum = .home
    
    var body: some View {
//        TabView(selection: $selectedTab) {
//            ForEach(TabEnum.defaultTabs, id: \.self) { tab in
//                TabEnum.view(for: tab)
//                    .tabItem({
//                        Image(systemName: tab.image)
//                    })
//                    .tag(tab)
//            }
//        }
        
        TabView {
            // HOME
            RouterView(addNavigationStack: true, addModuleSupport: false) { _ in
                HomeView()
            }
            .tabItem {
//                Label("Home", systemImage: "house.fill")
                Image(systemName: "house.fill")
            }

            // SEARCH
            RouterView(addNavigationStack: true, addModuleSupport: false) { _ in
                SearchView()
            }
            .tabItem {
//                Label("Search", systemImage: "magnifyingglass")
                Image(systemName: "magnifyingglass")
            }

            // LIBRARY
            RouterView(addNavigationStack: true, addModuleSupport: false) { _ in
                LibraryView()
            }
            .tabItem {
//                Label("Library", systemImage: "music.note")
                Image(systemName: "music.note")
            }

            // PROFILE
            RouterView(addNavigationStack: true, addModuleSupport: false) { _ in
                ProfileView()
            }
            .tabItem {
//                Label("Profile", systemImage: "person.fill")
                Image(systemName: "person.fill")
            }
        }
    }
}

#Preview {
    TabbarView()
}

