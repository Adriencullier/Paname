import SwiftUI

public protocol NavView: View {
    associatedtype ViewModel: NavViewModel
    var content: AnyView { get }
    var viewModel: ViewModel { get set }
}

public extension NavView {
    var body: some View {
        BaseNavView(viewModel: self.viewModel) {
            self.content
        }
    }
}
