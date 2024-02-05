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
    var occurrences: String?

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
    }
}

protocol BaseEntity: Codable {
    associatedtype ResultType: Codable
    
    var results: [ResultType] { get set }
    var nbResults: Int { get set }
}

struct EventsResult: BaseEntity {
    typealias ResultType = EventEntity
    
    var nbResults: Int
    var results: [EventEntity]
    
    enum CodingKeys: String, CodingKey {
        case nbResults = "total_count"
        case results = "results"
    }
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
    var totalCount: Int = 0
    var page: Int = 0
    var elementPerPage = 20
    var paginator = Paginator()
    var defaultParams: [URLQueryItem] {
        [ 
            URLQueryItem(name: "limit", value: String(self.paginator.hitsPerPage)),
            URLQueryItem(name: "offset", value: String(100 * self.paginator.page + 1))
        ]
    }
    
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
        }
    }
    
    private func eventContainsSelectedDate(_ event: Event, date: Date?) -> Bool {
        guard let date else { return true }
        return event.occurences.contains(where: { $0.isSameDay(date) })
    }
    
    func fetchEvents(params: [URLQueryItem]) {
        Task {
            let start = CFAbsoluteTimeGetCurrent()
            self.updateObservers(state: .loading)
            repeat {
                self.data += (await self.fetchEvents(params: params) ?? []).compactMap({ Event(eventEntity: $0) })
                if self.paginator.page == 5 {
                    self.updateFilteredData()
                    self.updateObservers(state: .successed)
                }
            } while (self.paginator.hasNextPage)
            self.updateFilteredData()
            self.updateObservers(state: .successed)
            let diff = CFAbsoluteTimeGetCurrent() - start
            print("Took \(diff) seconds")
        }
    }
    
    private func fetchEvents(params: [URLQueryItem]) async -> [EventEntity]? {
                do {
                    let result: Result<EventsResult, Error> = try await Agent().request(
                        endPoint: .whatToDoInParis,
                        method: .get(params: defaultParams + params)
                    )
                    switch result {
                    case .success(let events):
                        if !events.results.isEmpty {
//                            self.paginator.setMaxPage(events.nbResults)
                            self.paginator.incrementPage()
                        } else {
                            self.paginator.hasNextPage = false
                        }
                        self.totalCount = events.nbResults
                        return events.results
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
