import Foundation

/// HTTP Agent
/// Aims to own API calls logic
public final class HTTPAgent {
    /// Aims to perform API call
    /// - Parameter endpoint: HTTP endpoint
    /// - Returns: Result<T, HTTPError>
    public static func request<T: Decodable>(endpoint: HTTPEndpoint) async -> Result<T, HTTPError> {
        guard let url = URL(string: endpoint.path) else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode(response.statusCode))
            }
        } catch {
            return .failure(.unknown)
        }
    }
    
    /// Aims to load image data
    /// - Parameter urlStr: URL string
    /// - Returns: Result<Data, HTTPError> 
    public static func loadImageData(from urlStr: String) async -> Result<Data, HTTPError> {
        guard let url = URL(string: urlStr) else {
            return .failure(.invalidURL)
        }
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                return .success(data)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode(response.statusCode))
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
