import SwiftUI
import Paname_Core

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
    
    var titleColor: PColor {
        switch self {
        case .bookable:
             return .white
        case .notBookable:
            return .accentColor
        }
    }
    
    var bgColor: PColor {
        switch self {
        case .bookable:
            return .accentColor
        case .notBookable:
            return .white
        }
    }
    
    var borderColor: PColor {
        switch self {
        case .bookable,
             .notBookable:
            return .accentColor
        }
    }
    
    var borderSize: CGFloat {
        switch self {
        case .bookable:
            return 0
        case .notBookable:
            return 2
        }
    }
}
