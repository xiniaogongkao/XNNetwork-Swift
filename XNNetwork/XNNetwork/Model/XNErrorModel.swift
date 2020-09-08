//
//  XNErrorModel.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit

public class XNErrorModel: NSObject, Error {
    public var status: Int?
    public var message: String?
    public var errorType: XNAPIManagerErrorType?
    public var response: HTTPURLResponse?
    
    convenience init(errorType: XNAPIManagerErrorType, response: HTTPURLResponse?) {
        self.init()
        self.errorType = errorType
        self.response = response
        if self.status == 200 && self.errorType == .JSONError {
            self.message = "JSON解析失败"
        } else {
            self.message = HTTPURLResponse.localizedString(forStatusCode: response?.statusCode ?? 0)
        }
    }
    
    convenience init(status: Int, message: String, response: HTTPURLResponse?) {
        self.init()
        self.status = status
        self.message = message
        self.response = response
        self.errorType = .callError
    }
}
