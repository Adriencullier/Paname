import Combine
import SwiftUI
import Paname_Core
import Navigation
import CacheManager

/// Discovery ViewModel
public final class DiscoveryViewModel: NavViewModel {
    public typealias Router = DiscoveryRouter
    
    @Published public var router: DiscoveryRouter
    unowned let imageCache: ViewCache<Image>
    
    public var subscription: AnyCancellable?
    var eventCardViewModels: [EventCardViewModel] { [
        EventCardViewModel(title: "Le top du top",
                           address: "Dans Paris",
                           leadText: "Ceci est un super évènement",
                           dateDescription: "lundi 3 janvier",
                           categories: [],
                           coverUrlStr: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Google_Images_2015_logo.svg/1200px-Google_Images_2015_logo.svg.png",
                           accessUrlStr: "",
                           imageCache: self.imageCache,
                           onBookingButtonPressed: {_ in})
    ]}
    
    public init(router: DiscoveryRouter, imageCache: ViewCache<Image>) {
        self.router = router
        self.imageCache = imageCache
        self.routerSubscription()
    }
    
    public func onDetailPressed() {
        self.router.navigate(to: .detail)
    }
}
