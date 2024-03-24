import Paname_Core

/// Tabbar payload
public struct TabbarPayload {
    // MARK: - Properties
    public let appRouter: AppRouter
    /// Tabbar items
    public let items: [TabItem]
    
    // MARK: - Init
    public init(appRouter: AppRouter, items: [TabItem]) {
        self.appRouter = appRouter
        self.items = items
    }
}
