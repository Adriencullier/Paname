import Foundation

import Foundation

extension Locale {
//    public static func getPreferredLocale() -> Locale {
//        if let code = Locale.current.languageCode,
//            Module.app.bundle.localizations.contains(code) {
//            return Locale.current
//        } else if let preferredLocal = Module.app.bundle.localizations.first {
//            return Locale(identifier: preferredLocal)
//        } else {
//            return Locale(identifier: "en_US_POSIX")
//        }
//    }
}

extension DateFormatter {
    
    fileprivate convenience init(dateFormat: DateFormat) {
        self.init()
//        self.locale = dateFormat.locale
                
        switch dateFormat {
        case .dateTimeWithoutSecondLocalized, .dateTimePrettyLocalized:
            self.dateFormat = DateFormatter.dateFormat(fromTemplate: dateFormat.dateFormat, options: 0, locale: locale)
        default:
            self.dateFormat = dateFormat.dateFormat
        }
        
        if let specificTimeZone = dateFormat.timeZone {
            self.timeZone = specificTimeZone
        }
    }

    public static func getPositionalTime(from seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        guard let time = formatter.string(from: TimeInterval(seconds)) else {
            fatalError("cannot parse time")
        }
        return time
    }
}

public enum DateFormat: Equatable {
    /// Format: yyyy-MM-dd'T'HH:mm:ssZZZZZ
    case iso8601
    case yearMonth
    /// Format: yyyy-MM-dd
    case date
    /// Format: yyyy-MM-dd
    case datePosix
    /// Format: yyyy-MM-dd HH:mm:ss
    case dateTime
    /// Format: yyyy-MM-dd HH:mm:ss
    case dateTimePrettyLocalized
    /// Format: yyyy-MM-dd HH:mm
    case dateTimeWithoutSecond
    /// Format: yyyy-MM-dd HH:mm
    case dateTimeWithoutSecondLocalized
    /// Format: yyyy-MM-dd'T'HH:mm:ssxxx
    case dateTimeZone
    /// Format: yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ
    case dateTimeZoneWithMilliseconds
    /// Format: dd-MM_HHmmss
    case logTime
    /// Format: dd/MM
    case dateDayMonth
    /// Format: dd MMM
    case dateShortPretty
    /// Format: dd MMM yyyy
    case datePretty
    /// Format: dd/MM/yyyy
    case datePrettyWithSeparator
    /// Format: HH:mm
    case time
    /// Format: d
    case day
    /// Format: MMMM
    case month
    /// Format: MMM
    case monthSmall
    /// Format: EEE
    case weekday
    /// Format: EEEE
    case weekdayLong
    /// Format: EEE dd MMMM
    case weekdayMonth
    /// Format: EEEE dd MMM
    case weekdayMonthShort
    /// Format: EEE dd MMMM yyyy
    case weekdayMonthYear
    /// Format: relativeDateFormater
    case relativeDate
    /// Format: absDateFormater
    case absoluteDate
    
    static var datFormatterISO8601: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = DateFormat.iso8601.dateFormat
        return dateFormatter
    }()
    
    static var absDateFormater: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        // Locale of the phone if it exists in translated language. "en_US_POSIX" if it does not exist
//        dateFormatter.locale = Locale.getPreferredLocale()
        return dateFormatter
    }()
    
    static var relativeDateFormater: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        // Locale of the phone if it exists in translated language. "en_US_POSIX" if it does not exist
//        dateFormatter.locale = Locale.getPreferredLocale()
        return dateFormatter
    }()
    
    static var relativeDateFormaterWithoutTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        // Locale of the phone if it exists in translated language. "en_US_POSIX" if it does not exist
