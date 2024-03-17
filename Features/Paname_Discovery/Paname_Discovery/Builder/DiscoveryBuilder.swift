import SwiftUI
import Paname_Core

public struct DiscoveryPayload {
    public init() {}
}

public final class DiscoveryBuiler: BuilderProtocol {
    public typealias Content = DiscoveryView
    public typealias Payload = DiscoveryPayload
    
    public static func createModule(payload: DiscoveryPayload) -> DiscoveryView {
        let router = DiscoveryRouter()
        let viewModel = DiscoveryViewModel(router: router)
        return DiscoveryView(viewModel: viewModel)
    }
}
