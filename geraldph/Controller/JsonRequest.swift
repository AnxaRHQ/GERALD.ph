//
//  JsonRequest.swift
//  geraldph
//
//  Created by Elaine Reyes on 1/9/18.
//  Copyright © 2018 HAPILABS LIMITED. All rights reserved.
//

import UIKit

class JsonRequest: NSObject
{
    //MARK: Shared Instance
    
    static let sharedInstance : JsonRequest =
    {
        let instance = JsonRequest()
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init()
    {
        super.init()
    }
    
    // MARK: - Anxamats
    
    func anxamatsJson(duration : TimeInterval, logDetails : NSString, logTime : Double) -> NSMutableDictionary
    {
        let main                    = NSMutableDictionary()
        main["application_id"]      = anxamatsApplicationID
        main["event_id"]            = 1            // constant value for user time spent
        main["event_value"]         = Int(duration)
        main["log_details"]         = logDetails
        
        return main
    }
}
