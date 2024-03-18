import SwiftUI
import Paname_Tabbar

@main
struct Paname_ApplicationApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TabbarBuilder.createModule(payload: TabbarPayload(items: PanamTabItem.allCases))
            }
        }
    }
}
