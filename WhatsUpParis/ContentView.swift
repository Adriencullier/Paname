import SwiftUI
import WebKit

//where=search(occurrences,%27%2023-12-15%%27)
struct Event {
    var id: String
    var title: String
    var leadText: String
    var tags: [EventTag] = []
    var accessibility: [Accessibility] = []
    var zipCode: String
    var coverUrlStr: String
    var accessUrlStr: String?
    var dateDescription: String
    
    init?(eventEntity: EventEntity) {
        guard let title = eventEntity.title,
              let leadText = eventEntity.leadText,
              let tags = eventEntity.tags,
              let zipCode = eventEntity.zipCode,
              let coverUrlStr = eventEntity.coverUrlStr,
              let dateDescription = eventEntity.dateDescription else { return nil }
        self.id = eventEntity.id
        self.title = title
        self.leadText = leadText
        if let pmr = eventEntity.pmr {
            self.accessibility.append(.pmr)
        }
        if let blind = eventEntity.blind {
            self.accessibility.append(.blind)
        }
        if let deaf = eventEntity.deaf {
            self.accessibility.append(.deaf)
        }
        self.tags = tags.map({ EventTag(rawValue: $0
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "-", with: " ")) })
            
        self.zipCode = zipCode
        self.coverUrlStr = coverUrlStr
        self.accessUrlStr = eventEntity.accessUrlStr
        self.dateDescription = dateDescription.replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression)
    }
}
final class ViewModel: ObservableObject {
    private let eventService: EventService
    
    @Published var events: [Event] = []
    @Published var selectedDate: Date = Date() {
        didSet {
            DispatchQueue.main.async {
                self.fetchEvents()
            }
        }
    }
    
    var params: [URLQueryItem] {
        [URLQueryItem(name: "where", value: "search(occurrences,\'%\(self.selectedDate.toString(.yearMonth))%\')")]
    }
    
    @MainActor
    init(eventService: EventService) {
        self.eventService = eventService
        self.fetchEvents()
    }
    
    @MainActor
    func fetchEvents() {
        Task {
            self.events = (await self.eventService.fetchEvents(params: self.params) ?? []).compactMap({ Event(eventEntity: $0) })
        }
    }
}

struct ContentView: ShipViewProtocol {
    var router: ShipRouter<DiscoveryRoute>
    
    @ObservedObject private var viewModel: ViewModel
    @State private var calendarId: UUID = UUID()
    @State private var tabViewId: UUID = UUID()
    
    init(viewModel: ViewModel, router: ShipRouter<DiscoveryRoute>) {
        self.viewModel = viewModel
        self.router = router
    }
    
    
    
