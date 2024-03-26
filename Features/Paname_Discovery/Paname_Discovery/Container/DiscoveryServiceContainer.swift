import SwiftUI
import CacheManager
import Paname_Core

public final class DiscoveryServiceContainer: ServiceContainer {
    let imageCache = ViewCache<Image>()
    let eventService = EventsService()
    
    init() {}
}
