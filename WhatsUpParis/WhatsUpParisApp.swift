import SwiftUI

@main
struct WhatsUpParisApp: App {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "Wblack")]
        UINavigationBar.appearance().barTintColor = UIColor(named: "Wwhite")
    }
    var body: some Scene {
        WindowGroup {
            DiscoveryBuilder().createModule()
                .accentColor(Color("AccentColor"))
        }
    }
}
