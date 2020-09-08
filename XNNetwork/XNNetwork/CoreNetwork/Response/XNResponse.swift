//
//  XNResponse.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit

public class XNResponse: NSObject {
    public var response: HTTPURLResponse?
    public var responseObject: Data?
    public var error: Error?
    
    public init(response: HTTPURLResponse?, responseObject: Data?, error: Error?) {
        self.response = response
        self.responseObject = responseObject
        self.error = error
    }
    
}
