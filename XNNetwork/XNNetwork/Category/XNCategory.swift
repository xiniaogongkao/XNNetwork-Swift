//
//  XNCategory.swift
//  XNNetwork
//
//  Created by 冯紫瑜 on 2020/9/1.
//  Copyright © 2020 冯紫瑜. All rights reserved.
//

import UIKit

extension Dictionary {
    func jsonString(isPrettyPrint: Bool) -> String {
        
        var jsonObject: Any?
        do {
            jsonObject = try JSONSerialization.data(withJSONObject: self, options: isPrettyPrint ? .prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0))
        } catch {}
        
        guard let jsonData = jsonObject as? Data else { return "{}" }
        return String(data: jsonData, encoding: .utf8) ?? "{}"
    }
}
