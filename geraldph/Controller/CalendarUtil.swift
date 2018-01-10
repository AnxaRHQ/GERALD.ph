//
//  CalendarUtil.swift
//  geraldph
//
//  Created by Elaine Reyes on 1/9/18.
//  Copyright © 2018 HAPILABS LIMITED. All rights reserved.
//

import UIKit

class CalendarUtil: NSObject
{
    //MARK: Shared Instance
    
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
    
    func getYearMonthsDayFromDate(date: NSDate) -> NSString
    {
        let dateFormatter       = DateFormatter()
        dateFormatter.locale    = NSLocale.current
        
        dateFormatter.timeZone  = NSTimeZone(abbreviation: "GMT")! as TimeZone
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date as Date) as NSString
    }
    
    func getHourMinutesSecondsFromDate(date : NSDate) -> NSString
    {
        let dateFormatter       = DateFormatter()
        dateFormatter.locale    = NSLocale.current
        
        dateFormatter.timeZone  = NSTimeZone(abbreviation: "GMT")! as TimeZone
        dateFormatter.dateFormat = "HH:mm:ss"
        
        return dateFormatter.string(from: date as Date) as NSString
    }
}
