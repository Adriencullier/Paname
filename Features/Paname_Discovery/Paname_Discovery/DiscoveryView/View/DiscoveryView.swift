import SwiftUI
import Navigation

/// Discovery View
public struct DiscoveryView: NavView {
    // MARK: - Typealias
    public typealias ViewModel = DiscoveryViewModel
    
    // MARK: - Properties
    @ObservedObject public var viewModel: DiscoveryViewModel
    
    // MARK: - Content view
    public var content: AnyView {
        AnyView(
            PScrollView<EventCard>(self.viewModel.eventCardViewModels.map({
                EventCard(viewModel: $0)
            }))
        )
    }
}
