import SwiftUI
import Navigation

public struct DiscoveryView: NavView {
    public typealias ViewModel = DiscoveryViewModel
    public var viewModel: DiscoveryViewModel

    public var content: AnyView {
        AnyView(
            Button(action: {
                self.viewModel.onDetailPressed()
            }, label: {
                Text("Detail")
            })
            .buttonStyle(.borderedProminent)
                .navigationTitle("Discovery View")
        )
    }}
