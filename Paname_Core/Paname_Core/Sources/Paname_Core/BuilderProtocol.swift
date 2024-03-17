import SwiftUI

public protocol BuilderProtocol {
    associatedtype Content: View
    associatedtype Payload
    static func createModule(payload: Payload) -> Content
}
