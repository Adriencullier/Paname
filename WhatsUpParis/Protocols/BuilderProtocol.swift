import SwiftUI

protocol BuilderProtocol {
    associatedtype Content: View
    func createModule(eventService: EventService,
                      discoveryFilters: DiscoveryFilters) -> Content
}
