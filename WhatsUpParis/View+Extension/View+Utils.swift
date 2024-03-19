import SwiftUI

extension View {
    /// Aims to embed view in AnyView
    var av: AnyView {
        AnyView(self)
    }
}
