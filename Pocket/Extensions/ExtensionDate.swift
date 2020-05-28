import UIKit

extension Date
{
    
    public enum DateTimeInterval {
        case Day, Week, Month, Year
    }
    
    public enum Timezones : String{
        case UTC, current
    }

    /// String to Date timezone conversion
//    public static func calculateDateTimezoneConversionAsDate(date: String, format: String, timezoneCurrent: TimeZone, timezoneDesired: TimeZone) -> Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format
//        dateFormatter.calendar = NSCalendar.current
//        dateFormatter.timeZone = timezoneCurrent
//
//        // Desired timezone
//        let dt = dateFormatter.date(from: date)
//        dateFormatter.timeZone = timezoneDesired
//        dateFormatter.dateFormat = format
//
//        return Date()
//    }
    
    /// String to String timezone conversion
    public static func calculateDateTimezoneConversionAsString(date: String, format: String, timezoneCurrent: TimeZone, timezoneDesired: TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = timezoneCurrent
        
        // Desired timezone
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = timezoneDesired
        dateFormatter.dateFormat = format

        return dateFormatter.string(from: dt!)
    }

    
    
    
    
    /// String to Date conversion
    //  Date string format and date format must match otherwise dateformatter will return nil
    public static func calculateDateStringIntoDate(date: String, dateFormat: String, timezone: Timezones?) -> Date {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        
        if timezone != nil {
            dateformatter.timeZone = TimeZone(identifier: timezone!.rawValue)
        }
        return dateformatter.date(from: date)!
    }
    
    /// Date to String conversion
    public static func calculateDateIntoString(date: Date, dateFormat: String, timeZone: Timezones) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: timeZone.rawValue)

        return dateFormatter.string(from: date)
    }
    
    
    
    
    
    /// Get date's month as an integer
    public static func calculateDateMonthAsInt(date: Date) -> Int {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        
        return components.month!
    }
    
    /// Get number of days in a month
    public static func calculateNumOfDaysInMonth(date: Date) -> Int {
        
        let calendar = Calendar.current
        // Calculate start and end of the current month
        let interval = calendar.dateInterval(of: .month, for: date)!
        // Compute difference in days:
        let numDays = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        
        return numDays
    }
    
    /// Get number of days in a month
    public static func calculateNumOfDaysInMonth(year: Int, month: Int) -> Int {
        
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    
    
    
    
    
    /// Input time is converted to UTC time
    public static func calculateStartEndDatesAsString(referenceDate: Date, timeInterval: DateTimeInterval) -> (String, String) {
        
        var dateComponentDayWeek = DateComponents() // Used for Day and Week
        let dateComponentMonthYear: DateComponents? // Used for Month and Year
        
        var startDate = Calendar.current.startOfDay(for: referenceDate)
        var endDate: Date?
        
        switch timeInterval {
        
        case .Day:
            dateComponentDayWeek.day = 1
            dateComponentDayWeek.minute = -1
            endDate = Calendar.current.date(byAdding: dateComponentDayWeek, to: startDate)
            
        case .Week: // Week start is Sunday
            let gregorian = Calendar(identifier: .gregorian)
            startDate = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: referenceDate))!
            dateComponentDayWeek.day = 7
            dateComponentDayWeek.minute = -1
            endDate = Calendar.current.date(byAdding: dateComponentDayWeek, to: startDate)
            
        case .Month:
            dateComponentMonthYear = Calendar.current.dateComponents([.year, .month], from: referenceDate)
            startDate = Calendar.current.date(from: dateComponentMonthYear!)!
            dateComponentDayWeek.month = 1
            dateComponentDayWeek.minute = -1
            endDate = Calendar.current.date(byAdding: dateComponentDayWeek, to: startDate)
            
        case .Year:
            dateComponentMonthYear = Calendar.current.dateComponents([.year], from: referenceDate)
            startDate = Calendar.current.date(from: dateComponentMonthYear!)!
            dateComponentDayWeek.year = 1
            dateComponentDayWeek.minute = -1
            endDate = Calendar.current.date(byAdding: dateComponentDayWeek, to: startDate)
        }
        
        let startDateString =  calculateDateIntoString(date: startDate, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC)
        
        return (
           startDateString,
           calculateDateIntoString(date: endDate!, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC))
    }
    
    
    /// Input time is converted to UTC time
    public static func calculateStartEndDatesAsDate(referenceDate: Date, timeInterval: DateTimeInterval) -> (Date, Date) {
        
        var dateComponentDayWeek = DateComponents() // Used for Day and Week
        let dateComponentMonthYear: DateComponents? // Used for Month and Year
        
        var startDate = Calendar.current.startOfDay(for: referenceDate)
        var endDate: Date?
        
        switch timeInterval {
        
        case .Day:
            dateComponentDayWeek.day = 1
            dateComponentDayWeek.minute = -1
            endDate = Calendar.current.date(byAdding: dateComponentDayWeek, to: startDate)
            
        case .Week: // Week start is Sunday
            let gregorian = Calendar(identifier: .gregorian)
            startDate = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: referenceDate))!
            dateComponentDayWeek.day = 7
            dateComponentDayWeek.minute = -1
            endDate = Calendar.current.date(byAdding: dateComponentDayWeek, to: startDate)
            
        case .Month:
            dateComponentMonthYear = Calendar.current.dateComponents([.year, .month], from: referenceDate)
            startDate = Calendar.current.date(from: dateComponentMonthYear!)!
            dateComponentDayWeek.month = 1
            dateComponentDayWeek.minute = -1
            endDate = Calendar.current.date(byAdding: dateComponentDayWeek, to: startDate)
            
        case .Year:
            dateComponentMonthYear = Calendar.current.dateComponents([.year], from: referenceDate)
            startDate = Calendar.current.date(from: dateComponentMonthYear!)!
            dateComponentDayWeek.year = 1
            dateComponentDayWeek.minute = -1
            endDate = Calendar.current.date(byAdding: dateComponentDayWeek, to: startDate)
        }
        
        return (startDate, endDate!)
    }
}
