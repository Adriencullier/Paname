import SwiftUI

struct DiscoveryBuilder {
    typealias Content = View
    
    func createModule(eventService: EventService,
                      discoveryFiltersService: DiscoveryFiltersService) -> some View {
        let dataState = DiscoveryDataState(eventService: eventService, discoveryFiltersService: discoveryFiltersService)
//        let router = ShipRouter<DiscoveryRoute>()
        
        return DiscoveryView(viewState: dataState)
    }
}
