import Navigation
import SwiftUI

/// Aims to define all the Discovery Routes
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
