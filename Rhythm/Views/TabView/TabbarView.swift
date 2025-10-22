import SwiftUI
import SwiftfulRouting

struct TabbarView: View {
    @State private var selectedTab: TabEnum = .home
    @StateObject private var playerVM = PlayerViewModel()
    
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
        .safeAreaInset(edge: .bottom, spacing: 0) {
            PlayerMusicView(
                isExpanded: Binding(
                    get: { playerVM.isExpanded },
                    set: { playerVM.isExpanded = $0 }
                ),
                selectedMusic: Binding(
                    get: { playerVM.selectedTrack },
                    set: { playerVM.selectedTrack = $0 }
                )
            )
            .environmentObject(playerVM)
            .padding(.horizontal, 12)
            .padding(.bottom, 6)
            .background(.clear)
        }
        .sheet(isPresented: $playerVM.isExpanded) {
            NavigationStack {
                PlayerMusicView(isExpanded: true, selectedMusic: playerVM.selectedTrack)
                    .environmentObject(playerVM)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button { playerVM.isExpanded = false } label: {
                                Image(systemName: "xmark").bold()
                            }
                        }
                    }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    TabbarView()
}

