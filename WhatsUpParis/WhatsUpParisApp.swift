import SwiftUI

@main
struct WhatsUpParisApp: App {
    let discoveryFiltersService: DiscoveryFiltersService
    let eventService: EventService
    
    init() {
        self.discoveryFiltersService = DiscoveryFiltersService()
        self.eventService = EventService()
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "Wblack")]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "Wblack")]
        UINavigationBar.appearance().barTintColor = UIColor(named: "Wwhite")
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
            NavigationStack {
                DiscoveryBuilder().createModule(eventService: self.eventService,
                                                discoveryFiltersService: self.discoveryFiltersService)
                    .accentColor(Color("AccentColor"))
                    .toolbarTitleDisplayMode(.inlineLarge)
                    .navigationTitle("Découverte")
            }
            .navigationViewStyle(.stack)
        }
    }
}
