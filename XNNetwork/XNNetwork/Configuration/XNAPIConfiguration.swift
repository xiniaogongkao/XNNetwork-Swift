//
//  XNAPIConfiguration.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit

/// 兼容同域名下key不同的情况
class XNAPIResposeKeyModel: NSObject {
    var statusKeys: Array<String>
    var messageKeys: Array<String>
    var dataKeys: Array<String>
    
    init(statusKeys: Array<String>, messageKeys: Array<String>, dataKeys: Array<String>) {
        self.statusKeys = statusKeys
        self.messageKeys = messageKeys
        self.dataKeys = dataKeys
    }
}

class XNAPIResposeStatusModel: NSObject {
    var type: XNAPIResposeStatus = .otherError
    var status: Int = -1
    
    convenience init(type: XNAPIResposeStatus, status: Int) {
        self.init()
        self.type = type
        self.status = status
    }
    
}

class XNAPIConfiguration: NSObject {
    /// 域名
    var domain: XNNetworkDefine.XNDomainName = .default
    /// 通用header参数设置
    var header: Dictionary<String, String> = [:]
    /// 通用body参数设置
    var body: Dictionary<String, Any> = [:]
    /// 超时时间，单位秒
    var timeout: TimeInterval = 15
    /// 响应体最外层的key，兼容不同域名下key值不同
    var keyModel: XNAPIResposeKeyModel = XNAPIResposeKeyModel(statusKeys: ["code", "status"], messageKeys: ["message", "msg"], dataKeys: ["data"])
    var statusConfigs: Array<XNAPIResposeStatusModel> = [XNAPIResposeStatusModel(type: .success, status: 100)]
    
    private var configurations: Dictionary<XNNetworkDefine.XNDomainName, XNAPIConfiguration?> = [:]
    
    private static let shared = XNAPIConfiguration()
    
    class func registerConfiguration(_ configuration: XNAPIConfiguration) {
        if configuration.domain.rawValue.count == 0 {
            print("\(#function)_必须声明域名")
            return
        }
        self.shared.configurations[configuration.domain] = configuration
    }
    
    class func configuration(domain: XNNetworkDefine.XNDomainName) -> XNAPIConfiguration? {
        return self.shared.configurations[domain] as? XNAPIConfiguration
    }
    
    ///根据状态码返回XNAPIResposeStatusModel
    func resposeStatusModelFromStatus(_ status: Int, domain: XNAPIResposeStatusModel? = nil) -> XNAPIResposeStatusModel {        
        /// 先去配置里面找
        for m in self.statusConfigs {
            if m.status == status {
                return m
            }
        }
        return XNAPIResposeStatusModel()
    }
    
}
