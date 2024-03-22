import SwiftUI

public enum PColor {
    case accentColor
    case black
    case white
    
    public var color: Color {
        switch self {
        case .black:
            return Color(red: 0.220,
                         green: 0.259,
                         blue: 0.188)
        case .white:
            return Color(red: 0.980,
                         green: 0.980,
                         blue: 0.980)
        case .accentColor:
            return Color(red: 0.286,
                         green: 0.522,
                         blue: 0.518)
        }
    }
}
