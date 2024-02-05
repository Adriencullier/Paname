import Foundation

/// Event object
struct Event: Equatable {
    var id: String?
    var title: String
    var leadText: String
    var categories: [Category] = []
    var accessibility: [Accessibility] = []
    var address: String
    var coverUrl: URL
    var accessUrlStr: String?
    var dateDescription: String
    var occurences: [Date]
    
    init?(eventEntity: EventEntity) {
        guard let id = eventEntity.id,
              let title = eventEntity.title,
              let leadText = eventEntity.leadText,
              let tags = eventEntity.tags,
              !Category.getCategories(from: tags.compactMap({ EventTag(rawValue: $0.formattedTag) })).isEmpty,
              let addressName = eventEntity.addressName,
              let zipCode = eventEntity.zipCode,
              let coverUrlStr = eventEntity.coverUrlStr,
              let coverUrl = URL(string: coverUrlStr),
              let dateDescription = eventEntity.dateDescription,
              let priceType = eventEntity.priceType,
              let occurences = eventEntity.occurrences else { return nil  }
        self.id = id
        self.title = title
        self.leadText = leadText
        let eventTags = tags.compactMap({ EventTag(rawValue: $0.formattedTag) })
        self.categories = Category.getCategories(from: eventTags)
        if PriceType(rawValue: priceType) == .gratuit {
            categories.append(.gratuit)
        }
        self.address = addressName + " " + "(" + zipCode + ")"
        self.coverUrl = coverUrl
        self.accessUrlStr = eventEntity.accessUrlStr
        self.dateDescription = dateDescription.formattedDateDescription
        if eventEntity.pmr.exists {
            self.accessibility.append(.pmr)
        }
        if eventEntity.blind.exists {
            self.accessibility.append(.blind)
        }
        if eventEntity.deaf.exists {
            self.accessibility.append(.deaf)
        }
        self.occurences = occurences.components(separatedBy: CharacterSet(["_", ";"])).compactMap({ dateStr in
            dateStr.toDate(format: .dateTimeZone)?.toDate(.dateTime)
        })
    }
}
