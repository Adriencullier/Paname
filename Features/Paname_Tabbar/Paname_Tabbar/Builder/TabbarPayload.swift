import Paname_Core

/// Tabbar payload
public struct TabbarPayload {
    // MARK: - Properties
    /// Tabbar items
    public var items: [TabItem]
    
    // MARK: - Init
    public init(items: [TabItem]) {
        self.items = items
    }
}
