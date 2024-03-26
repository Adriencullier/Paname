import SwiftUI

/// Aims to have a a vertical paging scroll behavior (like tik tok)
struct PScrollView<Content: View & Identifiable>: View {
    private let contents: [Content]
    
    init(_ contents: [Content]) {
        self.contents = contents
    }
    
    var body: some View {
        GeometryReader { proxy in
            TabView {
                ForEach(self.contents, id: \.id) { content in
                    content
                        .rotationEffect(.degrees(-90))
                        .frame(width: UIScreen.main.bounds.width - 30,
                               height: UIScreen.main.bounds.height - 200)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .rotationEffect(.degrees(90), anchor: .topLeading)
            .frame(width: proxy.size.height, height: proxy.size.width)
            .offset(x: proxy.size.width)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}
