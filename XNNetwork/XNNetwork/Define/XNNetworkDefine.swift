//
//  XNNetworkDefine.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit

class XNNetworkDefine: NSObject {}

extension XNNetworkDefine {
    
    public struct XNConfigKey : Hashable, Equatable, RawRepresentable {
        public var rawValue: String
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(rawValue: String) {
            self.init(rawValue)
        }
    }
    
    
    public struct XNRequestURIName : Hashable, Equatable, RawRepresentable {
        public var rawValue: String
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(rawValue: String) {
            self.init(rawValue)
        }
        
        static let `default` = XNRequestURIName(rawValue: "")
    }
    
    public struct XNHtmlURIName : Hashable, Equatable, RawRepresentable {
        public var rawValue: String
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(rawValue: String) {
            self.init(rawValue)
        }
        
        static let `default` = XNHtmlURIName(rawValue: "")
    }
    
    public struct XNDomainName : Hashable, Equatable, RawRepresentable {
        public var rawValue: String
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(rawValue: String) {
            self.init(rawValue)
        }
        #if DEBUG
        static let `default` = XNDomainName(rawValue: "http://apitest.xiniaogongkao.com")
        #else
        static let `default` = XNDomainName(rawValue: "http://apitest.xiniaogongkao.com")
        #endif
    }
    
    public struct XNNetworkKey : Hashable, Equatable, RawRepresentable {
        public var rawValue: String
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(rawValue: String) {
            self.init(rawValue)
        }
        
        /*
        默认成功响应结构为
        {
           "status" : xx,
           "message" : xx,
           "data" : {
        
           }
        }
        当data为数组，既 "data" : [] 时，将转为
        "data" : {
           "list" : []
        }
        当data为字符串或数字，既 "data" : xx 时，将转为
        "data" : {
           "value" : xx
        }
        保持结构固定，以便拓展处理
        */
        static let list = XNNetworkKey(rawValue: "list")
        static let value = XNNetworkKey(rawValue: "value")
    }
}


