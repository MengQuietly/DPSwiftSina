//
//  MQStatusListModel.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/29.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 微博列表视图模型－分离网络方法
class MQStatusListModel: NSObject {
    
    // 加载微博数据
    func loadStatuses() {
        MQNetworkingTool.shareManager.loadAccountNewsWeiboContent().subscribeNext({ (result) in
//            printLog("加载微博数据成功结果：\｀｀(result)")
            
            // 1.获取 result 中的 statuses 字典数组
            guard let statusArray = result["statuses"] as? [[String: AnyObject]] else{
                
                printLog("加载微博数据接口：没有正确的数据")
                return
            }
            
            printLog("加载微博数据模型转化成果：\(statusArray)")
            
            // 2.字典转模型
            
            // 3.通知调用方
            
            }, error: { (error) in
                printLog("加载微博数据失败结果：\(error)", logError: true)
        }) {
            printLog("加载微博数据完成")
        }
    }
}
