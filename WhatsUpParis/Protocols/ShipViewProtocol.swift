import SwiftUI

protocol ShipViewProtocol: View {
    associatedtype Router = ShipRouterProtocol
    var router: Router { get }
}
