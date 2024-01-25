import Foundation
import SwiftUI

/// List all the navigation events
enum NavigationEvent {
    // Open in modal
    case modal(detents: Set<PresentationDetent>)
    // Open with push
    case push
    // Pop to level -1
    case pop
    // Pop to rootView definied by the RootViewContainer
    case popToRoot
    // None case
    case none
}
