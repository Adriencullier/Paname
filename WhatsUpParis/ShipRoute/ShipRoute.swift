import SwiftUI

/// Ship Route
final class ShipRoute: ObservableObject {
    // MARK: - Properties
    /// Route view isPresented or not
    @Published var isPresented: Bool = false
    
    /// Type of navigation event
    var navigationEvent: NavigationEvent
    /// Destination View
    var destinationView: ShipLazyView<AnyView>
    
    // MARK: - Init
    init(navigationType: NavigationEvent, destination: @escaping () -> AnyView) {
        self.navigationEvent = navigationType
        self.destinationView = ShipLazyView(destination().av)
    }
}

// MARK: - Static properties Extension
extension ShipRoute {
    /// Empty route
    static var shipEmptyRoute: ShipRoute {
        ShipRoute(navigationType: .none) {
            ShipLazyView(VoidView().av).av
        }
    }
    /// Dismiss Route
    static var shipDismissRoute: ShipRoute {
        ShipRoute(navigationType: .pop) {
            ShipLazyView(VoidView().av).av
        }
    }
    /// Pop to root route
    static var shipPopToRootRoute: ShipRoute {
        ShipRoute(navigationType: .popToRoot) {
            ShipLazyView(VoidView().av).av
        }
    }
}
