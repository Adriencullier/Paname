import SwiftUI
import Paname_Core

struct EventCard: View, Identifiable {
    var id: UUID = UUID()
    
    private let viewModel: EventCardViewModel
    public init(viewModel: EventCardViewModel) {
        self.viewModel = viewModel
    }
    public var body: some View {
        VStack {
            coverImage
            content
        }
    }
    
    var coverImage: some View {
        CachedAsyncImage(imageCache: self.viewModel.imageCache, urlStr: self.viewModel.coverUrlStr)
            .scaledToFill()
            .frame(width: 100, height: 100, alignment: .center)
    }
    
    var titleView: some View {
        PText(text: self.viewModel.title,
              font: .title,
              lineLimit: 3)
    }
    
    var locationView: some View {
        PText(text: self.viewModel.address, 
              font: .system(size: 12, weight: .thin),
              lineLimit: 2)
    }
    
    var dateDescriptionView: some View {
        PText(text: self.viewModel.dateDescription,
              font: .system(size: 12, weight: .thin, design: .default),
              lineLimit: 3)
    }
    
    var categoriesScrollView: some View {
        ScrollView(.horizontal) {
            HStack {
//                ForEach(self.viewModel.categories, id: \.id) { category in
//                    CategoryView(category: category)
//                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    var descriptionView: some View {
        VStack {
            PText(text: self.viewModel.leadText,
                  font: .system(.body, design: .default, weight: .light))
            Spacer()
        }
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 2) {
            titleView
            locationView
            dateDescriptionView
            categoriesScrollView
            descriptionView
            Spacer()
            reservationButton(uiMode: self.viewModel.reservationButtonMode)
        }
    }
    
    func reservationButton(uiMode: ReservationButtonUIMode) -> some View {
        Button(action: {
            if let url = uiMode.url {
                self.viewModel.onBookingButtonPressed(url)
            }
        }, label: {
            PText(text: uiMode.title,
                  font: .system(size: 14, weight: .semibold),
                  textColor: uiMode.titleColor)
        }).buttonStyle(PlainRoundedButtonStyle(bgColor: uiMode.bgColor,
                                               borderColor: uiMode.borderColor,
                                               borderSize: uiMode.borderSize))
    }
}