//        dateFormatter.locale = Locale.getPreferredLocale()
        return dateFormatter
    }()
    
    static private var dateFormatter = DateFormatter(dateFormat: .date)
    static private var datePosixFormatter = DateFormatter(dateFormat: .datePosix)
    static private var dateTimePrettyFormatter = DateFormatter(dateFormat: .dateTimePrettyLocalized)
    static private var dateTimeFormatter = DateFormatter(dateFormat: .dateTime)
    static private var dateTimeWithoutSecondFormatter = DateFormatter(dateFormat: .dateTimeWithoutSecond)
    static private var dateTimeWithoutSecondLocalFormatter = DateFormatter(dateFormat: .dateTimeWithoutSecondLocalized)
    static private var dateTimeZoneFormatter = DateFormatter(dateFormat: .dateTimeZone)
    static private var logTimeFormatter = DateFormatter(dateFormat: .logTime)
    static private var dateDayMonthFormatter = DateFormatter(dateFormat: .dateDayMonth)
    static private var dateShortFormatter = DateFormatter(dateFormat: .dateShortPretty)
    static private var datePrettyFormatter = DateFormatter(dateFormat: .datePretty)
    static private var datePrettyWithSeparatorFormatter = DateFormatter(dateFormat: .datePrettyWithSeparator)
    static private var timeFormatter = DateFormatter(dateFormat: .time)
    static private var monthFormatter = DateFormatter(dateFormat: .month)
    static private var dayFormatter = DateFormatter(dateFormat: .day)
    static private var monthSmallFormatter = DateFormatter(dateFormat: .monthSmall)
    static private var weekdayFormatter = DateFormatter(dateFormat: .weekday)
    static private var weekdayLongFormatter = DateFormatter(dateFormat: .weekdayLong)
    static private var weekdayMonthFormatter = DateFormatter(dateFormat: .weekdayMonth)
    static private var weekdayMonthShortFormatter = DateFormatter(dateFormat: .weekdayMonthShort)
    static private var weekdayMonthYearFormatter = DateFormatter(dateFormat: .weekdayMonthYear)
    static private var dateTimeZone2Formatter = DateFormatter(dateFormat: .dateTimeZoneWithMilliseconds)
    
    var formatter: DateFormatter {
        switch self {
        case .iso8601:
            return DateFormat.datFormatterISO8601
        case .date:
            return DateFormat.dateFormatter
        case .datePosix:
            return DateFormat.datePosixFormatter
        case .dateTime:
            return DateFormat.dateTimeFormatter
        case .dateTimePrettyLocalized:
            return DateFormat.dateTimePrettyFormatter
        case .dateTimeWithoutSecond:
            return DateFormat.dateTimeWithoutSecondFormatter
        case .dateTimeWithoutSecondLocalized:
            return DateFormat.dateTimeWithoutSecondLocalFormatter
        case .dateTimeZone:
            return DateFormat.dateTimeZoneFormatter
        case .dateTimeZoneWithMilliseconds:
            return DateFormat.dateTimeZone2Formatter
        case .logTime:
            return DateFormat.logTimeFormatter
        case .dateDayMonth:
            return DateFormat.dateDayMonthFormatter
        case .dateShortPretty:
            return DateFormat.dateShortFormatter
        case .datePretty:
            return DateFormat.datePrettyFormatter
        case .datePrettyWithSeparator:
            return DateFormat.datePrettyWithSeparatorFormatter
        case .time:
            return DateFormat.timeFormatter
        case .day:
            return DateFormat.dayFormatter
        case .month:
            return DateFormat.monthFormatter
        case .monthSmall:
            return DateFormat.monthSmallFormatter
        case .weekday:
            return DateFormat.weekdayFormatter
        case .weekdayLong:
            return DateFormat.weekdayLongFormatter
        case .weekdayMonth:
            return DateFormat.weekdayMonthFormatter
        case .weekdayMonthShort:
            return DateFormat.weekdayMonthShortFormatter
        case .weekdayMonthYear:
            return DateFormat.weekdayMonthYearFormatter
        case .relativeDate:
            return DateFormat.relativeDateFormater
        case .absoluteDate:
            return DateFormat.absDateFormater
        case .yearMonth:
            return DateFormat.dateFormatter
        }
    }
    
    fileprivate var timeZone: TimeZone? {
        switch self {
        case .datePosix:
            return TimeZone(abbreviation: "GMT")
        default:
            return nil
        }
    }
    
//    fileprivate var locale: Locale {
//        switch self {
//        case .time, .dateTime, .datePosix:
//            return Locale(identifier: "en_US_POSIX")
//        default:
//            return Locale.getPreferredLocale()
//        }
//    }

    fileprivate var dateFormat: String {
        switch self {
        case .iso8601:
            return "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        case .date, .datePosix:
            return "yyyy-MM-dd"
        case .dateTime, .dateTimePrettyLocalized:
            return "yyyy-MM-dd HH:mm:ss"
        case .dateTimeWithoutSecond, .dateTimeWithoutSecondLocalized:
            return "yyyy-MM-dd HH:mm"
        case .dateTimeZone:
            return "yyyy-MM-dd'T'HH:mm:ssxxx"
        case .dateTimeZoneWithMilliseconds:
            return "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
        case .logTime:
            return "dd-MM_HHmmss"
        case .dateDayMonth:
            return "dd/MM"
        case .dateShortPretty:
            return "dd MMM"
        case .datePretty:
            return "dd MMM yyyy"
        case .datePrettyWithSeparator:
            return "dd/MM/yyyy"
        case .time:
            return "HH:mm"
        case .month:
            return "MMMM"
        case .day:
            return "d"
        case .monthSmall:
            return "MMM"
        case .weekday:
            return "EEE"
        case .weekdayLong:
            return "EEEE"
        case .weekdayMonth:
            return "EEE dd MMMM"
        case .weekdayMonthShort:
            return "EEE dd MMM"
        case .weekdayMonthYear:
            return "EEE dd MMMM yyyy"
        case .relativeDate, .absoluteDate:
            return self.formatter.dateFormat
        case .yearMonth:
            return "yyyy MM"
        }
    }
}

