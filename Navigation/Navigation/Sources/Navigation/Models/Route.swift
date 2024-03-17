import SwiftUI

public protocol Route {
    var destination: AnyView { get }
    var navigationMode: NavigationMode { get }
}
