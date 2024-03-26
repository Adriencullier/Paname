import SwiftUI

public protocol BuilderProtocol {
    associatedtype Content: View
    associatedtype Payload

    var serviceContainer: ServiceContainer? { get }
    
    func createModule(payload: Payload) -> Content
}

public extension BuilderProtocol {
    var serviceContainer: ServiceContainer? {
            return nil
    }    
}
