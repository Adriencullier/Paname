import Foundation
import SwiftUI
import CacheManager
import Paname_Core

final class EventCardViewModel {
    unowned let imageCache: ViewCache<Image>
    let title: String
    let address: String
    let leadText: String
    let dateDescription: String
    let categories: [Category]
    let coverUrlStr: String
    let onBookingButtonPressed: (_ url: URL) -> Void
    
    var reservationButtonMode: ReservationButtonUIMode = .notBookable
    
    init(title: String,
         address: String,
         leadText: String,
         dateDescription: String,
         categories: [Category],
         coverUrlStr: String,
         accessUrlStr: String,
         imageCache: ViewCache<Image>,
         onBookingButtonPressed: @escaping (_: URL) -> Void) {
        self.title = title
        self.address = address
        self.leadText = leadText
        self.dateDescription = dateDescription
        self.categories = categories
        if let url = URL(string: accessUrlStr) {
            self.reservationButtonMode = .bookable(url: url)
        }
        self.coverUrlStr = coverUrlStr
        self.imageCache = imageCache
        self.onBookingButtonPressed = onBookingButtonPressed
    }
}
