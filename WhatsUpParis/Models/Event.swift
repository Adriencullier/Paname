import Foundation

/// Event object
struct Event {
<<<<<<< HEAD
    var id: String?
=======
    var id: String
>>>>>>> parent of 78ecde8 (wip: remove custom navigation)
    var title: String
    var leadText: String
    var categories: [Category] = []
    var accessibility: [Accessibility] = []
    var address: String
    var coverUrl: URL
    var accessUrlStr: String?
    var dateDescription: String
    var occurences: [Date]
    var audiences: [Audience] = []
    var audienceDescription: String? = ""
    
    init?(eventEntity: EventEntity) {
        guard let id = eventEntity.id else {
            print("⛔️ No id")
            return nil
        }
        guard let title = eventEntity.title else {
            print("⛔️ No title")
            return nil
        }
        guard let leadText = eventEntity.leadText else {
            print("⛔️ No lead text")
            return nil
        }
        guard let tags = eventEntity.tags else {
            print("⛔️ No tags")
            return nil
        }
        guard !Category.getCategories(from: tags.compactMap({ EventTag(rawValue: $0.formattedTag) })).isEmpty else {
            print("⛔️ No founded categories for \(tags)")
            return nil
        }
        guard let addressName = eventEntity.addressName else {
            print("⛔️ No address")
            return nil
        }
        guard let zipCode = eventEntity.zipCode else {
            print("⛔️ No zipcode")
            return nil
        }
        guard let coverUrlStr = eventEntity.coverUrlStr,
              let coverUrl = URL(string: coverUrlStr) else {
            print("⛔️ No coverUrlStr")
            return nil
        }
        guard let dateDescription = eventEntity.dateDescription else {
            print("⛔️ No date description")
            return nil
        }
        guard let dateStart = eventEntity.dateStart else {
            print("⛔️ No dateStart")
            return nil
        }
        self.id = id
        self.title = title
        self.leadText = leadText
        let eventTags = tags.compactMap({ EventTag(rawValue: $0.formattedTag) })
        self.categories = Category.getCategories(from: eventTags)
        if let priceType = eventEntity.priceType, PriceType(rawValue: priceType) == .gratuit {
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
        self.occurences = [dateStart.toDate(format: .dateTimeZone)!.toDate(.dateTime)]
        
        if let occurrences = eventEntity.occurrences {
            self.occurences += occurrences.components(separatedBy: CharacterSet(["_", ";"])).compactMap({ dateStr in
                dateStr.toDate(format: .dateTimeZone)?.toDate(.dateTime)
            })
        }
        
        
        
        if let audience = eventEntity.audience {
            let eventAudience = Event.parseAudience(audience)
            self.audiences = eventAudience.audiences
            self.audienceDescription = eventAudience.description
        }
    }
    
    private static func parseAudience(_ audience: String) -> EventAudience {
        if audience.contains("Public adultes") {
            return EventAudience(audiences: [.adults])
        } else if audience.contains("Public adolescents adultes") {
            return EventAudience(audiences: [.adolescent, .adults])
        } else if audience.contains("Public enfants adolescents") {
            return EventAudience(audiences: [.children, .adolescent])
        } else if audience == "Tout public." {
            return EventAudience(audiences: [])
        } else if audience.contains("A partir de")
                  && !audience.contains("Jusqu'à") {
            var splitted = audience.components(separatedBy: CharacterSet.decimalDigits.inverted)
                .filter({ $0 != "" })
            guard let ageMin = splitted.first else {
                return EventAudience(audiences: [])
            }
            return Audience.getAudiences(from: Int(ageMin), and: nil)
        } else if audience.contains("A partir de")
               && audience.contains("Jusqu'à") {
            var splitted = audience.components(separatedBy: CharacterSet.decimalDigits.inverted)
                .filter({ $0 != "" })
            guard splitted.count == 2,
                  let ageMin = splitted.first,
                  let ageMax = splitted.last else {
                return EventAudience(audiences: [])
            }
            return Audience.getAudiences(from: Int(ageMin), and: Int(ageMax))
        } else {
            return EventAudience(audiences: [])
        }
    }
}
