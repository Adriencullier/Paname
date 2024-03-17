import SwiftUI
import Paname_Discovery

@main
struct Paname_ApplicationApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DiscoveryBuiler.createModule(payload: DiscoveryPayload())
            }
        }
    }
}
