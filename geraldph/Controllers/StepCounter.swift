//
//  StepCounter.swift
//  geraldph
//
//  Created by Elaine Reyes on 2/22/18.
//  Copyright © 2018 HAPILABS LIMITED. All rights reserved.
//

import Foundation
import CoreMotion

@available(iOS 8.0, *)
@objc (StepCounter)

public class StepCounter : NSObject
{
    @objc dynamic var stepsToday : NSInteger = 0
    @objc dynamic var timeMoving : TimeInterval = 0
    @objc dynamic var stepStartDate : NSDate!
    @objc dynamic var isCounting : Bool = false
    
    private var _cmPedometer : CMPedometer!
    private var _cmMotionActivityManager : CMMotionActivityManager!
    private var _operationQueue : OperationQueue!
    private var _isLiveCounting : Bool = false;
    var rawStepsComputed = ""
    
    typealias stepCounterData = (_ from: NSDate?, _ to : NSDate?, _ steps: NSInteger, _ distance: NSInteger, _ duration: TimeInterval, _ startDate: NSDate, _ rawsteps: NSString) -> ()
    
    override init()
    {
        super.init()
        //Roll Tide
        
        _cmPedometer = CMPedometer()
        _cmMotionActivityManager = CMMotionActivityManager()
        
        _operationQueue = OperationQueue()
        _operationQueue.maxConcurrentOperationCount = 1
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(timeChangedSignificantly), name: NSNotification.Name(rawValue: "UIApplicationSignificantTimeChangeNotification"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name(rawValue: "UIApplicationWillEnterForegroundNotification"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(didEnterBackground), name: NSNotification.Name(rawValue: "UIApplicationDidEnterBackgroundNotification"), object: nil)
        
        self.startStepsCounting()
        
        self.updateStepsToday()
    }
    
    class var shared : StepCounter
    {
        struct Singleton
        {
            static let instance = StepCounter()
        }
        
        return Singleton.instance
    }
    
    class func isStepCountingAvailable() -> Bool
    {
        return CMPedometer.isStepCountingAvailable()
    }
    
    func stepsFromDateRange(dateFrom: NSDate!, dateTo: NSDate!, withHandler callback: @escaping stepCounterData)
    {
        #if arch(i386) || arch(x86_64) && os(iOS)
            
            // Simulator
            
        #else
            
            if CMPedometer.isStepCountingAvailable()
            {
                self._cmPedometer.queryPedometerData(from: dateFrom as Date, to: dateTo as Date, withHandler: {( pedometerData, error) -> Void in
                    
                    var steps : NSInteger = -1
                    var distance : NSInteger = 0
                    var duration : TimeInterval = 0
                    let rawsteps : NSString = ""
                    var stepStartDate : NSDate = NSDate()
                    
                    if error == nil
                    {
                        steps = (pedometerData?.numberOfSteps.intValue)!
                        distance = (pedometerData?.distance!.intValue)!
                        
                        self._cmMotionActivityManager.queryActivityStarting(from: dateFrom as Date, to: dateTo as Date, to: self._operationQueue, withHandler: { (activities, error) -> Void in
                            
                            if error == nil {
                                
                                var previousActivity : CMMotionActivity!
                                
                                for activity in activities! {
                                    
                                    if previousActivity != nil {
                                        
                                        if previousActivity.running || previousActivity.walking || previousActivity.cycling {
                                            
                                            let timeInterval : Double = activity.startDate.timeIntervalSince(previousActivity.startDate)
                                            
                                            duration += timeInterval
                                            
                                            stepStartDate = CalendarUtil.convertGMTDateToLocalDate(gmtDate: activity.startDate as NSDate)
                                            
                                            print("stepStartDate: \(stepStartDate)")
                                        }
                                        
                                    }
                                    
                                    previousActivity = activity
                                }
                            }
                            callback(dateFrom, dateTo, steps, distance, duration, stepStartDate, rawsteps)
                        })
                    }
                    
                })
            }
            else
            {
                
                NSLog("Core Motion not supported.")
                
                callback(dateFrom, dateTo, -1, 0, 0, NSDate(), "")
            }
            
        #endif
    }
    
    func stepsFromDateRangeWithRawData(dateFrom: NSDate!, dateTo: NSDate!, withHandler callback: @escaping stepCounterData)
    {
        //let concurrentQueue : dispatch_queue_t  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        self.stepsFromDateRange( dateFrom: dateFrom, dateTo: dateTo) { (from, to, steps, distance, duration, startDate, rawsteps) -> () in
            
            DispatchQueue.global(qos: .default).async
                {
                    #if arch(i386) || arch(x86_64) && os(iOS)
                        
                        // Simulator
                        
                    #else
                        
                        if CMPedometer.isStepCountingAvailable()
                        {
                            if steps > 0
                            {
                                DispatchQueue.global(qos: .default).async
                                    {
                                        let intervalSecs = 300
                                        var intervalStart = TimeInterval()
                                        var intervalEnd = TimeInterval()
                                        var sdate : NSDate
                                        var edate : NSDate
                                        
                                        var rawStepsData = ""
                                        
                                        for index in 1...288 {
                                            intervalStart = Double(intervalSecs * (index - 1))
                                            intervalEnd = Double(intervalSecs * index)
                                            
                                            sdate = dateFrom.addingTimeInterval(intervalStart)
                                            edate = dateFrom.addingTimeInterval(intervalEnd)
                                            
                                            self._cmPedometer.queryPedometerData(from: sdate as Date, to: edate as Date, withHandler: { data, error in
                                                
                                                DispatchQueue.global(qos: .default).async {
                                                    
                                                    var min : String
                                                    
                                                    //D[5mn];[Steps];[Duration];[Distance];[Kcal];
                                                    
                                                    if index < 10 {
                                                        min = "D00" + "\(index - 1);"
                                                    } else if index < 100 {
                                                        min = "D0" + "\(index - 1);"
                                                    } else {
                                                        min = "D" + "\(index - 1);"
                                                    }
                                                    
                                                    if(error == nil){
                                                        
                                                        rawStepsData = rawStepsData + min + "\(data!.numberOfSteps.intValue);0;" + "\(data!.distance!.intValue);0;"
                                                    }
                                                    else {
                                                        rawStepsData = rawStepsData + min + "0;0;0;0;"
                                                    }
                                                    
                                                    if index == 288 {
                                                        //println(" \(self.rawStepsComputed)")
                                                        DispatchQueue.main.async {
                                                            callback(from, to, steps, distance, duration, startDate, rawStepsData as NSString)
                                                        }
                                                    }
                                                }
                                            })
                                        }
                                }
                            }
                        }
                        
                    #endif
            }
        }
    }
    
