//
//  XNBaseAPIManager.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit
 
public class XNBaseAPIManager: XNRequestManager, XNRequestConfigutionDelegate, XNRequestDomainConfigutionDelegate, XNRequestParamsDelegate, XNRequestValidatorDelegate, XNRequestCallbackDelegate {
    
    public var params: Dictionary<String, Any>?
    public var uri: XNNetworkDefine.XNRequestURIName = .default
   
    override init() {
        super.init()
        self.configutionDelegate = self
        self.domainConfigutionDelegate = self
        self.paramsDelegate = self
        self.validatorDelegate = self
        self.callbackDelegate = self
    }
    
    public func requestURI() -> XNNetworkDefine.XNRequestURIName {
        return self.uri
    }
    
    public func requestType() -> XNAPIRequestType {
        return .post
    }
    
    public func requestSerializerType() -> XNAPIRequestSerializerType {
        return .JSON
    }
    
    public func configuration() -> XNAPIConfiguration {
        return XNAPIConfiguration()
    }
    
    public func requestParams() -> Dictionary<String, Any>? {
        return self.params
    }
    
    public func requestHeaders() -> Dictionary<String, String> {
        return [:]
    }
    
    public func callbackDidSuccess(manager: XNRequestManager, json: Dictionary<String, Any>) {
        
    }
    
    public func callbackDidFailed(manager: XNRequestManager, errorModel: XNErrorModel) {
        
    }
    
}

extension XNBaseAPIManager {
    
    @discardableResult
    public func request(uri: XNNetworkDefine.XNRequestURIName, params: Dictionary<String, Any>? = nil, successBlock: XNAPIRequestSuccessBlock?, failedBlock: XNAPIRequestFailedBlock?) -> Int {
        self.uri = uri
        self.params = params
        return self.startRequest(successBlock: successBlock, failedBlock: failedBlock)
    }
}
