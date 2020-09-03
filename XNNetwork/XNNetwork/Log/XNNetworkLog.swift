//
//  XNNetworkLog.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit

class XNNetworkLog: NSObject {
    class func logRequestInfo(uri: String, params: Dictionary<String, Any>) {
        print("------------ Request Info --------------")
        self.logURI(uri)
        self.logParams(params)
    }
    
    class func logResponseInfo(uri: String, params: Dictionary<String, Any>) {
        print("------------ Response Info --------------")
        self.logURI(uri)
        self.logParams(params)
    }
    
    class func logErrorModel(_ errorModel: XNErrorModel, uri: String) {
        print("------------ Error Info --------------")
        self.logURI(uri)
        let dict: [String : Any] = [
            "errorType" : (errorModel.errorType ?? .default).rawValue,
            "status" : errorModel.status ?? 0,
            "message" : errorModel.message ?? "无",
            "response.statusCode" : errorModel.response?.statusCode ?? 0,
            "response.message" : HTTPURLResponse.localizedString(forStatusCode: errorModel.response?.statusCode ?? 0)
            ]
        self.logParams(dict)
    }
    
    class func logURI(_ uri: String) {
        print("URI: >> \(uri)")
    }
    
    class func logParams(_ params: Dictionary<String, Any>) {
        let str = params.jsonString(isPrettyPrint: true)
        print("\(str)")
    }
}
