import UIKit

extension Date
{
    
    public enum DateTimeInterval {
        case Day, Week, Month, Year
    }
    
    public enum TimeZones : String{
        case UTC, LocalZone
    }
    

    
    public static func findMonthAsNum(date: Date) -> Int {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        
        return components.month!
    }
    
    
    /// Get number of days in a month
    public static func findNumOfDaysInMonth(date: Date) -> Int {
        
        let calendar = Calendar.current
        // Calculate start and end of the current month
        let interval = calendar.dateInterval(of: .month, for: date)!
        // Compute difference in days:
        let numDays = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        
        return numDays
    }
    /// Get number of days in a month
    public static func findNumOfDaysInMonth(year: Int, month: Int) -> Int {
        
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    
    
    /// Converts date to string
    public static func formatDateAndTimezoneString(date: Date, dateFormat: String, timeZone: TimeZones) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: timeZone.rawValue)

        return dateFormatter.string(from: date)
    }
    
    public static func formatDateAndTimezone(date: Date, dateFormat: String, timeZone: TimeZones) -> Date {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = dateFormat
//        dateFormatter.timeZone = TimeZone(identifier: timeZone.rawValue)
//        dateFormatter.defaultDate = date
//
//        return Date()
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: date))
        return Date(timeInterval: seconds, since: date)
    }
    
    // Convert local time to UTC (or GMT)
//    func toGlobalTime() -> Date {
//        let timezone = TimeZone.current
//        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
//        return Date(timeInterval: seconds, since: self)
//    }
    
    /// Input time is converted to UTC time
    public static func getStartEndDatesString(referenceDate: Date, timeInterval: DateTimeInterval) -> (String, String) {
        
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
        
        let startDateString =  formatDateAndTimezoneString(date: startDate, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC)
        
        return (
           startDateString,
           formatDateAndTimezoneString(date: endDate!, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC))
    }
    
    
    /// Input time is converted to UTC time
    public static func getStartEndDate(referenceDate: Date, timeInterval: DateTimeInterval) -> (Date, Date) {
        
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
        
//        let startDateString =  formatDateAndTimezoneString(date: startDate, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC)
        return (startDate, endDate!)
//        return (
//           startDateString,
//           formatDateAndTimezoneString(date: endDate!, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC))
    }
}
