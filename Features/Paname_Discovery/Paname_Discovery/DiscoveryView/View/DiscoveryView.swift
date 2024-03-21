import SwiftUI
import Navigation

struct EventCard: View, Identifiable {
    var id: UUID = UUID()
    
    var body: some View {
        VStack {
            Text("Card")
            Spacer()
            Text("Card")
        }
    }
}

/// Discovery View
public struct DiscoveryView: NavView {
    public typealias ViewModel = DiscoveryViewModel
    public var viewModel: DiscoveryViewModel
    
    public var content: AnyView {
        AnyView(
            PScrollView<EventCard>(contents: [EventCard(), EventCard(), EventCard(), EventCard()])
        )
    }
}
