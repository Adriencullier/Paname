import SwiftUI
import CacheManager

public struct DiscoveryPayload {
    public let imageCache: ViewCache<Image>
    public init(imageCache: ViewCache<Image>) {
        self.imageCache = imageCache
    }
}
