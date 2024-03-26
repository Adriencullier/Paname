import HTTPAgent

public enum DiscoveryEndpoint: HTTPEndpoint {
    case allEvents
    
    public var method: HTTPMethod {
        switch self {
        case .allEvents:
            return .get
        }
    }

    public var path: String {
        switch self {
        case .allEvents:
            return "https://opendata.paris.fr/api/explore/v2.1/catalog/datasets/que-faire-a-paris-/exports/json"
        }
    }
    
    public var header: [String: String]? {
        switch self {
        case .allEvents:
            return ["Content-Type": "charset=utf-8", "Accept-Encoding": "br"]
        }
    }
}
