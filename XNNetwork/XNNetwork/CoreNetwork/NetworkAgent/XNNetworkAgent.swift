//
//  XNNetworkAgent.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit
import Alamofire

typealias XNNetworkCallBack = (XNResponse) -> ()

public class XNNetworkAgent: NSObject {
    static let shared = XNNetworkAgent()
    
    private var dispatchTable: Dictionary<Int, DataRequest> = [:]
    
    private let session = SessionManager(configuration: URLSessionConfiguration.default)
    
    @discardableResult
    func request(type: XNAPIRequestType, requestSerializerType: XNAPIRequestSerializerType, headers: Dictionary<String, String>, params: Dictionary<String, Any>, domain: XNNetworkDefine.XNDomainName, uri: XNNetworkDefine.XNRequestURIName, success: XNNetworkCallBack? = nil, fail: XNNetworkCallBack? = nil) -> Int {
        
        guard let config = XNAPIConfiguration.configuration(domain: domain) else {
            print("\(#function)_error_域名未注册")
            return 0
        }
        
        let url = "\(domain.rawValue)/\(uri.rawValue)".replacingOccurrences(of: "//", with: "/")
        let method = type.transToHTTPMethod()
        let encoding = requestSerializerType.transToParameterEncoding()
        
        guard let r = try? URLRequest(url: url, method: method, headers: headers), var request = try? encoding.encode(r, with: params) else { return 0 }
        request.timeoutInterval = config.timeout
        let dataRequest = session.request(request)
        
        dataRequest.responseJSON { [weak self] (response) in
            guard let `self` = self else { return }
            self.dispatchTable.removeValue(forKey: dataRequest.task?.taskIdentifier ?? 0)
            let resp = XNResponse(response: response.response, responseObject: response.data, error: response.error)
            switch response.result {
            case .success:
                success?(resp)
                break
            case .failure:
                fail?(resp)
                break
            }
        }
        
        let taskIdentifier: Int = (dataRequest.task?.taskIdentifier) ?? 0
        if taskIdentifier > 0 {
            self.dispatchTable[taskIdentifier] = dataRequest
        }
        
        return taskIdentifier
    }
    
    func cancelRequest(requestID: Int) {
        guard let request: DataRequest = self.dispatchTable[requestID] else {
            return
        }
        request.cancel()
        self.dispatchTable.removeValue(forKey: requestID)
    }
    
    func cancelRequest(requestIDs: Array<Int>) {
        for i in requestIDs {
            self.cancelRequest(requestID: i)
        }
    }
    
    func cancelAllRequest() {
        SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach({ (task) in
                task.cancel()
            })
        }
        self.dispatchTable.removeAll()
    }
}
