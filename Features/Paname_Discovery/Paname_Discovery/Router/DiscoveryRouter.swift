import Navigation

/// Discovery router
public final class DiscoveryRouter: NavRouter {
    public typealias Route = DiscoveryRoute
    
    @Published public var isPresented: Bool = false
    @Published public var selectedRoute: DiscoveryRoute = .none
}
