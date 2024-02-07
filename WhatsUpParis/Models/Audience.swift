import Foundation

struct EventAudience {
    var audiences: [Audience]
    var description: String
    
    init(audiences: [Audience],
         ageMin: Int? = nil,
         ageMax: Int? = nil) {
        self.audiences = audiences
        if audiences.isEmpty {
            self.description = "Tout public"
        } else if let ageMin, let ageMax {
            self.description = "De \(ageMin) à \(ageMax) ans"
        } else if let ageMin, ageMax == nil {
            self.description = "A partir de \(ageMin) ans"
        } else if let ageMax, ageMin == nil {
            self.description = "Jusqu'à \(ageMax) ans"
        } else if audiences == [.adults] {
            self.description = "Public adulte"
        } else if audiences == [.adolescent] {
            self.description = "Public adolescent"
        } else if audiences == [.adolescent, .adults] {
            self.description = "Public adolescent et adulte"
        } else if audiences == [.children, .adolescent] {
            self.description = "Public enfant et adolescent"
        } else {
            self.description = "Tout public"
        }
    }
}

enum Audience: CaseIterable, Identifiable {
    /// From 0 to 3
    case babies
    /// From 4 to 9
    case children
    /// From 10 to 17
    case adolescent
    /// From 18 to 100
    case adults
    
    var id: UUID {
        return UUID()
    }
    
    var description: String {
        switch self {
        case .babies:
            return "0 - 3 ans"
        case .children:
            return "4 - 9 ans"
        case .adolescent:
            return "10 - 17 ans"
        case .adults:
            return "+18 ans"
        }
    }
    
    static func getAudiences(from ageMin: Int?, and ageMax: Int?) -> EventAudience {
        if let ageMin, ageMax == nil {
            switch ageMin {
            case let age where Array(0...3).contains(age):
                return EventAudience(audiences: [])
            case let age where Array(4...9).contains(age):
                return EventAudience(audiences: [.children, .adolescent, .adults],
                                     ageMin: ageMin,
                                     ageMax: ageMax)
            case let age where Array(10...17).contains(age):
                return EventAudience(audiences: [.adolescent, .adults],
                                     ageMin: ageMin,
                                     ageMax: ageMax)
            case let age where Array(18...100).contains(age):
                return EventAudience(audiences: [.adults],
                                     ageMin: ageMin,
                                     ageMax: ageMax)
            default: 
                return EventAudience(audiences: [])
            }
        } else if let ageMax, ageMin == nil {
            switch ageMax {
            case let age where Array(0...3).contains(age):
                return EventAudience(audiences: [.babies],
                                     ageMin: ageMin,
                                     ageMax: ageMax)
            case let age where Array(4...9).contains(age):
                return EventAudience(audiences: [.babies, .children],
                                     ageMin: ageMin,
                                     ageMax: ageMax)
            case let age where Array(10...17).contains(age):
                return EventAudience(audiences: [.babies, .children, .adolescent],
                                     ageMin: ageMin,
                                     ageMax: ageMax)
            case let age where Array(18...100).contains(age):
                return EventAudience(audiences: [])
            default:
                return EventAudience(audiences: [])
            }
        } else if let ageMin,
                  let ageMax {
            switch ageMin {
            case let age where Array(0...3).contains(age):
                switch ageMax {
                case let age where Array(0...3).contains(age):
                    return EventAudience(audiences: [.babies],
                                         ageMin: ageMin,
                                         ageMax: ageMax)
                case let age where Array(4...9).contains(age):
                    return EventAudience(audiences: [.babies, .children],
                                         ageMin: ageMin,
                                         ageMax: ageMax)
                case let age where Array(10...17).contains(age):
                    return EventAudience(audiences: [.babies, .children, .adolescent],
                                         ageMin: ageMin,
                                         ageMax: ageMax)
                case let age where Array(18...100).contains(age):
                    return EventAudience(audiences: [])
                default:
                    return EventAudience(audiences: [])
                }
            case let age where Array(4...9).contains(age):
                switch ageMax {
                case let age where Array(4...9).contains(age):
                    return EventAudience(audiences: [.children],
                                         ageMin: ageMin,
                                         ageMax: ageMax)
                case let age where Array(10...17).contains(age):
                    return EventAudience(audiences: [.children, .adolescent],
                                         ageMin: ageMin,
                                         ageMax: ageMax)
                case let age where Array(18...100).contains(age):
                    return EventAudience(audiences: [.children, .adolescent, .adults],
                                         ageMin: ageMin,
                                         ageMax: ageMax)
                default:
                    return EventAudience(audiences: [])
                }
            case let age where Array(10...17).contains(age):
                switch ageMax {
                case let age where Array(10...17).contains(age):
                    return EventAudience(audiences: [.adolescent],
                                         ageMin: ageMin,
                                         ageMax: ageMax)
                case let age where Array(18...100).contains(age):
                    return EventAudience(audiences: [.adolescent, .adults],
                                         ageMin: ageMin,
                                         ageMax: ageMax)
                default:
                    return EventAudience(audiences: [])
                }
            case let age where Array(18...100).contains(age):
                switch ageMax {
                case let age where Array(18...100).contains(age):
                    return EventAudience(audiences: [.adults],
                                         ageMin: ageMin,
                                         ageMax: ageMax)
                default:
                    return EventAudience(audiences: [])
                }
            default: 
                return EventAudience(audiences: [])
            }
        } else {
            return EventAudience(audiences: [])
        }
    }
}
