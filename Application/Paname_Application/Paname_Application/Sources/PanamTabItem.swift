import SwiftUI
import Paname_Discovery
import Paname_Core

/// Aims to define all the tabbar items
enum PanamTabItem: CaseIterable, TabItem {
    /// Discovery tab
    case discovery
    /// Favorites tab
    case favorites
    /// Settings tab
    case settings
    
    var id: Int {
        switch self {
        case .discovery:
            return 1
        case .favorites:
            return 2
        case .settings:
            return 3
        }
    }
    
    func getView(appRouter: AppRouter) -> AnyView {
        switch self {
        case .discovery:
            return AnyView(
                DiscoveryBuiler.createModule(payload: DiscoveryPayload(imageCache: appRouter.imageCache))
            )
        case .favorites, .settings:
            return AnyView(Text(self.title))
        }
    }
    
    var title: String {
        switch self {
        case .discovery:
            return "Discovery"
        case .favorites:
            return "Favorites"
        case .settings:
            return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .discovery:
            return "lightbulb.fill"
        case .favorites:
            return "tag.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}
