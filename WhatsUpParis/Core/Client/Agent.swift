import Foundation

/// Paginator
struct Paginator {
    // MARK: - Properties
    let hitsPerPage: Int
    
    private var maxPage: Int?
    private(set) var page: Int = 0
    
    var hasNextPage: Bool = true
    
    // MARK: - Init
    init(hitsPerPage: Int = 100) {
        self.hitsPerPage = hitsPerPage
    }
    // MARK: - Mutating functions
    /// Aims to increment page
    mutating func incrementPage() {
        self.page += 1
    }

    /// Aims to set maxPage
    mutating func setMaxPage(_ nbResults: Int) {
        self.maxPage = Int(Double(nbResults / self.hitsPerPage).rounded(.up))
    }
}

/// Aims to list all the possible HTTP methods
enum HTTPMethod {
    /// get
    case get
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}

enum Endpoints {
    case whatToDoInParis
    
    var fullPath: String {
        switch self {
        case .whatToDoInParis:
            return "https://opendata.paris.fr/api/explore/v2.1/catalog/datasets/que-faire-a-paris-/exports/json"
        }
    }
    
    /// EndPoint url Request Headers
    var urlRequestHeaders: [String: String] {
        switch self {
        case    .whatToDoInParis:
            return [
                "Content-Type": "charset=utf-8",
                "Accept-Encoding": "br"
            ]
        }
    }
}

class Agent {
    let session = URLSession(configuration: URLSessionConfiguration.default)
    // MARK: - Internal functions
    /// Aims to execute http request
    /// - Parameters:
    ///   - endPoint: K.EndPoints
    ///   - method: HTTPMethod
    /// - Returns: Result<T, HTTPError>
    func request<T: Codable>(endPoint: Endpoints,
                             method: HTTPMethod) async throws -> Result<T, Error> {
        let urlRequest = getUrlRequest(for: endPoint, method: method)
        let (data, response) = try await self.session.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            fatalError("Unknow HTTPURLResponse")
        }
//        if httpResponse.statusCode != 401 {
//            self.refreshSessionCount = 0
//        }
        switch httpResponse.statusCode {
        case 200:
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedData)
            } catch let error {
                return .failure(error)
            }
        case 201...400:
//            ilog("❤️ " + response.description, category: .url)
            throw URLError(.badServerResponse)
//        case 401:
//            guard self.refreshSessionCount < self.refreshSessionRetryMax else {
//                self.refreshSessionCount = 0
//                throw HTTPError.error(withMessage: "The refreshSession retries count is exceeded")
//            }
//            #warning("Improve with multiple and simultaneous requests handling")
//            self.refreshSessionCount += 1
//            switch self.sessionService.sessionState {
//            case .login(_, let refreshToken, _, _):
//                self.sessionService.refreshSession(refreshToken: refreshToken)
//                return try await self.request(endPoint: endPoint,
//                                              method: method,
//                                              userSessionIsNeeded: userSessionIsNeeded)
//            case .logout:
//                throw HTTPError.error(withMessage: "User session is needed but session state is logout")
//            }
        case 500:
//            ilog("❤️ " + response.description, category: .url)
            throw URLError(.badServerResponse)
        default:
            throw URLError(.badServerResponse)
        }
    }
    
    // MARK: - Private functions
    /// Aims to get URLRequest
    /// - Parameters:
    ///   - endPoint: K.EndPoints
    ///   - method: HTTPMethod
    /// - Returns: URLRequest
    private func getUrlRequest(for endPoint: Endpoints,
                               method: HTTPMethod) -> URLRequest {
        // Instanciate endPointUrl from endpoint path
        guard let endPointUrl = URL(string: endPoint.fullPath) else {
            fatalError(
                "Failed to create url from path:"
                + String(describing: endPoint.fullPath)
            )
        }
        // Instanciate urlComponents with endPointUrl
        var urlComponents = URLComponents(url: endPointUrl,
                                          resolvingAgainstBaseURL: true)
        var httpBody: Data?
        
        guard let urlForRequest = urlComponents?.url else {
            fatalError("URL With components is not valid")
        }
        // Instanciate an urlRequest with urlForRequest
        
        var urlRequest = URLRequest(url: urlForRequest)
        // Add http method to urlRequest
        urlRequest.httpMethod = method.name
        // If exists, add http body to urlRequest
        if let httpBody = httpBody {
            urlRequest.httpBody = httpBody
        }

        // If exists, add urlRequestHeaders to urlRequest
        if !endPoint.urlRequestHeaders.isEmpty {
            endPoint.urlRequestHeaders.forEach { element in
                urlRequest.addValue(element.key,
                                    forHTTPHeaderField: element.value)
            }
        }
        
        print(
            "URL:"
            + (urlRequest.url?.description ?? "")
            )
        // Return urlRequest
        return urlRequest
    }

}