    func getStepsToday(callback: @escaping stepCounterData)
    {
        let beginOfDay = CalendarUtil.getFirstHourOfDate(NSDate() as Date)
        
        self.stepsFromDateRange( dateFrom: beginOfDay as NSDate!, dateTo: NSDate()) { (from, to, steps, distance, duration, startDate, rawsteps) -> () in
            DispatchQueue.main.async( execute: {
                callback(from, to, steps, distance, duration, startDate, rawsteps)
            })
        }
    }
    
    func startStepsCounting()
    {
        self.getStepsToday(callback: { (from: NSDate?, to : NSDate?, steps: NSInteger?, distance: NSInteger?, duration: TimeInterval, startDate: NSDate, rawsteps: NSString) -> Void in
            
            self.timeMoving = duration
            self.stepsToday = steps!
            self.stepStartDate = startDate
            self.updateStepsToday()
            
            if steps != 0
            {
                self.isCounting = true
            }else{
                self.isCounting = false
            }
            
        })
    }
    
    func startActivityUpdates()
    {
        if CMMotionActivityManager.isActivityAvailable()
        {
            _cmMotionActivityManager.startActivityUpdates(to: _operationQueue, withHandler:
                { (activity) -> Void in
                    DispatchQueue.main.async( execute: { () -> Void in
                        var previousActivity : CMMotionActivity!
                        
                        if previousActivity != nil
                        {
                            if previousActivity.running || previousActivity.walking || previousActivity.cycling
                            {
                                let timeInterval : Double = activity!.startDate.timeIntervalSince(previousActivity.startDate)
                                
                                self.timeMoving += timeInterval
                            }
                        }
                        previousActivity = activity
                    })
            })
        }
    }
    
    func updateStepsToday()
    {
        let beginOfDay = CalendarUtil.getFirstHourOfDate(NSDate() as Date)
        
        #if arch(i386) || arch(x86_64) && os(iOS)
            
            // Simulator
            
        #else
            
            if CMPedometer.isStepCountingAvailable()
            {
                self._cmPedometer.startUpdates(from: beginOfDay, withHandler: { ( pedometerData, error) -> Void in
                    if error == nil
                    {
                        self.updatePedometerData(pedometerData: pedometerData)
                    }
                })
            } else
            {
                NSLog("Core Motion not supported.")
                self.updatePedometerData(pedometerData: nil)
            }
            
        #endif
    }
    
    func updatePedometerData(pedometerData: CMPedometerData!)
    {
        if pedometerData != nil
        {
            DispatchQueue.main.async( execute:
                {
                    print("numberOfSteps: \(pedometerData.numberOfSteps)")
                    self.stepsToday = NSInteger(exactly: pedometerData.numberOfSteps)!
            })
        }
        else
        {
            self.stepsToday = -1
        }
    }
    
    func stopLiveCounting()
    {
        if !_isLiveCounting
        {
            return
        }
        _cmPedometer.stopUpdates()
        _isLiveCounting = false
    }
    
    @objc func timeChangedSignificantly()
    {
        self.stopLiveCounting()
        self.updateStepsToday()
    }
    
    @objc func willEnterForeground()
    {
        self.updateStepsToday()
    }
    
    @objc func didEnterBackground()
    {
        self.stopLiveCounting()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
}
