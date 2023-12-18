import SwiftUI

extension ShipViewProtocol {
    /// Aims to setup all the navigation routes according to the selected route navigation type
    /// - Parameters:
    ///   - selectedRoute: Binding<ShipRouteProtocol>
    ///   - onDismiss: () -> Void
    /// - Returns: some View
    @ViewBuilder func setupNavigation(_ selectedRoute: Binding<ShipRoute>,
                                      onDismiss: (() -> Void)? = nil) -> some View {
        switch selectedRoute.wrappedValue.navigationEvent {
        // Apply a navigationLinkView to the view in order to push it
        case .push:
            ZStack {
                self
                NavigationLink(isActive: selectedRoute.isPresented.projectedValue) {
                    selectedRoute.destinationView.wrappedValue
                } label: { EmptyView() }
            }
        // Apply .sheet modifier in order to present it modally
        case .modal:
            self.sheet(isPresented: selectedRoute.isPresented,
                       onDismiss: onDismiss) {
                selectedRoute.destinationView.wrappedValue
            }
        // Embed the view in DismissContainerView in order to dismiss it
        case .pop:
            DismissContainerView(self)
        // Embed the view in PopToRootContainerView in order to pop to root
        case .popToRoot:
            PopToRootContainerView(
                DismissContainerView(self)
            )
        // Return the view
        case .none:
            self
        }
    }
}
