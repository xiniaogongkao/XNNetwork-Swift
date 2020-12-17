//
//  XNTestAPIManager.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/3.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

class XNTestAPIManager: XNBaseAPIManager {

    ///可通过单利、代理两种形式，单利发起请求是 request 方法
    static var shared: XNTestAPIManager = {
        let manager = XNTestAPIManager()
        manager.isShared = true
        return manager
    }()
    
    override func configuration() -> XNAPIConfiguration {
        return XNAPIConfiguration.configuration(key: .testConfigKey) ?? XNAPIConfiguration()
    }
    
    ///针对域名通用的可以写在config中
    override func requestHeaders() -> Dictionary<String, String> {
        return ["xntoken" : "39584ee545afab8a699d44e2cace6c7a",
                "version" : "4.0.7",
                "platform": "2",
                "deviceid": "B193A668-E82A-4D09-AAC9-E8A14663DF6D",
                "model"   : "iPhone 6s",
                "userId"  : "0",
                "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NTk1MDg0MDEsInVpZCI6MTIyfQ.9Q5B_KC_VrnyfXi8a6Qrn8b62V3x8yT7cGRpKV13rIg"
        ]
    }
}

///写在通用配置中
extension XNNetworkDefine.XNRequestURIName {
    static let testUri = XNNetworkDefine.XNRequestURIName(rawValue: "/appRecordWareLearnTime")
    static let testUri2 = XNNetworkDefine.XNRequestURIName(rawValue: "/code/course/courseIndexBanner")
}

extension XNNetworkDefine.XNConfigKey {
    static let testConfigKey = XNNetworkDefine.XNConfigKey(rawValue: "testConfigKey")
}
