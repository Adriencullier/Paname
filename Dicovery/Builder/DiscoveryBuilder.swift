import SwiftUI

struct DiscoveryBuilder: BuilderProtocol {
    @MainActor func createModule() -> AnyView {
        let eventService = EventService()
        let viewModel = DiscoveryViewModel(eventService: eventService)
        let router = ShipRouter<DiscoveryRoute>()
        
        return ShipView(router: router) {
            ContentView(viewModel: viewModel, router: router)
        }.av
    }
}
