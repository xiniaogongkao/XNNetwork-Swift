//
//  XNBaseAPIManager.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit
 
open class XNBaseAPIManager: XNRequestManager, XNRequestConfigutionDelegate, XNRequestDomainConfigutionDelegate, XNRequestParamsDelegate, XNRequestValidatorDelegate, XNRequestCallbackDelegate {
    
    private var params: Dictionary<String, Any>?
    private var uri: XNNetworkDefine.XNRequestURIName = .default
    private var requestMethod: XNAPIRequestType = .post
    
    public override init() {
        super.init()
        self.configutionDelegate = self
        self.domainConfigutionDelegate = self
        self.paramsDelegate = self
        self.validatorDelegate = self
        self.callbackDelegate = self
    }
    
    open func requestURI() -> XNNetworkDefine.XNRequestURIName {
        return self.uri
    }
    
    open func requestType() -> XNAPIRequestType {
        return self.requestMethod
    }
    
    open func requestSerializerType() -> XNAPIRequestSerializerType {
        return .JSON
    }
    
    open func configuration() -> XNAPIConfiguration {
        return XNAPIConfiguration()
    }
    
    open func requestParams() -> Dictionary<String, Any>? {
        return self.params
    }
    
    open func requestHeaders() -> Dictionary<String, String> {
        return [:]
    }
    
    open func callbackDidSuccess(manager: XNRequestManager, json: Dictionary<String, Any>) {
        
    }
    
    open func callbackDidFailed(manager: XNRequestManager, errorModel: XNErrorModel) {
        
    }
    
}

extension XNBaseAPIManager {
    
    @discardableResult
    open func request(uri: XNNetworkDefine.XNRequestURIName, params: Dictionary<String, Any>? = nil, requestMethod: XNAPIRequestType = .post, successBlock: XNAPIRequestSuccessBlock?, failedBlock: XNAPIRequestFailedBlock?) -> Int {
        self.uri = uri
        self.params = params
        self.requestMethod = requestMethod
        return self.startRequest(successBlock: successBlock, failedBlock: failedBlock)
    }
}
