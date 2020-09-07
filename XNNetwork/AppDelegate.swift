//
//  AppDelegate.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/8/25.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let s = Alamofire.SessionManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let config = XNAPIConfiguration()
        config.domain = XNNetworkDefine.XNDomainName(rawValue: "http://appformal.xiniaogongkao.com")
        config.keyModel = XNAPIResposeKeyModel(statusKeys: ["code", "status"], messageKeys: ["message", "msg"], dataKeys: ["data"])
        config.statusConfigs = [XNAPIResposeStatusModel(type: .success, status: 100), XNAPIResposeStatusModel(type: .success, status: 200)]

        XNAPIConfiguration.registerConfiguration(config, key: .testConfigKey)

        print("\(XNAPIConfiguration.all())")
        
        XNTestAPIManager.shared.request(uri: .testUri, params: nil, successBlock: { (manager, json) in
            
        }) { (manager, errorModel) in
            
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle


}

