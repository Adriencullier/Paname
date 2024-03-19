import Foundation

protocol BuilderProtocol {
    associatedtype Content = ShipViewProtocol
    func createModule() -> Content
}
