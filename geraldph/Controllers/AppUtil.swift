//
//  AppUtil.swift
//  geraldph
//
//  Created by Elaine Reyes on 2/14/18.
//  Copyright © 2018 HAPILABS LIMITED. All rights reserved.
//

import UIKit

class AppUtil: NSObject
{
    // MARK: Shared Instance
    
    static let sharedInstance : AppUtil =
    {
        let instance = AppUtil()
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init()
    {
        super.init()
    }
    
    // MARK: - Encode Signature
    
    class func encodeSignature(_ parameters: String, withSharedKey sharedKey: String) -> String
    {
        var input: String
        
        if !sharedKey.isEmpty
        {
            input = "\(parameters)\(sharedKey)"
        }
        else
        {
            input = parameters
        }
        let cstr = input.cString(using: String.Encoding.utf8)
        let data = NSData(bytes: cstr, length: input.count)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = digest.map { String(format: "%02x", $0) }
        return hexBytes.joined()
    }
}
