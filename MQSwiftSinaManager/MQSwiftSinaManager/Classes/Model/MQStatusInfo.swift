//
//  MQStatusInfo.swift
//  MQSwiftSinaManager
//
//  Created by 文静 on 16/5/29.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 微博模型
class MQStatusInfo: NSObject {
    /// 创建时间
    var created_at: String?
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
}
