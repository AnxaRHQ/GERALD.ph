//
//  SessionHTTPClient.swift
//  geraldph
//
//  Created by Elaine Reyes on 1/9/18.
//  Copyright © 2018 HAPILABS LIMITED. All rights reserved.
//

import UIKit
import AFNetworking

class SessionHTTPClient : AFHTTPSessionManager
{
    // MARK: - Delegate
    
    var delegate : SessionHTTPClientDelegate?
    
    // MARK: Shared Instance
    
    class func sharedSessionHTTPClient() -> SessionHTTPClient
    {
        var sharedInstance: SessionHTTPClient? = nil
        
        sharedInstance = self.init(baseURL: URL(string: anxamatsLiveURL))
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
    
    // MARK: - Send Session Time
    
    func sendSessionTime(duration : TimeInterval, logDetails : NSString, logTime : Double)
    {
        print("\(#function)")
        
        let manager : SessionHTTPClient = SessionHTTPClient.sharedSessionHTTPClient()
        
        let parameter : NSMutableDictionary = JsonRequest.sharedInstance.anxamatsJson(duration: duration, logDetails: logDetails, logTime: logTime)
        
        print("parameter: \(String(describing: parameter))")
        
        let jsonSerializer = AFJSONRequestSerializer()
        jsonSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = jsonSerializer
        
        manager.post("anxamats/logger", parameters: parameter, progress: nil, success: { (operation: URLSessionDataTask, responseObject: Any?) in
            
            print("\(#function) ___ \(String(describing: responseObject))")
            
            self.delegate?.SessionHTTPClient(sender: self, didSendDataWithDetail: logDetails, logTime: logTime)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) in
            
            let errorMessage : Error = error! as Error
            
            print("\(#function) ___ \(errorMessage.localizedDescription)")
            
            self.delegate?.SessionHTTPClient(sender: self, didFailWithError: errorMessage.localizedDescription as NSString)
        })
    }
}

// MARK: - SessionHTTPClientDelegate

protocol SessionHTTPClientDelegate
{
    func SessionHTTPClient(sender: SessionHTTPClient, didSendDataWithDetail success: NSString, logTime: Double)
    func SessionHTTPClient(sender: SessionHTTPClient, didFailWithError error: NSString)
}
