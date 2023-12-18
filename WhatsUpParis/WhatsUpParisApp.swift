import SwiftUI

@main
struct WhatsUpParisApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                DiscoveryBuilder().createModule()
                    .tabItem {
                        Label("Discovery", systemImage: "house")
                            .foregroundColor(Color("Wwhite"))
                    }
                    .toolbarBackground(Color("Wwhite").opacity(0.1), for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
            }
        }
        
    }
}
