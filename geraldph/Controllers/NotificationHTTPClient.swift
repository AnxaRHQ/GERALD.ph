//
//  NotificationHTTPClient.swift
//  geraldph
//
//  Created by Elaine Reyes on 2/14/18.
//  Copyright © 2018 HAPILABS LIMITED. All rights reserved.
//

import UIKit
import AFNetworking

class NotificationHTTPClient: AFHTTPSessionManager
{
    // MARK: Shared Instance
    
    class func sharedNotificationHTTPClient() -> NotificationHTTPClient
    {
        var sharedInstance: NotificationHTTPClient? = nil
        
        sharedInstance = self.init(baseURL: URL(string: anxaPuncLiveURL))
        let operationQueue: OperationQueue? = sharedInstance?.operationQueue
        sharedInstance?.reachabilityManager.setReachabilityStatusChange({(status: AFNetworkReachabilityStatus) -> Void in
            switch status {
            case AFNetworkReachabilityStatus.reachableViaWWAN, AFNetworkReachabilityStatus.reachableViaWiFi:
                operationQueue?.isSuspended = false
            default:
                operationQueue?.isSuspended = true
            }
        })
        
        return sharedInstance!
    }
    
    func sendDeviceToken(token: NSString, pushNotificationEnabled isEnabled: Bool)
    {
        let parameters              = NSMutableDictionary()
        parameters["appVersion"]    = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        
        if let regID : String       = UserDefaults.standard.object(forKey: "regID") as? String
        {
            parameters["userID"]    = regID
        }
        else
        {
            parameters["userID"]    = 0
        }
        
        parameters["userFirstName"] = nil
        parameters["userLastName"]  = nil
        parameters["isNotificationEnabled"] = isEnabled ? "true" : "false"
        
        print("parameters: \(parameters)")
        
        let bundleID                = Bundle.main.bundleIdentifier
        let parameterForSignature   = NSString(format:"%@%@",bundleID!, token)
        let signature               = AppUtil.encodeSignature(parameterForSignature as String, withSharedKey: sharedKey_AnxaPunc)
        
        let postURL                 = NSString(format:"Register/UserDevice?appId=%@&deviceToken=%@&signature=%@",bundleID!, token, signature)
        
        print("postURL: \(postURL)")
        
        let manager : NotificationHTTPClient = NotificationHTTPClient.sharedNotificationHTTPClient()
        
        let jsonSerializer = AFJSONRequestSerializer()
        jsonSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = jsonSerializer
        
        manager.post(postURL as String, parameters: parameters, progress: nil, success: { (operation: URLSessionDataTask, responseObject: Any?) in
            
            print("Success: \(#function)")
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) in
            
            let errorMessage : Error = error! as Error
            
            print("Error: \(#function) ___ \(errorMessage.localizedDescription)")
        })
    }
}
