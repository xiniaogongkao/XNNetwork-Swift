//
//  XNNetworkEnum.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit
import Alamofire

public enum XNAPIResposeStatus {
    case success
    case noLogged
    case invalidToken
    case notFound
    case serviceError
    case otherError
}

public enum XNAPIManagerErrorType: Int, Encodable {
    case `default` = -100
    case JSONError = -200
    case paramsError = -300
    case timeout = -400
    case networkError = -500
    case notNetwork = -600
    case serverError = -700
    case cancel = -800
    case callError = -9999
}

public enum XNAPIRequestType {
    case get
    case post
    
    func transToHTTPMethod() -> Alamofire.HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        }
    }
}

public enum XNAPIRequestSerializerType {
    case JSON
    case HTTP
    
    func transToParameterEncoding() -> ParameterEncoding {
        switch self {
        case .JSON:
            return JSONEncoding.default
        case .HTTP:
            return URLEncoding.default
        }
    }
}
