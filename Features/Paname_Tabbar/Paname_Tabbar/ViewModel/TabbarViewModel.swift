import Paname_Core

/// Tabbar ViewModel
public struct TabbarViewModel {
    unowned let appRouter: AppRouter
    /// Tabbar items
    var tabItems: [any TabItem]
}
