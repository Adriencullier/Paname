import Foundation

enum PriceType: String, Codable {
    case payant
    case gratuit
}

struct EventEntity: Codable {
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

protocol ObservableService {
    associatedtype DataType
    var serviceObserver: (any ServiceObserver)? { get }
    var dataKey: DataKey { get }
    var data: DataType { get }
}

extension ObservableService {
    func updateObservers(state: ServiceDataState) {
        self.serviceObserver?.dataNeedsToBeUpdated(key: self.dataKey, state: state)
    }
}

enum DataKey {
    case events
    case discoveryFilters
}

protocol ServiceObserver: AnyObject {
    func dataNeedsToBeUpdated(key: DataKey, state: ServiceDataState)
}

class EventService: ObservableService {
    weak var serviceObserver: (any ServiceObserver)?
    
    var dataKey: DataKey { return .events }
    
    typealias DataType = [Event]
    @Published var state: ServiceDataState = .none
//    var discoveryFilters: DiscoveryFilters
    var data : [Event] = []
    var totalCount: Int = 0
    var page: Int = 1
    var elementPerPage = 20
    var paginator = Paginator()
    var defaultParams: [URLQueryItem] {
        [ URLQueryItem(name: "limit", value: String(self.paginator.hitsPerPage)),
          URLQueryItem(name: "offset", value: String(self.paginator.page))]
    }
    
    func fetchEvents(params: [URLQueryItem]) {
        Task {
            let start = CFAbsoluteTimeGetCurrent()
            self.updateObservers(state: .loading)
            repeat {
                if self.paginator.page == 1 {
                    self.updateObservers(state: .successed)
                }
                self.data += (await self.fetchEvents(params: params) ?? []).compactMap({ Event(eventEntity: $0) })
            } while (self.paginator.hasNextPage)
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
                        if self.paginator.hasNextPage {
                            self.paginator.setMaxPage(events.nbResults)
                            self.paginator.incrementPage()
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
