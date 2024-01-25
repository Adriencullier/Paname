import SwiftUI

enum DiscoveryRoute: ShipRoutesEnumProtocol {
    case reservationWebView(url: URL)
    case categoriesView(categories: Binding<[Category]>, onValidatePressed: () -> Void)
    
    var shipRoute: ShipRoute {
        switch self {
        case .reservationWebView(let url):
            return ShipRoute(navigationType: .push/* .modal(detents: [.large])*/) {
                AnyView(
                    WebView(url: url)
                        .toolbarTitleDisplayMode(.inline)
                        .edgesIgnoringSafeArea(.all)
                )
            }
        case .categoriesView(let categories, let onValidatePressed):
            return ShipRoute(navigationType: .modal(detents: [.medium])) {
                AnyView(CategoriesFilterView(categories: categories,
                                             onValidatePressed: onValidatePressed))
            }
        }
    }
}
