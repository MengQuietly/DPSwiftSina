//
//  MQStatusViewModel.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/30.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 微博的视图模型，供界面显示使用
class MQStatusViewModel: NSObject {
   
    /// 微博对象
    var statusInfo : MQStatusInfo
    
    // MARK: - 构造函数
    init(statusInfos: MQStatusInfo) {
        self.statusInfo = statusInfos
        super.init()
    }
}
