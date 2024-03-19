import SwiftUI

@main
struct WhatsUpParisApp: App {
    init() {
<<<<<<< HEAD
        self.discoveryFiltersService = DiscoveryFiltersService()
        self.eventService = EventService(filterService: discoveryFiltersService)
=======
>>>>>>> parent of 78ecde8 (wip: remove custom navigation)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "Wblack")]
        UINavigationBar.appearance().barTintColor = UIColor(named: "Wwhite")
    }
<<<<<<< HEAD
    
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
=======
    var body: some Scene {
        WindowGroup {
            DiscoveryBuilder().createModule()
                .accentColor(Color("AccentColor"))
>>>>>>> parent of 78ecde8 (wip: remove custom navigation)
        }
    }
}
