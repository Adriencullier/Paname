import Foundation

enum PriceType: String, Codable {
    case payant
    case gratuit
}

struct EventEntity: Codable, Equatable {
    var id : String?
    var title: String?
    var leadText: String?
    var tags: [String]?
    var coverUrlStr: String?
    var accessUrlStr: String?
    var dateDescription: String?
    var pmr: Int?
    var blind: Int?
    var deaf: Int?
    var addressName: String?
    var addressStreet: String?
    var zipCode: String?
    var addressCity: String?
    var priceType: String?
    var dateStart: String?
    var dateEnd: String?
    var occurrences: String?
    var audience: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case leadText = "lead_text"
        case tags = "tags"
        case addressName = "address_name"
        case addressStreet = "address_street"
        case addressCity = "address_city"
        case zipCode = "address_zipcode"
        case coverUrlStr = "cover_url"
        case accessUrlStr = "access_link"
        case dateDescription = "date_description"
        case pmr = "pmr"
        case blind = "blind"
        case deaf = "deaf"
        case priceType = "price_type"
        case occurrences = "occurrences"
        case audience = "audience"
        case dateStart = "date_start"
        case dateEnd = "date_end"
    }
}

protocol BaseEntity: Codable {
    associatedtype ResultType: Codable
    
    var results: [ResultType] { get set }
}

struct EventsResult: BaseEntity {
    typealias ResultType = EventEntity
    
    var results: [EventEntity]
}


struct APIError: Error {}
enum ServiceDataState {
    case successed
    case failed(error: Error)
    case loading
    case none
}

class Weak<T: Identifiable & AnyObject>: Hashable {
    static func == (lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        lhs.value?.id == rhs.value?.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.value?.id)
    }
    
  weak var value : T?
  init (value: T) {
    self.value = value
  }
}

protocol ObservableService {
    associatedtype DataType
    var observers: Set<Weak<ServiceObserver>> { get set}
    var dataKey: DataKey { get }
    var data: DataType { get }
}

extension ObservableService {
    
    mutating func addObserver<T: ServiceObserver>(_ observer: T) {
        self.observers.insert(Weak(value: observer))
    }
    
    func updateObservers(state: ServiceDataState) {
        observers.forEach { observer in
            observer.value?.dataNeedsToBeUpdated(key: self.dataKey, state: state)
        }
    }
}

enum DataKey {
    case events
    case discoveryFilters
}

class ServiceObserver: Identifiable {
    var id = UUID()
    
    func dataNeedsToBeUpdated(key: DataKey, state: ServiceDataState) {
        fatalError()
    }
}

class EventService: ServiceObserver, ObservableService {
    private unowned var filterService: DiscoveryFiltersService
    var observers: Set<Weak<ServiceObserver>> = []
        
    var dataKey: DataKey { return .events }
    
    typealias DataType = [Event]
    @Published var state: ServiceDataState = .none

    var filteredData: [Event] = []
    var data : [Event] = []

    init(filterService: DiscoveryFiltersService) {
        self.filterService = filterService
        super.init()
        self.filterService.addObserver(self)
    }
    
    override func dataNeedsToBeUpdated(key: DataKey, state: ServiceDataState) {
        switch key {
        case .discoveryFilters:
            self.updateFilteredData()
            self.updateObservers(state: .successed)
        default: ()
        }
    }
    
    private func updateFilteredData() {
        self.filteredData = self.data.filter { event in
            self.eventContainsSelectedDate(event, date: self.filterService.data.date)
            && event.categories.contains {
                guard !self.filterService.data.categories.isEmpty else { return true }
                return self.filterService.data.categories.contains($0) 
            }
            && event.audiences.contains {
                guard !self.filterService.data.audiences.isEmpty else { return true }
                return self.filterService.data.audiences.contains($0)
            }
        }
    }
    
    private func eventContainsSelectedDate(_ event: Event, date: Date?) -> Bool {
        guard let date else { return true }
        return event.occurences.contains(where: { $0.isSameDay(date) })
    }
    
    func fetchEvents(params: [URLQueryItem]) {
        Task {
            self.updateObservers(state: .loading)
            self.data = (await self.fetchEvents())?.compactMap({ Event(eventEntity: $0) }) ?? []
            self.updateFilteredData()
            self.updateObservers(state: .successed)
        }
    }
    
    private func fetchEvents() async -> [EventEntity]? {
                do {
                    let result: Result<[EventEntity], Error> = try await Agent().request(
                        endPoint: .whatToDoInParis,
                        method: .get
                    )
                    switch result {
                    case .success(let events):
                        return events
                    case .failure(let error):
                        print(error.localizedDescription)
                        return nil
                    }
                }
                catch let error {
                    print(error.localizedDescription)
                    return nil
                }
    }
}
