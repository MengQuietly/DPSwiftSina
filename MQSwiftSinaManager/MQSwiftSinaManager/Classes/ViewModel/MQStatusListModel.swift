//
//  MQStatusListModel.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/29.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit
import ReactiveCocoa

/// 微博列表视图模型－分离网络方法
class MQStatusListModel: NSObject {
    
    // 微博数据数组 － AnyObject 原因不详
    var statusList:[AnyObject]?
    // 加载微博数据
    func loadStatuses() -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            MQNetworkingTool.shareManager.loadAccountNewsWeiboContent().subscribeNext({ (result) in
                
                let datas = result as! NSDictionary
            
                // 1.获取 result 中的 statuses 字典数组
                guard let statusArray = datas["statuses"] as? [[String: AnyObject]] else{
                    
                    printLog("加载微博数据接口：没有正确的数据")
                    return
                }
                
                printLog("加载微博数据模型转化成果：\(statusArray)")
                
                // 2.字典转模型
                // 创建数组
                if self.statusList == nil {
                    self.statusList = [MQStatusInfo]()
                }
                // 遍历数组，字典转模型
                for dict in statusArray{
                    self.statusList?.append(MQStatusInfo(dict: dict))
                }
                printLog("字典转模型后数组：\(self.statusList)")
                
                // 3.通知调用方
                subscriber.sendCompleted()
                }, error: { (error) in
                    printLog("加载微博数据失败结果：\(error)", logError: true)
                    subscriber.sendError(error)
            }) {}
            
            return nil
        })
        
    }
}
