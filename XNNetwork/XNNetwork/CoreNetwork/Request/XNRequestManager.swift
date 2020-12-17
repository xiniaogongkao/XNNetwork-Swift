//
//  XNRequestManager.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit

public typealias XNAPIRequestSuccessBlock = (XNRequestManager, Dictionary<String, Any>) -> ()

public typealias XNAPIRequestFailedBlock = (XNRequestManager, XNErrorModel) -> ()

/// 基本配置设置，针对单个请求
public protocol XNRequestConfigutionDelegate: NSObjectProtocol {
    func requestURI() -> XNNetworkDefine.XNRequestURIName
    func requestType() -> XNAPIRequestType
    func requestSerializerType() -> XNAPIRequestSerializerType
    
    func shouldCache() -> Bool
    
    @discardableResult
    func saveCacheFromJson(_ json: Dictionary<String, Any>) -> Bool
    func jsonFromCache() -> Dictionary<String, Any>?
}

extension XNRequestConfigutionDelegate {
    public func shouldCache() -> Bool {
        return false
    }
    
    public func saveCacheFromJson(_ json: Dictionary<String, Any>) -> Bool {
        return false
    }
    
    public func jsonFromCache() -> Dictionary<String, Any>? {
        return nil
    }
}

/// 域名下的配置
public protocol XNRequestDomainConfigutionDelegate: NSObjectProtocol {
    func configuration() -> XNAPIConfiguration
}

/// 参数设置
public protocol XNRequestParamsDelegate: NSObjectProtocol {
    func requestParams() -> Dictionary<String, Any>?
    func requestHeaders() -> Dictionary<String, String>
}

public protocol XNRequestValidatorDelegate: NSObjectProtocol {
    func validateParams() -> Bool
}

extension XNRequestValidatorDelegate {
    public func validateParams() -> Bool {
        return true
    }
}

/// 请求回调代理
public protocol XNRequestCallbackDelegate: NSObjectProtocol {
    func callbackDidSuccess(manager: XNRequestManager, json: Dictionary<String, Any>)
    
    func callbackDidFailed(manager: XNRequestManager, errorModel: XNErrorModel)
    
    func callbackFilterDidSuccess(manager: XNRequestManager, json: Dictionary<String, Any>) -> Bool
    
    func callbackFilterDidFailed(manager: XNRequestManager, errorModel: XNErrorModel) -> Bool
}

extension XNRequestCallbackDelegate {
    public func callbackFilterDidSuccess(manager: XNRequestManager, json: Dictionary<String, Any>) -> Bool {
        return true
    }
    
    public func callbackFilterDidFailed(manager: XNRequestManager, errorModel: XNErrorModel) -> Bool {
        return true
    }
}

open class XNRequestManager: NSObject {
    
    weak var configutionDelegate: XNRequestConfigutionDelegate!
    weak var domainConfigutionDelegate: XNRequestDomainConfigutionDelegate!
    weak var paramsDelegate: XNRequestParamsDelegate!
    weak var validatorDelegate: XNRequestValidatorDelegate!
    weak var callbackDelegate: XNRequestCallbackDelegate!

    private var requestIDs: Array<Int> = []
    
    private var successBlock: XNAPIRequestSuccessBlock?
    
    private var failedBlock: XNAPIRequestFailedBlock?
    
    public var message: String?
    
    @discardableResult
    public func startRequest(successBlock: XNAPIRequestSuccessBlock? = nil, failedBlock: XNAPIRequestFailedBlock? = nil) -> Int {
        self.successBlock = successBlock
        self.failedBlock = failedBlock
        
        var requestID = 0
        
        if self.validatorDelegate.validateParams() == false {
            self.dispatchFailResult(errorModel: XNErrorModel(errorType: .paramsError, response: nil))
            return requestID
        }
        
        if self.configutionDelegate.shouldCache(), let cacheJson = self.configutionDelegate.jsonFromCache() {
            self.callbackDelegate.callbackDidSuccess(manager: self, json: cacheJson)
            self.successBlock?(self, cacheJson)
            return requestID
        }
        
        let type = self.configutionDelegate.requestType()
        
        let rType = self.configutionDelegate.requestSerializerType()
        
        let domain = self.domainConfigutionDelegate.configuration().domain
        
        let uri = self.configutionDelegate.requestURI()
        
        let headers = self.domainConfigutionDelegate.configuration().header.merging(self.paramsDelegate.requestHeaders(), uniquingKeysWith: {$1})
        
        let params = self.domainConfigutionDelegate.configuration().body.merging(self.paramsDelegate.requestParams() ?? [:], uniquingKeysWith: {$1})
    
        XNNetworkLog.logRequestInfo(domain: domain.rawValue, uri: uri.rawValue, params: params)
        
        requestID = XNNetworkAgent.shared.request(type: type, requestSerializerType: rType, headers: headers, params: params, domain: domain, uri: uri, success: { [weak self] (response) in
            self?.remove(requestID: requestID)
            self?.success(response: response)
        }) { [weak self] (response) in
            self?.remove(requestID: requestID)
            self?.fail(response: response)
        }
        self.requestIDs.append(requestID)
        return requestID
    }
    
