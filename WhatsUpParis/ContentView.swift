import SwiftUI
import WebKit



class DiscoveryFilters {
    var date: Date
    var categories: [Category]
    
    init(date: Date = Date(), categories: [Category] = []) {
        self.date = date
        self.categories = categories
    }
    
    var params: [URLQueryItem] {
        var params: [URLQueryItem] = []
        if !self.categories.isEmpty {
            let value: String = categories
                .flatMap({ $0.tags })
                .flatMap({ $0.rawValue })
                .map({ "\'" + $0 + "\'" })
                .joined(separator: "or")
            params.append(URLQueryItem(name: "where", value: value + " in tags"))
        }
        params.append(URLQueryItem(name: "where", value: "search(occurrences,\'%\(self.date.toString(.yearMonth))%\')"))
        return params
    }
}

final class DiscoveryViewModel: ObservableObject {
    private let eventService: EventService
    
    @Published var events: [Event] = []
    @Published var selectedItem: Int = 1
    @Published var discoveryFilters: DiscoveryFilters = DiscoveryFilters() {
        didSet {
            DispatchQueue.main.async {
                self.fetchEvents(params: self.discoveryFilters.params)
            }
        }
    }
    
    @MainActor
    init(eventService: EventService) {
        self.eventService = eventService
        self.fetchEvents(params: self.discoveryFilters.params)
    }
    
    @MainActor
    func fetchEvents(params: [URLQueryItem]) {
        Task {
            self.events = (await self.eventService.fetchEvents(params: params) ?? []).compactMap({ Event(eventEntity: $0) })
        }
    }
}

struct ContentView: ShipViewProtocol {
    var router: ShipRouter<DiscoveryRoute>
    
    @ObservedObject private var viewModel: DiscoveryViewModel
    @State private var calendarId: UUID = UUID()
    
    init(viewModel: DiscoveryViewModel, router: ShipRouter<DiscoveryRoute>) {
        self.viewModel = viewModel
        self.router = router
    }
    
    var categoriesFilterButton: some View {
        VStack {
            if self.viewModel.discoveryFilters.categories.count > 0 {
                HStack(spacing: 2) {
                    ForEach(self.viewModel.discoveryFilters.categories, id: \.self) { cat in
                        Image(systemName: cat.icon)
                            .foregroundStyle(cat.color)
//                            .padding(4)
                    }
                }
            } else {
                HStack {
                    Text("Catégories")
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .foregroundStyle(Color("Wblack"))
                }
                .padding(.vertical, 2)
            }
        }
        .frame(minWidth: 60)
        .padding(8)
            .background(Color("Wwhite"))
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .overlay(content: {
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color("Wblack").opacity(0.4), lineWidth: 1)
            })
            .onTapGesture {
                self.router.navigate(to: .categoriesView(categories: self.$viewModel.discoveryFilters.categories,
                                                         onValidatePressed: self.router.dismiss))
            }
            
//            .padding(.leading, 96)
//            .padding(.bottom, 30)
//        }
        
    }
    
    var body: some View {
            ZStack {
                GeometryReader { proxy in
                    TabView {
                        ForEach(self.viewModel.events, id: \.id) { event in
                            VStack(spacing: 8) {
                                EventCard(event: event) { url in
                                    self.router.navigate(to: DiscoveryRoute.reservationWebView(url: url))
                                }
                                Spacer()
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.height - 250)
                            .background(Color("Wwhite"))
                            
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color("Wblack").opacity(0.4), lineWidth: 1)
                            )
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .rotationEffect(.degrees(-90))
                            .onAppear {
                                if let lastEvent = self.viewModel.events.last,
                                   lastEvent.id == event.id {
                                }
                                
                            }
                        }
                        
                    }
                    .edgesIgnoringSafeArea(.all)
                    .id(self.calendarId)
                    .frame(width: proxy.size.height, height: proxy.size.width)
                    .rotationEffect(.degrees(90), anchor: .topLeading)
                    .offset(x: proxy.size.width)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                VStack {
                ScrollView(.horizontal) {
                    HStack {
                            categoriesFilterButton
                            datePicker
                        }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 2)
                    .scrollIndicators(.hidden)
                }
                .padding(.bottom, 8)
                .background {
                    Color("Wwhite")
                }
                    Spacer()
                }
            }
            .background {
                Color("Wwhite")
                    .ignoresSafeArea()
            }
    }
    
    
    
    var datePicker: some View {
        HStack {
            Text(self.viewModel.discoveryFilters.date.toString(.weekdayMonth))
                .foregroundStyle(Color("Wblack"))
                .font(.system(size: 14, weight: .regular, design: .default))
                .padding(.horizontal, 8)
                .padding(.vertical, 10)
                .background(Color("Wwhite"))
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color("Wblack").opacity(0.4), lineWidth: 1)
                })
                .overlay {
                    DatePicker(
                        "",
                        selection: self.$viewModel.discoveryFilters.date,
                        in: Date()...,
                        displayedComponents: .date
                    )
                    .id(calendarId)
                    .onChange(of: self.viewModel.discoveryFilters.categories) { _, _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            calendarId = UUID()
                        }
                    }
                    .onChange(of: self.viewModel.discoveryFilters.date) { _, _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            calendarId = UUID()
                        }
                    }
                    .blendMode(.destinationOver)
                }
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

