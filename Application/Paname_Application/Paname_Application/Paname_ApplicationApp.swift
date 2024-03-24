import SwiftUI
import Paname_Tabbar
import Paname_Core

@main
struct Paname_ApplicationApp: App {
    let appRouter = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TabbarBuilder.createModule(payload: TabbarPayload(appRouter: self.appRouter, 
                                                                  items: PanamTabItem.allCases))
            }
        }
    }
}
