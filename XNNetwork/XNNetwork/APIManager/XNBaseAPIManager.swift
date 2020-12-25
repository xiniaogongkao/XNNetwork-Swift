//
//  XNBaseAPIManager.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit
 
open class XNBaseAPIManager: XNRequestManager, XNRequestConfigutionDelegate, XNRequestDomainConfigutionDelegate, XNRequestParamsDelegate, XNRequestValidatorDelegate, XNRequestCallbackDelegate {
    
    public private(set) var params: Dictionary<String, Any>?
    public private(set) var uri: XNNetworkDefine.XNRequestURIName = .default
    public private(set) var requestMethod: XNAPIRequestType = .post
    
    private var sharedMap: Dictionary<TimeInterval, XNBaseAPIManager?> = [:]
    public var isShared = false
    
    public required override init() {
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
    
    public func callbackFilterDidFailed(manager: XNRequestManager, errorModel: XNErrorModel) -> Bool {
        return true
    }
    
    public func callbackFilterDidSuccess(manager: XNRequestManager, json: Dictionary<String, Any>) -> Bool {
        return true
    }
    
}

extension XNBaseAPIManager {
    
    @discardableResult
    open func request(uri: XNNetworkDefine.XNRequestURIName, params: Dictionary<String, Any>? = nil, requestMethod: XNAPIRequestType = .post, successBlock: XNAPIRequestSuccessBlock?, failedBlock: XNAPIRequestFailedBlock?) -> Int {
        let key = Date().timeIntervalSince1970
        var manager: XNBaseAPIManager
        if self.isShared {
            manager = type(of: self).init()
            self.sharedMap[key] = manager
        } else {
            manager = self
        }
        manager.uri = uri
        manager.params = params
        manager.requestMethod = requestMethod
        return manager.startRequest(successBlock: { [weak self] (manager, json) in
            successBlock?(manager, json)
            self?.sharedMap.removeValue(forKey: key)
        }) { [weak self] (manager, errorModel) in
            failedBlock?(manager, errorModel)
            self?.sharedMap.removeValue(forKey: key)
        }
    }
}