struct EventCard: View {
    var event: Event
    var onBookingButtonPressed: (_ url: URL) -> Void
    
    var body: some View {
        VStack {
            coverImage
                .clipShape(RoundedRectangle(cornerRadius: 8))
            content
        }
    }
    
    var coverImage: some View {
        CacheAsyncImage(url: event.coverUrl) {
            $0.image.resizable().scaledToFit().clipped()
        }
    }
    
    var locationView: some View {
        PText(text: event.address.uppercased())
            .font(.system(size: 12, weight: .thin))
            .lineLimit(2)
    }
    
    var descriptionView: some View {
        VStack {
            Text(event.leadText)
                .foregroundStyle(Color("Wblack"))
                .font(.system(.body, design: .default, weight: .light))
            Spacer()
        }
    }
    
    var dateDescriptionView: some View {
        Text(event.dateDescription)
            .foregroundStyle(Color("Wblack"))
            .font(.system(size: 12, weight: .thin, design: .default))
            .lineLimit(3)
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 2) {
            PText(text: event.title)
                .font(.title)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
            locationView
            dateDescriptionView
            ScrollView(.horizontal) {
                HStack {
                    ForEach(self.event.categories, id: \.id) { category in
                        CategoryView(category: category)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.top, 8)
            descriptionView
                .padding(.vertical, 8)
            Spacer()
            if let urlStr = self.event.accessUrlStr,
               let url = URL(string: urlStr) {
                reservationButton(uiMode: .bookable(url: url))
            } else {
                reservationButton(uiMode: .notBookable)
            }
            
        }
    }
    
    func reservationButton(uiMode: ReservationButtonUIMode) -> some View {
        HStack {
            Spacer()
            Text(uiMode.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(uiMode.titleColor)
                .padding(.vertical, 12)
            Spacer()
        }
        .background(content: {
            uiMode.bgColor
        })
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(uiMode.borderColor, lineWidth: uiMode.borderSize)
        }
        .onTapGesture(perform: {
            if let url = uiMode.url {
                self.onBookingButtonPressed(url)
            }
        })
    }
}

enum ReservationButtonUIMode {
    case bookable(url: URL)
    case notBookable
    
    var title: String {
        switch self {
        case .bookable:
            "Réserver"
        case .notBookable:
            "Non réservable"
        }
    }
    
    var url: URL? {
        switch self {
        case .bookable(let url):
           return url
        case .notBookable:
            return nil
        }
    }
    
    var titleColor: Color {
        switch self {
        case .bookable:
            Color("Wwhite")
            
        case .notBookable:
            Color("AccentColor")
        }
    }
    
    var bgColor: Color {
        switch self {
        case .bookable:
            Color("AccentColor")
        case .notBookable:
            Color("Wwhite")
        }
    }
    
    var borderColor: Color {
        switch self {
        case .bookable,
             .notBookable:
            Color("AccentColor")
        }
    }
    
    var borderSize: CGFloat {
        switch self {
        case .bookable:
            0
        case .notBookable:
            2
        }
    }
}

extension AsyncImagePhase {
    var image: Image {
        switch self {
        case .empty, .failure:
            Image("placeholder")
        case .success(let image):
            image
        @unknown default:
            Image("placeholder")
        }
    }
}

struct PText: View {
    var text: String
    var textColor: Color
    
    init(text: String, textColor: Color = Color("Wblack")) {
        self.text = text
        self.textColor = textColor
    }
    
    var body: some View {
        Text(self.text)
            .fontWeight(.medium)
            .foregroundStyle(textColor)
    }
}

struct CategoryView: View {
    @State private var isPressed: Bool
    var category: Category
    var categoryMode: CategoryMode
    
    init(category: Category, categoryMode: CategoryMode = .normal) {
        self.category = category
        self.categoryMode = categoryMode
        
        switch categoryMode {
        case .clickable(let isPressed, _):
            self.isPressed = isPressed
        case .normal:
            self.isPressed = false
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: self.category.icon)
                .foregroundStyle(self.category.color)
            Text(self.category.title.lowercased())
                .font(.system(.footnote, design: .serif, weight: .light))
                .foregroundStyle(self.category.color)
                .fixedSize()
        }
        .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
        .background(content: {
            self.category.color.opacity(0.1)
        })
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(self.category.color, lineWidth: self.isPressed ? 4 : 0)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onTapGesture {
            switch self.categoryMode {
            case .normal: ()
            case .clickable(_, let onPressed):
                self.isPressed.toggle()
                onPressed(self.isPressed)
            }
        }
    }
}

enum CategoryMode {
    case clickable(isAlreadyPressed: Bool, onPressed: (Bool) -> Void)
    case normal
}

