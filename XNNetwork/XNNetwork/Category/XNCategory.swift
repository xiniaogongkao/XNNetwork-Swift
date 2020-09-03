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
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: isPrettyPrint ? .prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)) else { return "{}" }
        return String(data: jsonData, encoding: .utf8) ?? "{}"
    }
}
