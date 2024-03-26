import SwiftUI
import CacheManager
import Paname_Core

/// EventCard viewModel
final class EventCardViewModel: ObservableObject, DataImageAccess {
    // MARK: - Properties
    @Published var imageData: Data?
    
    unowned let imageCache: DataCache<Data>
    
    var title: String
    var address: String
    var leadText: String
    var dateDescription: String
    var categories: [Category] = []
    var onBookingButtonPressed: (_ url: URL) -> Void
    var reservationButtonMode: ReservationButtonUIMode = .notBookable
    
    private var coverUrlStr: String
    
    // MARK: - Init
    init?(_ eventEntity: EventEntity,
          imageCache: DataCache<Data>,
          onBookingButtonPressed: @escaping (_: URL) -> Void) {
        self.imageCache = imageCache
        guard let title = eventEntity.title,
              let adddress = eventEntity.addressName,
              let leadText = eventEntity.leadText,
              let dateDescription = eventEntity.dateDescription,
              let coverUrlStr = eventEntity.coverUrlStr else {
            return nil
        }
        self.title = title
        self.address = adddress
        self.leadText = leadText
        self.dateDescription = dateDescription
        self.coverUrlStr = coverUrlStr
        self.onBookingButtonPressed = onBookingButtonPressed
    }
    
    func viewDidAppear() {
        self.getImageData(from: coverUrlStr) { data in
            DispatchQueue.main.async {
                self.imageData = data
            }
        }
    }
}
