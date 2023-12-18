import Foundation

struct EventEntity: Codable {
    var id : String
    var title: String?
    var leadText: String?
    var tags: [String]?
    var zipCode: String?
    var coverUrlStr: String?
    var accessUrlStr: String?
    var dateDescription: String?
    var pmr: Int?
    var blind: Int?
    var deaf: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case leadText = "lead_text"
        case tags = "tags"
        case zipCode = "address_zipcode"
        case coverUrlStr = "cover_url"
        case accessUrlStr = "access_link"
        case dateDescription = "date_description"
        case pmr = "pmr"
        case blind = "blind"
        case deaf = "deaf"
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

actor EventService {

    var totalCount: Int = 0
    var page: Int = 1
    var elementPerPage = 20
    var paginator = Paginator()
    var defaultParams: [URLQueryItem] {
        [ URLQueryItem(name: "limit", value: String(self.paginator.hitsPerPage)),
          URLQueryItem(name: "offset", value: String(self.paginator.page))]
    }
    
    func fetchEvents(params: [URLQueryItem]) async -> [EventEntity]? {
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
