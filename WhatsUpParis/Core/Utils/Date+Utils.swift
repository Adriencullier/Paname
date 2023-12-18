import Foundation

public typealias MonthInfo = (days: [Date], offSet: Int, endOffset: Int)

extension Date {
    public var isToday: Bool {
        return self.toString(.date) == Date().toString(.date)
    }
    
    /// Get number of a day from date
    /// - Returns: Int
    public func getDayNumber() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    
    /// >= date comparator
    public func isGreaterOrEqual(_ date: Date) -> Bool {
        return self.compare(date) == .orderedDescending || self.compare(date) == .orderedSame
    }
    
    /// >= now comparator
    public func isGreaterOrEqualThanNow() -> Bool {
        return self.compare(Date()) == .orderedDescending || self.compare(Date()) == .orderedSame
    }

    /// > date comparator
    public func isGreater(_ date: Date) -> Bool {
        return self.compare(date) == .orderedDescending
    }

    /// <= date comparator
    public func isLowerOrEqual(_ date: Date) -> Bool {
        return self.compare(date) == .orderedAscending || self.compare(date) == .orderedSame
    }

    /// < date comparator
    public func isLower(_ date: Date) -> Bool {
        return self.compare(date) == .orderedAscending
    }
    
    public func isSameDay(_ date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }

    public func floorOnSlot() -> Date {
        let rsec: Double = 15 * 60
        let seconds = floor(self.timeIntervalSinceReferenceDate / rsec) * rsec
        return Date(timeIntervalSinceReferenceDate: seconds)
    }

    public func toString(_ format: DateFormat) -> String {
        let dateFormatter = format.formatter
        return dateFormatter.string(from: self)
    }
    
    public func toRelativeString() -> String {
        // Get the result of both formatters
        let rel = DateFormat.relativeDateFormater.string(from: self) // Today at 11:46 or 12 mars 2019 à 11:46
        let abs = DateFormat.absDateFormater.string(from: self) // 12 mars 2019 à 11:46
        
        // If the results are the same then it isn't a relative date.
        // Use custom formatter. If different, return the relative result.
        if rel == abs {
            let date = DateFormat.dateTimeWithoutSecondLocalized.formatter.string(from: self) // 12/03/2019 à 11:46
            return date
        } else {
            return rel.capitalizeFirst
        }
    }
    
    public func toRelativeStringWithoutTime() -> String {
        return DateFormat.relativeDateFormaterWithoutTime.string(from: self)
    }
    
    public func toDate(_ format: DateFormat) -> Date {
        let stringDate = self.toString(format)
        return stringDate.toDate(format: format) ?? self
    }
    
    public var midnight: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }

    public var midday: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

    public var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: midday)!
    }


    public var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: midday)!
    }

    public func toISO8601() -> String {
        return DateFormat.iso8601.formatter.string(from: self)
    }
    
    public static var rgpdDate: Date = {
        var dateComponent = DateComponents()
        dateComponent.year = 2018
        dateComponent.month = 5
        dateComponent.day = 25
        dateComponent.hour = 0
        dateComponent.minute = 0
        
        return Calendar.current.date(from: dateComponent)!
    }()
    
   
    
    /// - Parameters:
    ///   - itemDate:
    ///   - birthday:
    /// - Returns: return true if item date  and birthday date is same day and same month
    /// UT: Todo
    private static func isBirthDay(itemDate: Date, birthday: Date) -> Bool {
        var birthdayDateComponent = Calendar.current.dateComponents([.day, .month], from: birthday)
        let itemDateComp = Calendar.current.dateComponents([.day, .month], from: itemDate)
        if birthdayDateComponent.day == 29 && birthdayDateComponent.month == 2 {
            birthdayDateComponent.day = 1
            birthdayDateComponent.month = 3
        }
        
        return itemDateComp.month == birthdayDateComponent.month
            && itemDateComp.day == birthdayDateComponent.day

    }
    
    
    
    
    public func buildMonth() -> MonthInfo {
        let calendar = Calendar(identifier: .gregorian)
        let daysInWeek = 7
        var weekOffset = 0
        var endWeekOffset = 0
        var comp = calendar.dateComponents([.year, .month, .day], from: self)
        comp.day = 1
        let monthFirstDate = calendar.date(from: comp)!

        comp = calendar.dateComponents([.year, .month, .day], from: self)
        comp.month! += 1
        comp.day = 0
        let monthLastDate = calendar.date(from: comp)!

        let weekday = calendar.component(.weekday, from: monthFirstDate)
        let endWeekday = calendar.component(.weekday, from: monthLastDate)
        
        weekOffset = weekday - calendar.firstWeekday
        weekOffset -= 1
        
        endWeekOffset = 7 - (endWeekday - 1)
        
        if weekOffset < 0 {
            weekOffset += daysInWeek
        }

        var dates = [Date]()
        let numDays = calendar.dateComponents([.day], from: monthFirstDate, to: monthLastDate).day! + 1
        for index in 0..<numDays {
            dates.append(calendar.date(byAdding: .day, value: index, to: monthFirstDate)!)
        }

        return (dates, weekOffset, endWeekOffset)
    }
    
    public var lastDate: Date {
        return self.addingTimeInterval(12 * 31 * 24 * 3600)
    }
    
}

extension DateComponents {
    public func isAfter(_ component: DateComponents) -> Bool {
        if let after = isAfter(val1: self.year, val2: component.year) {
            return after
        } else if let after = isAfter(val1: self.month, val2: component.month) {
            return after
        } else if let after = isAfter(val1: self.day, val2: component.day) {
            return after
        } else if let after = isAfter(val1: self.hour, val2: component.hour) {
            return after
        } else if let after = isAfter(val1: self.minute, val2: component.minute) {
            return after
        } else if let after = isAfter(val1: self.second, val2: component.second) {
            return after
        } else {
            return false
        }
    }
    
    private func isAfter(val1: Int?, val2: Int?) -> Bool? {
        let v1 = val1 ?? 0
        let v2 = val2 ?? 0
        if v1 != v2 {
            return v1 > v2
        } else {
            return nil
        }
    }
}