    var body: some View {
        VStack(alignment: .center) {
            DatePicker("", 
                       selection: self.$viewModel.selectedDate,
                       in: Date()...,
                       displayedComponents: .date)
            .id(calendarId)
            .onChange(of: self.viewModel.selectedDate) { _, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    calendarId = UUID()
//                    tabViewId = UUID()
                }
            }
            .datePickerStyle(.automatic)
            .fixedSize()
            .colorMultiply(Color("Wwhite"))
            
            .padding(.leading, -8)
            GeometryReader { proxy in
                TabView {
                    ForEach(self.viewModel.events, id: \.id) { event in
                            VStack(alignment: .leading, spacing: 8)  {
                                    CacheAsyncImage(url: URL(string: event.coverUrlStr)!) { phase in
                                        self.getImage(from: phase)
                                            .resizable()
                                            .scaledToFit()
                                            .clipped()

                                    }
                                VStack(alignment: .leading) {
                                    Text(event.title)
                                        .foregroundStyle(Color("Wwhite"))
                                        .multilineTextAlignment(.leading)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack(spacing: 4) {
                                            ForEach(event.tags, id: \.id) { tag in
                                                HStack(spacing: 0) {
                                                    Image(systemName: tag.icon)
                                                    Text(tag.title)
                                                        .fixedSize()
                                                }
                                                .foregroundStyle(Color("Wblack"))
                                                .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                                                .background(content: {
                                                    Color("Wwhite").opacity(0.8)
                                                })
                                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                            }
                                        }
                                        Text(event.zipCode)
                                            .foregroundStyle(Color("Wwhite"))
                                            Text(event.leadText)
                                                .multilineTextAlignment(.leading)
                                                .fontWeight(.light)
                                                .foregroundStyle(Color("Wwhite"))
                                        Text(event.dateDescription)
                                            .multilineTextAlignment(.leading)
                                            .fontWeight(.light)
                                            .foregroundStyle(Color("Wwhite"))
                                        if !event.accessibility.isEmpty {
                                            HStack {
                                                Text("Accessibility:")
                                                    .multilineTextAlignment(.leading)
                                                    .fontWeight(.regular)
                                                    .foregroundStyle(Color("Wwhite"))
                                                HStack {
                                                    ForEach(event.accessibility, id: \.self) { accessibility in
                                                        Image(systemName: accessibility.icon)
                                                            .foregroundStyle(Color("Wwhite"))
                                                    }
                                                }
                                            }
                                        }
                                        Spacer()
                                        if let urlStr = event.accessUrlStr,
                                           let url = URL(string: urlStr) {
                                            Button(action: {
                                                self.router.navigate(to: DiscoveryRoute.reservationWebView(url: url))

                                            }, label: {
                                                HStack {
                                                    Spacer()
                                                    Text("Réserver")
                                                    Spacer()
                                                }
                                                    .foregroundStyle(Color("Wblack"))
                                                    .padding(EdgeInsets(top: 6, leading: 4, bottom: 6, trailing: 4))
                                                    .background(content: {
                                                        Color("Wwhite").opacity(0.8)
                                                    })
                                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                            })
                                        } else {
                                            HStack {
                                                Spacer()
                                                Text("Non réservable")
                                                Spacer()
                                            }
                                                .foregroundStyle(Color("Wblack"))
                                                .padding(EdgeInsets(top: 6, leading: 4, bottom: 6, trailing: 4))
                                                .background(content: {
                                                    Color("Wwhite").opacity(0.4)
                                                })
                                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                        }
                                        
                                    }

                                }
                                .padding()
                                                        .onAppear {
                                    if let lastEvent = self.viewModel.events.last,
                                       lastEvent.id == event.id {
                                        self.viewModel.fetchEvents()
                                    }
                                    
                                }
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.height - 200)
                            .background(Color.black.opacity(0.3))
                            .clipShape(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                            )
                            .shadow(radius: 20)
                        
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .rotationEffect(.degrees(-90))
                }
                .id(self.calendarId)
                .frame(width: proxy.size.height, height: proxy.size.width)
                .rotationEffect(.degrees(90), anchor: .topLeading)
                .offset(x: proxy.size.width)

            }
                    }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .background(
                ZStack {
                    Image("background1")
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 10)
                        .ignoresSafeArea()
                    Image("background2")
                        .resizable()
                        .scaledToFill()
                        .opacity(0.8)
                        .ignoresSafeArea()
                    
                }
            )
        
 }
    
    private func getImage(from phase: AsyncImagePhase) -> Image {
        switch phase {
        case .empty, .failure:
            Image(systemName: "heart")
        case .success(let image):
            image
        @unknown default:
            Image(systemName: "heart")
        }
    }
}

struct CacheAsyncImage<Content>: View where Content: View{
    
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ){
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View{
        if let cached = ImageCache[url]{
            let _ = print("cached: \(url.absoluteString)")
            content(.success(cached))
        }else{
            let _ = print("request: \(url.absoluteString)")
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ){phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    func cacheAndRender(phase: AsyncImagePhase) -> some View{
        if case .success (let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}
fileprivate class ImageCache{
    static private var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image?{
        get{
            ImageCache.cache[url]
        }
        set{
            ImageCache.cache[url] = newValue
        }
    }
}

struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}


