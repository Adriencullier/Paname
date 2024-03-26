import SwiftUI

/// Aims to define a TabItem object
public protocol TabItem {
    /// Tab item id
    var id: Int { get }
    /// Tab item title
    var title: String { get }
    /// Tab item system icon
    var icon: String { get }
    /// Tab item view
    var view: AnyView { get }
}
