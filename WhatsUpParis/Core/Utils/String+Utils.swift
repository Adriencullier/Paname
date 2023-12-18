import Foundation

import Foundation

// swiftlint:disable identifier_name
// MARK: - String extension
extension String {
    /// Aims to know if a string is empty or not after trimming whites paces and new lines
    public var isNotEmptyAfterTrimWhitespacesAndNewlines: Bool {
        !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private static var emailPredicate: NSPredicate = {
        let mailFirstPart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let mailServerPart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegex = mailFirstPart + "@" + mailServerPart + "[A-Za-z]{2,8}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex)
    }()

    public static func exist(str: String?) -> Bool {
        guard let str = str else { return false }
        return str.count > 0
    }
    
    public static func filledString(_ str: String?) -> String? {
        guard String.exist(str: str) else { return nil }
        return str!
    }
        
    public func toDate(format: DateFormat,
                       file: String = #filePath,
                       line: UInt = #line) -> Date? {
        let dateFormatter = format.formatter
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: self)

        return date
    }
    
    

    public func isEmailFormat() -> Bool {
        return String.emailPredicate.evaluate(with: self)
    }

    public var capitalizeFirst: String {
        if isEmpty { return "" }
        var result = self

        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).uppercased())
        return result
    }

    public static func ratingFormat(_ format: Float) -> String {
        let tmp = Int(round(format * 10))
        if tmp % 10 != 0 {
            return String(format: "%.1f", Float(tmp) / 10.0)
        }
        return "\(Int(tmp / 10))"
    }
    
    private var lastDigits: Int? {
        var digitStr = ""
        for charac in self {
            let char = String(charac)
            if Int(char) != nil {
                digitStr += char
            } else {
                digitStr = ""
            }
        }
        return Int(digitStr)
    }
    
    public var incrementName: String {
        
        if let digits = lastDigits {
            return self.replacingOccurrences(of: String(digits), with: String(digits + 1))
        } else {
            return self + "1"
        }
    }


    public var valueForSort: String {
        return self.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
    }
    
    public static func isBefore(lhs: String?, rhs: String?) -> Bool {
        if lhs == nil, rhs != nil {
            return true
        } else if lhs != nil, rhs == nil {
            return true
        } else if lhs == nil, rhs == nil {
            return true
        } else if let lhs = lhs, let rhs = rhs {
            return lhs < rhs
        } else {
            return true
        }
    }
    
    public func matches(regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch {
            return []
        }
    }
    
    public static func settingsPath(pathComponents: [String]) -> String {
        return pathComponents.joined(separator: " > ")
    }
        
   
}

public extension Bool {
    static func getValue(val: Any?, defaultValue: Bool = false) -> Bool {
        if let booleanValue = val as? Bool {
            return booleanValue
        } else if let intValue = val as? Int {
            return intValue == 1
        } else {
            return defaultValue
        }
    }
}
