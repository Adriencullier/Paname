import SwiftUI

/// Aims to initialize the embeded view only if the view is about to be presented
/// Without this ShipLazyView, the destination view will be intialized at the parent view init
struct ShipLazyView<Content: View>: View {
    /// View to embed
    private let content: () -> Content
    
    // MARK: - Init
    init(_ build: @autoclosure @escaping () -> Content) {
        self.content = build
    }
    /// Body's view
    var body: Content {
        content()
    }
}