    public func cancelAllRequest() {
        XNNetworkAgent.shared.cancelAllRequest()
        self.requestIDs.removeAll()
    }
    
    public func cancelRequest(requestID: Int) {
        XNNetworkAgent.shared.cancelRequest(requestID: requestID)
        self.requestIDs.remove(at: requestID)
    }
    
}

extension XNRequestManager {
    private func success(response: XNResponse) {
        guard let data = response.responseObject else {
            self.dispatchFailResult(errorModel: XNErrorModel(errorType: .JSONError, response: response.response))
            return
        }
        
        var jsonObject: Any?
        do {
            jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch {}
        
        guard let jsonDict = jsonObject as? Dictionary<String, Any> else {
            self.dispatchFailResult(errorModel: XNErrorModel(errorType: .JSONError, response: response.response))
            return
        }
      
        let status = Int("\(self.findValue(dict: jsonDict, keys: self.domainConfigutionDelegate.configuration().keyModel.statusKeys))") ?? 0
        
        let message = "\(self.findValue(dict: jsonDict, keys: self.domainConfigutionDelegate.configuration().keyModel.messageKeys))"
        
        self.message = message
        
        var warpJsonDict: Dictionary<String, Any> = [:]
        
        let obj = self.findValue(dict: jsonDict, keys: self.domainConfigutionDelegate.configuration().keyModel.dataKeys)
        
        if obj is Array<Any> {
            warpJsonDict[XNNetworkDefine.XNNetworkKey.list.rawValue] = obj
        } else if obj is Dictionary<String, Any> {
            warpJsonDict = obj as! Dictionary<String, Any>
        } else {
            warpJsonDict[XNNetworkDefine.XNNetworkKey.value.rawValue] = obj
        }
        
        if self.resposeStatus(status: status) == .success {
            XNNetworkLog.logResponseInfo(domain: self.domainConfigutionDelegate.configuration().domain.rawValue, uri: self.configutionDelegate.requestURI().rawValue, params: warpJsonDict)
            
            let isPass = self.callbackDelegate.callbackFilterDidSuccess(manager: self, json: warpJsonDict)
            if isPass == false {
                return
            }
            
            self.callbackDelegate.callbackDidSuccess(manager: self, json: warpJsonDict)
            if self.successBlock != nil {
                self.successBlock?(self, warpJsonDict)
                self.successBlock = nil
                self.failedBlock = nil
            }
            
            if self.configutionDelegate.shouldCache() {
                self.configutionDelegate.saveCacheFromJson(warpJsonDict)
            }
        } else {
            self.dispatchFailResult(errorModel: XNErrorModel(status: status, message: message, response: response.response))
        }
        
    }
    
    /// 从配置的最外部结构中找到相应的值
    /// - Parameter dict: jsonDictionary
    private func findValue(dict: Dictionary<String, Any>, keys: Array<String>) -> Any {
        for key in keys {
            if dict[key] != nil {
                return dict[key]!
            }
        }
        return ""
    }
    
    private func remove(requestID: Int) {
        for (index, id) in self.requestIDs.enumerated() {
            if id.isMultiple(of: requestID) {
                self.requestIDs.remove(at: index)
                break
            }
        }
    }
    
    private func fail(response: XNResponse) {
        let status = response.response?.statusCode ?? 0
        if status != 200 && status > 0 {
            self.dispatchFailResult(errorModel: XNErrorModel(errorType: .serverError, response: response.response))
        } else {
            guard let errorCode = response.error?._code else { return }
            switch errorCode {
            case NSURLErrorTimedOut:
                self.dispatchFailResult(errorModel: XNErrorModel(errorType: .timeout, response: response.response))
            case NSURLErrorCancelled:
                self.dispatchFailResult(errorModel: XNErrorModel(errorType: .cancel, response: response.response))
            case NSURLErrorCannotConnectToHost: fallthrough
            case NSURLErrorBadURL: fallthrough
            case NSURLErrorUnsupportedURL: fallthrough
            case NSURLErrorCannotFindHost: fallthrough
            case NSURLErrorNetworkConnectionLost: fallthrough
            case NSURLErrorDNSLookupFailed: fallthrough
            case NSURLErrorNotConnectedToInternet:
                self.dispatchFailResult(errorModel: XNErrorModel(errorType: .networkError, response: response.response))
            default:
                self.dispatchFailResult(errorModel: XNErrorModel(errorType: .default, response: response.response))
            }
        }
    }
    
    private func resposeStatus(status: Int) -> XNAPIResposeStatus {
        return self.domainConfigutionDelegate.configuration().resposeStatusModelFromStatus(status).type
    }
    
    private func dispatchFailResult(errorModel: XNErrorModel) {
        if self.callbackDelegate.callbackFilterDidFailed(manager: self, errorModel: errorModel) == false {
            return
        }
        XNNetworkLog.logErrorModel(errorModel, domain: self.domainConfigutionDelegate.configuration().domain.rawValue, uri: self.configutionDelegate.requestURI().rawValue)
        
        self.callbackDelegate.callbackDidFailed(manager: self, errorModel: errorModel)
        self.failedBlock?(self, errorModel)
        self.failedBlock = nil
        self.successBlock = nil
    }
}
