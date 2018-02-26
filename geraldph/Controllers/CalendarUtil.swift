//
//  CalendarUtil.swift
//  geraldph
//
//  Created by Elaine Reyes on 2/22/18.
//  Copyright © 2018 HAPILABS LIMITED. All rights reserved.
//

import UIKit

class CalendarUtil: NSObject
{
    // MARK: Shared Instance
    
    static let sharedInstance : CalendarUtil =
    {
        let instance = CalendarUtil()
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init()
    {
        super.init()
    }
    
    // MARK: - Calendar
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String
    {
        let hours   = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        return "\(hours)h \(minutes)m \(seconds)s"
    }
    
    class func convertGMTDateToLocalDate(gmtDate: NSDate) -> NSDate
    {
        let timeZoneSeconds = NSTimeZone.local.secondsFromGMT()
        let dateInLocalTimezone = gmtDate.addingTimeInterval(TimeInterval(timeZoneSeconds))
        
        return dateInLocalTimezone
    }
    
    class func getFirstHourOfDate(_ date: Date)  -> Date
    {
        var dateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date)
        
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return Calendar.current.date(from: dateComponents)!
    }
}
