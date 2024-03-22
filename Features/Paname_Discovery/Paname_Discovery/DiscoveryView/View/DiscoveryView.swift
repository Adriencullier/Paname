import SwiftUI
import Navigation

/// Discovery View
public struct DiscoveryView: NavView {
    public typealias ViewModel = DiscoveryViewModel
    public var viewModel: DiscoveryViewModel
    
    public var content: AnyView {
        AnyView(
            PScrollView<EventCard>(contents: self.viewModel.eventCardViewModels.map({ EventCard(viewModel: $0) }))
        )
    }
}
