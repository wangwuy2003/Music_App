import SwiftUI

struct TabbarView: View {
    @State private var selectedTab: TabEnum = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(TabEnum.defaultTabs, id: \.self) { tab in
                TabEnum.view(for: tab)
                    .tabItem({
                        Image(systemName: tab.image)
                    })
                    .tag(tab)
            }
        }
    }
}

#Preview {
    TabbarView()
}
