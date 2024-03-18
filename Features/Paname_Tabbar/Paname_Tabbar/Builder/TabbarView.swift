import SwiftUI

/// Tabbar view
public struct TabbarView: View {
    // MARK: - Properties
    public var viewModel: TabbarViewModel
    
    // MARK: - Init
    public init(viewModel: TabbarViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body's view
    public var body: some View {
        TabView(selection: .constant(1)) {
            ForEach(self.viewModel.tabItems, id: \.id) { item in
                item.view
                    .tabItem {
                        Label {
                            Text(item.title)
                        } icon: {
                            Image(systemName: item.icon)
                        }
                    }
            }
        }
    }
}

