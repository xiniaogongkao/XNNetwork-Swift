//
//  XNAPIConfiguration.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit

/// 兼容同域名下key不同的情况
public class XNAPIResposeKeyModel: NSObject {
    var statusKeys: Array<String>
    var messageKeys: Array<String>
    var dataKeys: Array<String>
    
    public init(statusKeys: Array<String>, messageKeys: Array<String>, dataKeys: Array<String>) {
        self.statusKeys = statusKeys
        self.messageKeys = messageKeys
        self.dataKeys = dataKeys
    }
}

public class XNAPIResposeStatusModel: NSObject {
    var type: XNAPIResposeStatus = .otherError
    var status: Int = -1
    
    convenience init(type: XNAPIResposeStatus, status: Int) {
        self.init()
        self.type = type
        self.status = status
    }
    
}

public class XNAPIConfiguration: NSObject {
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
    
    private let k = "XNAPIConfiguration_k"
    /// 记录key值与域名值得对应关系，调试模式会根据此属性更改key所对应的config的域名值
    private var debugRecord: Dictionary<String, String> {
        get {
            return UserDefaults.standard.value(forKey: k) as? Dictionary<String, String> ?? [:]
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: k)
        }
    }
    
    private var debugOriginRecord: Dictionary<String, String> = [:]
    
    private var configurations: Dictionary<XNNetworkDefine.XNConfigKey, XNAPIConfiguration> = [:]
    
    private static let shared = XNAPIConfiguration()
    
    class func registerConfiguration(_ configuration: XNAPIConfiguration, key: XNNetworkDefine.XNConfigKey) {
        if configuration.domain.rawValue.count == 0 {
            print("\(#function)_必须声明域名")
            return
        }
        self.shared.debugOriginRecord[key.rawValue] = configuration.domain.rawValue
        self.shared.configurations[key] = configuration
    }
    
    class func configuration(key: XNNetworkDefine.XNConfigKey) -> XNAPIConfiguration? {
        let config = self.shared.configurations[key]
        #if DEBUG
        if let keyValue = config?.debugRecord[key.rawValue] {
            config?.domain.rawValue = keyValue
        } else if let keyValue = config?.debugOriginRecord[key.rawValue] {
            config?.domain.rawValue = keyValue
        }
        #endif
        return config
    }
    
    class func configuration(domain: XNNetworkDefine.XNDomainName) -> XNAPIConfiguration? {
        for config in self.shared.configurations.values {
            if config.domain.rawValue == domain.rawValue {
                return config
            }
        }
        return XNAPIConfiguration()
    }
    
    /// 所有配置
    /// - Returns: 所有配置
    class func all() -> Dictionary<XNNetworkDefine.XNConfigKey, XNAPIConfiguration> {
        return self.shared.configurations
    }
    
    /// 清除调试key值与domain值
    class func debug_clean() {
        let config = self.shared
        config.debugRecord = [:]
    }
    
     /// 高边调试key值与domain值
    class func debug_change(key: String, domain: String) {
        let config = self.shared
        var dict = config.debugRecord
        dict[key] = domain
        config.debugRecord = dict
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
