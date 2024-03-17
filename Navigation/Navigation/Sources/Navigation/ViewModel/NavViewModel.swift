import SwiftUI
import Combine

public protocol NavViewModel: ObservableObject {
    associatedtype R: Route
    var route: R { get set }
}
