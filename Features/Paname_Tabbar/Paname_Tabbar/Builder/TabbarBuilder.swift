import Foundation
import Paname_Core

/// Tabbar builder
public final class TabbarBuilder: BuilderProtocol {
    // MARK: - Typealias
    public typealias Content = TabbarView
    public typealias Payload = TabbarPayload
    
    // MARK: - Init
    public init() {}
    
    // MARK: - public fun functions
    public func createModule(payload: TabbarPayload) -> TabbarView {
        let viewModel = TabbarViewModel(tabItems: payload.items)
        return TabbarView(viewModel: viewModel)
    }
}
