import SwiftUI

public protocol BuilderProtocol {
    associatedtype Content: View
    associatedtype Payload
    associatedtype Container: ServiceContainer
    
    func createModule(payload: Payload) -> Content
}
