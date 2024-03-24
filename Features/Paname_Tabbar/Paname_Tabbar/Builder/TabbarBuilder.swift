import Foundation
import Paname_Core

/// Tabbar builder
public final class TabbarBuilder: BuilderProtocol {
    public typealias Content = TabbarView
    public typealias Payload = TabbarPayload
    
    public static func createModule(payload: TabbarPayload) -> TabbarView {
        let viewModel = TabbarViewModel(appRouter: payload.appRouter, tabItems: payload.items)
        return TabbarView(viewModel: viewModel)
    }
}
