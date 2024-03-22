import Combine
import SwiftUI
import Paname_Core
import Navigation

/// Discovery ViewModel
public final class DiscoveryViewModel: NavViewModel {
    public typealias Router = DiscoveryRouter
    
    @Published public var router: DiscoveryRouter
    
    public var subscription: AnyCancellable?
    var eventCardViewModels: [EventCardViewModel] = [
        EventCardViewModel(title: "Le top du top",
                           address: "Dans Paris",
                           leadText: "Ceci est un super évènement",
                           dateDescription: "lundi 3 janvier",
                           categories: [],
                           accessUrlStr: "",
                           onBookingButtonPressed: {_ in})
    ]
    
    public init(router: DiscoveryRouter) {
        self.router = router
        self.routerSubscription()
    }
    
    public func onDetailPressed() {
        self.router.navigate(to: .detail)
    }
}
