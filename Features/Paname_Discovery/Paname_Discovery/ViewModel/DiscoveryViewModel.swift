import Combine
import SwiftUI
import Paname_Core
import Navigation

public enum DiscoveryRoute: NavRoute {
    case detail
    case none
    
    public var destination: AnyView {
        switch self {
        case .detail:
            AnyView(
                Text("Detail")
                    .navigationTitle("Detail View")
            )
        case .none:
            AnyView(EmptyView())
        }
    }
    
    public var navigationMode: NavigationMode {
        switch self {
        case .detail:
                .push(conf: PushConfiguration())
        case .none:
                .none
        }
    }
}

public final class DiscoveryRouter: NavRouter {
    public typealias Route = DiscoveryRoute
    
    @Published public var isPresented: Bool = false
    @Published public var selectedRoute: DiscoveryRoute = .none
    
    
}

public final class DiscoveryViewModel: NavViewModel {
    public typealias Router = DiscoveryRouter
    @Published public var router: DiscoveryRouter
    public var subscription: AnyCancellable?
    
    public init(router: DiscoveryRouter) {
        self.router = router
        self.routerSubscription()
    }
    
    public func onDetailPressed() {
        self.router.navigate(to: .detail)
    }
}
