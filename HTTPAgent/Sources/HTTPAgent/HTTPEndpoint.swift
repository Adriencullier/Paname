import Foundation

public protocol HTTPEndpoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var header: [String: String]? { get }
}
