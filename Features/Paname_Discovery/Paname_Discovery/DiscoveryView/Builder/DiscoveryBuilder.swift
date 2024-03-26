import SwiftUI
import Paname_Core
import CacheManager

/// Discovery Builder
public final class DiscoveryBuiler: BuilderProtocol {
    // MARK: - Typealias
    public typealias Content = DiscoveryView
    public typealias Payload = DiscoveryPayload
    public typealias Container = DiscoveryServiceContainer

    // MARK: - Init
    public init() {}
    
    // MARK: - Public functions
    public func createModule(payload: DiscoveryPayload) -> DiscoveryView {
        let router = DiscoveryRouter()
        let viewModel = DiscoveryViewModel(router: router,
                                           imageCache: Container.imageCache,
                                           eventService: Container.eventsService)
        return DiscoveryView(viewModel: viewModel)
    }
}

/// Aims to own the services instances related Discovery
public final class DiscoveryServiceContainer: ServiceContainer {
    /// Image cache used to store cover images
    fileprivate static let imageCache = DataCache<Data>()
    /// Service used to get all the events
    fileprivate static let eventsService = EventsService()
}
