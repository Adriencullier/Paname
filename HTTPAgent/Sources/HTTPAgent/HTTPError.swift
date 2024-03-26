import Foundation

/// Aims to list all the HTTP Errors
public enum HTTPError: Error {
    /// URL is not valid
    case invalidURL
    /// Response as HTTPURLResponse doesn't exist
    case noResponse
    /// Failed to decode data
    case decode
    /// 401 status code
    case unauthorized
    /// Unexpected status code
    case unexpectedStatusCode(_ code: Int)
    /// Unknown error
    case unknown
}
