import SwiftUI

/// Aims to define ShipRouter
protocol ShipRouterProtocol {
    /// Selected route
    var selectedRoute: ShipRoute { get set }
}

/// ShipRouter
final class ShipRouter<RoutesEnum: ShipRoutesEnumProtocol>: ShipRouterProtocol, ObservableObject {
    /// Selected route
    @Published var selectedRoute: ShipRoute = ShipRoute.shipEmptyRoute
    @Published var settingsDetent: PresentationDetent = .medium
    
    /// Method used to navigate to a route owned by the ShipRoutesEnum
    /// - Parameter routeKey: ShipRoutesEnumProtocol
    func navigate(to route: RoutesEnum) {
        let shipRoute = route.shipRoute
        shipRoute.isPresented = true
        self.selectedRoute = shipRoute
    }
    
    /// Aims to dismiss or pop the view
    func dismiss() {
        self.selectedRoute = ShipRoute.shipDismissRoute
    }
    
    /// Aims to popToRoot the view
    func popToRoot() {
        self.selectedRoute = ShipRoute.shipPopToRootRoute
    }
}

/// Container used for handle pop to root
struct PopToRootContainerView<Content: View>: View {
    /// <#Description#>
    @EnvironmentObject var rootView: RootView
    
    private let content: Content
    
    /// <#Description#>
    /// - Parameter content: <#content description#>
    init(_ content: @autoclosure () -> Content) {
        self.content = content()
    }
    
    /// <#Description#>
    var body: some View {
        DismissContainerView(
        content
        )
            .onAppear {
                self.rootView.id = UUID()
            }
    }
}


