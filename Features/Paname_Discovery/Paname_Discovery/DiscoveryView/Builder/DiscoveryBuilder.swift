import SwiftUI
import Paname_Core

/// Discovery Builder
public final class DiscoveryBuiler: BuilderProtocol { 
    // MARK: - Typealias
    public typealias Content = DiscoveryView
    public typealias Payload = DiscoveryPayload
    
    // MARK: - Properties
    public let serviceContainer = DiscoveryServiceContainer()
    
    // MARK: - Init
    public init() {}
    
    // MARK: - Public functions
    public func createModule(payload: DiscoveryPayload) -> DiscoveryView {
        let router = DiscoveryRouter()
        let viewModel = DiscoveryViewModel(router: router,
                                           imageCache: serviceContainer.imageCache,
                                           eventService: serviceContainer.eventService)
        return DiscoveryView(viewModel: viewModel)
    }
}
