//
//  XNBaseAPIManager.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit

class XNBaseAPIManager: XNRequestManager, XNRequestConfigutionDelegate, XNRequestDomainConfigutionDelegate, XNRequestParamsDelegate, XNRequestValidatorDelegate, XNRequestCallbackDelegate {
    
    private var params: Dictionary<String, Any> = [:]
    private var uri: XNNetworkDefine.XNHtmlURIName = .default
   
    override init() {
        super.init()
        self.configutionDelegate = self
        self.domainConfigutionDelegate = self
        self.paramsDelegate = self
        self.validatorDelegate = self
        self.callbackDelegate = self
    }
    
    func requestURI() -> XNNetworkDefine.XNHtmlURIName {
        return self.uri
    }
    
    func requestType() -> XNAPIRequestType {
        return .post
    }
    
    func requestSerializerType() -> XNAPIRequestSerializerType {
        return .JSON
    }
    
    func configuration() -> XNAPIConfiguration {
        return XNAPIConfiguration()
    }
    
    func requestParams() -> Dictionary<String, Any> {
        return self.params
    }
    
    func requestHeaders() -> Dictionary<String, String> {
        return [:]
    }
    
    func callbackDidSuccess(manager: XNRequestManager, json: Dictionary<String, Any>) {
        
    }
    
    func callbackDidFailed(manager: XNRequestManager, errorModel: XNErrorModel) {
        
    }
    
}

extension XNBaseAPIManager {
    
    @discardableResult
    func request(uri: XNNetworkDefine.XNHtmlURIName, params: Dictionary<String, Any>, successBlock: XNAPIRequestSuccessBlock?, failedBlock: XNAPIRequestFailedBlock?) -> Int {
        self.uri = uri
        self.params = params
        return self.startRequest(successBlock: successBlock, failedBlock: failedBlock)
    }
}
