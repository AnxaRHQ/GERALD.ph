//
//  AnxaSession.swift
//  geraldph
//
//  Created by Elaine Reyes on 1/9/18.
//  Copyright © 2018 HAPILABS LIMITED. All rights reserved.
//

import UIKit
import Foundation

class AnxaSession: NSObject
{
    // MARK: - Variables
    
    var appID               : NSString?         = nil
    let userID              : NSString?         = nil
    let eventID             : NSString?         = nil
    let sessionStartTime    : Double?           = nil
    let sessionEndTime      : Double?           = nil
    
    let newSessionTimeInterval : Double         = 8000
    var isStarted           : Bool              = false
    
    // MARK: - Initialization Method
    
    override init()
    {
        super.init()
    }
    
    //MARK: - Shared Instance
    
    static let sharedInstance : AnxaSession =
    {
        let instance = AnxaSession()
        return instance
    }()
    
    // MARK: - Start Session
    
    func startSession(aID: NSString)
    {
        print("\(#function)")
        
        appID = aID
        
        if (UserDefaults.standard.double(forKey: "sessionLogStartTime") == 0)
        {
            // Set current time as start time
            
            let startTime : TimeInterval = NSDate().timeIntervalSince1970
            UserDefaults.standard.set(startTime*1000, forKey: "sessionLogStartTime")
            
            print("startTime: \(startTime*1000)")
            print("startTime: \(UserDefaults.standard.double(forKey: "sessionLogStartTime"))")
            
            let logArray : NSMutableArray = NSMutableArray()
            
            // Store log queue array back to User Defaults
            
            UserDefaults.standard.set(logArray, forKey: "sessionLogQueue")
        }
        else
        {
            // Set current time as start time
            
            let startTime : TimeInterval = NSDate().timeIntervalSince1970
            UserDefaults.standard.set(startTime*1000, forKey: "sessionLogStartTime")
            
            // Reset close time
            
            UserDefaults.standard.set(0, forKey: "sessionLogCloseTime")
        }
        
        isStarted = true
    }
    
    // MARK: - Resume Session
    
    func resumeSession()
    {
        print("\(#function)")
        
        // Get stored start time
        
        let startTime : Double = UserDefaults.standard.double(forKey: "sessionLogStartTime")
        let closeTime : Double = UserDefaults.standard.double(forKey: "sessionLogCloseTime")
        
        print("startTime: \(startTime)")
        print("closeTime: \(closeTime)")
        
        // Compute interval between stored start time and time now
        
        let currentTime : TimeInterval  = NSDate().timeIntervalSince1970
        let intervalFromNow : Double    = (currentTime*1000)-closeTime
        
        if (intervalFromNow < newSessionTimeInterval || closeTime == 0)
        {
            // Reset close time
            
            UserDefaults.standard.set(0, forKey: "sessionLogCloseTime")
        }
        else
        {
            // Queue current start time and end time for upload
            
            self.queueLogStart(startTime: startTime, endTime: closeTime)
            
            // Set new start time
            
            UserDefaults.standard.set(currentTime*1000, forKey: "sessionLogStartTime")
            
            // Reset close time
            
            UserDefaults.standard.set(0, forKey: "sessionLogCloseTime")
        }
    }
    
    // MARK: - Close Session
    
    func closeSession()
    {
        print("\(#function)")
        
        if (isStarted)
        {
            isStarted = false
            
            let closeTime : TimeInterval = NSDate().timeIntervalSince1970
            UserDefaults.standard.set(closeTime*1000, forKey: "sessionLogCloseTime")
            
            self.queueLogStart(startTime: UserDefaults.standard.double(forKey: "sessionLogStartTime"), endTime: UserDefaults.standard.double(forKey: "sessionLogCloseTime"))
            
            print("closeTime: \(closeTime*1000)")
        }
    }
    
    // MARK: Upload
    
    func upload()
    {
        print("\(#function)")
        
        sessionClient.delegate = self
        
        // Get stored log queue
        
        let logArray: NSMutableArray = NSMutableArray(array: UserDefaults.standard.object(forKey: "sessionLogQueue") as! [NSDictionary])
        
        if ((logArray.count) > 0)
        {
            print("logArray : \(String(describing: logArray))")
            
            for sessionLog in logArray
            {
                let sessionLogTemp : NSDictionary = sessionLog as! NSDictionary
                
                // get session time
                
                let startTime : Double = sessionLogTemp["sessionLogStartTime"] as! Double
                let closeTime : Double = sessionLogTemp["sessionLogCloseTime"] as! Double
                let sessionTimeInterval : Double = closeTime - startTime
                
                print("sessionLogStartTime : \(startTime)")
                print("sessionLogCloseTime : \(closeTime)")
                
                // get date
                
                let date : NSDate = NSDate(timeIntervalSince1970: closeTime / 1000)
                
                let logDetail : NSString = NSString(format: "%@T%@",CalendarUtil.sharedInstance.getYearMonthsDayFromDate(date: date), CalendarUtil.sharedInstance.getHourMinutesSecondsFromDate(date: date))
                
                // send data
                
                sessionClient.sendSessionTime(duration: sessionTimeInterval, logDetails: logDetail, logTime: closeTime)
            }
        }
        else
        {
            print("NO LOGS YET")
        }
    }
    
    // MARK: - Queue
    
    func queueLogStart(startTime: Double, endTime : Double)
    {
        print("\(#function)")
        
        // Create dictionary for log entry
        
        let sessionLog : NSDictionary = ["sessionLogStartTime" : NSNumber(value:startTime),
                                         "sessionLogCloseTime" : NSNumber(value:endTime)]
        
        // Get Stored Log Queue then add created entry
        
        let logArray: NSMutableArray = NSMutableArray(array: UserDefaults.standard.object(forKey: "sessionLogQueue") as! [NSDictionary])
        logArray.add(sessionLog)
        
        // Store Log Queue Array back to UserDefaults
        UserDefaults.standard.set(logArray, forKey: "sessionLogQueue")
        
        self.upload()
    }
}

// MARK: - Extension

var sessionClient : SessionHTTPClient = SessionHTTPClient()

extension AnxaSession : SessionHTTPClientDelegate
{
    // MARK: - SessionHTTPClientDelegate
    
    func SessionHTTPClient(sender: SessionHTTPClient, didSendDataWithDetail success: NSString, logTime: Double)
    {
        print("\(#function)")
        
        // Get stored log queue then ad created entry
        
        let logArray: NSMutableArray = NSMutableArray(array: UserDefaults.standard.object(forKey: "sessionLogQueue") as! [NSDictionary])
        
        // Filter and delete object
        
        let filterValue : NSNumber = NSNumber(value: logTime)
        let filtered : NSArray = logArray.filtered(using: NSPredicate(format: "(sessionLogCloseTime == %d)", filterValue)) as NSArray
        
        if (filtered.count > 0)
        {
            logArray.removeObject(identicalTo: filtered[0])
        }
        else
        {
            logArray.removeAllObjects()
        }
        
        // Store log queue array back to User Defaults
        
        UserDefaults.standard.set(logArray, forKey: "sessionLogQueue")
    }
    
    func SessionHTTPClient(sender: SessionHTTPClient, didFailWithError error: NSString)
    {
        print("\(#function)")
    }
}
