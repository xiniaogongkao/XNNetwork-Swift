//
//  XNNetworkLog.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit

class XNNetworkLog: NSObject {
    class func logRequestInfo(domain: String, uri: String, params: Dictionary<String, Any>) {
        print("------------ Request Info --------------")
        logDomain(domain)
        logURI(uri)
        logParams(params)
    }
    
    class func logResponseInfo(domain: String, uri: String, params: Dictionary<String, Any>) {
        print("------------ Response Info --------------")
        logDomain(domain)
        logURI(uri)
        logParams(params)
    }
    
    class func logErrorModel(_ errorModel: XNErrorModel, domain: String, uri: String) {
        print("------------ Error Info --------------")
        logDomain(domain)
        logURI(uri)
        let dict: [String : Any] = [
            "errorType" : (errorModel.errorType ?? .default).rawValue,
            "status" : errorModel.status ?? 0,
            "message" : errorModel.message ?? "无",
            "response.statusCode" : errorModel.response?.statusCode ?? 0,
            "response.message" : HTTPURLResponse.localizedString(forStatusCode: errorModel.response?.statusCode ?? 0)
            ]
        logParams(dict)
    }
    
    class func logDomain(_ domain: String) {
        print("Domain: >> \(domain)")
    }
    
    class func logURI(_ uri: String) {
        print("URI: >> \(uri)")
    }
    
    class func logParams(_ params: Dictionary<String, Any>) {
        let str = params.jsonString(isPrettyPrint: true)
        print("\(str)")
    }
}
