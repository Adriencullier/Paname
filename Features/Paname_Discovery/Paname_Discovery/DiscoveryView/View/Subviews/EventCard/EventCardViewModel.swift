import Foundation

final class EventCardViewModel {
    let title: String
    let address: String
    let leadText: String
    let dateDescription: String
    let categories: [Category]
    let onBookingButtonPressed: (_ url: URL) -> Void
    
    var reservationButtonMode: ReservationButtonUIMode = .notBookable
    
    init(title: String,
         address: String,
         leadText: String,
         dateDescription: String,
         categories: [Category],
         accessUrlStr: String,
         onBookingButtonPressed: @escaping (_: URL) -> Void) {
        self.title = title
        self.address = address
        self.leadText = leadText
        self.dateDescription = dateDescription
        self.categories = categories
        if let url = URL(string: accessUrlStr) {
            self.reservationButtonMode = .bookable(url: url)
        }
        self.onBookingButtonPressed = onBookingButtonPressed
    }
}
