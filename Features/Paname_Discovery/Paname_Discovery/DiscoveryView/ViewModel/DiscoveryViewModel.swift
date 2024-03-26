import Combine
import SwiftUI
import Paname_Core
import Navigation
import CacheManager

/// Discovery ViewModel
public final class DiscoveryViewModel: NavViewModel, ServiceObserver {
    // MARK: - Typealias
    public typealias Router = DiscoveryRouter
    
    // MARK: - Properties
    @Published public var router: DiscoveryRouter
    @Published var eventCardViewModels: [EventCardViewModel] = []
    
    private unowned let imageCache: DataCache<Data>
    private unowned let eventService: EventsService
    
    public var subscription: AnyCancellable?
    
    // MARK: - Init
    init(router: DiscoveryRouter,
         imageCache: DataCache<Data>,
         eventService: EventsService) {
        self.router = router
        self.eventService = eventService
        self.imageCache = imageCache
        self.observeServices([eventService])
        self.eventService.fetchData()
    }
    
    // MARK: - Public functions
    public func dataNeedsToBeUpdated(key: ObservedEvent, state: ServiceDataState) {
        switch key {
        case .discoveryEvent:
            DispatchQueue.main.async {
                self.eventCardViewModels = self.eventService.data.compactMap({
                    EventCardViewModel($0, imageCache: self.imageCache, onBookingButtonPressed: { _ in }) })
            }
        }
    }
    
    // MARK: - Internal functions
    func onDetailPressed() {
        self.router.navigate(to: .detail)
    }
}
