import SwiftUI

struct BaseNavView<Content: View, ViewModel: NavViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    var contentView: Content
    
    init(viewModel: ViewModel, contentView: () -> Content) {
        let view = contentView()
        self.contentView = view
        self.viewModel = viewModel
    }
    
    var body: some View {
        contentView
            .setupRoutes(self.$viewModel.route)
    }
}

fileprivate extension View {
    func setupRoutes<R: Route>(_ route: Binding<R>?) -> some View {
        Group {
            if let route {
                self.navigate(to: route)
            } else {
                self
            }
        }
    }
    
    func navigate<R: Route>(to route: Binding<R>, onDismiss: (() -> Void)? = nil) -> AnyView {
        switch route.wrappedValue.navigationMode {
        case .modal:
            AnyView(
                self.sheet(isPresented: .constant(true),
                           onDismiss: onDismiss,
                           content: {
                               route.wrappedValue.destination
                           })
            )
        case .push:
            AnyView(
                navigationDestination(isPresented: .constant(true)) {
                    route.wrappedValue.destination
                }
            )
        case .none:
            AnyView(self)
        }
    }
}
