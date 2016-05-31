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
    var statusList:[AnyObject] = [MQStatusViewModel]()
    // 加载微博数据
    func loadStatuses() -> RACSignal {
        
        // RACSignal 在订阅的时候，会对 self 进行强引用，sendCompleted 说明信号完成，会释放对 self 的强引用
        // 以下代码不存在循环引用，但是为了保险，可以使用 [weak self] 防范！
        return RACSignal.createSignal({ [weak self](subscriber) -> RACDisposable! in
            
            // 网络工具，执行的时候，会对 self 进行强引用，网络访问结束后，后对 self 的引用释放！
            MQNetworkingTool.shareManager.loadAccountNewsWeiboContent().subscribeNext({ (result) in
                
                let datas = result as! NSDictionary
            
                // 1.获取 result 中的 statuses 字典数组
                guard let statusArray = datas["statuses"] as? [[String: AnyObject]] else{
                    
                    printLog("加载微博数据接口：没有正确的数据")
                    return
                }
                
                printLog("加载微博数据模型转化成果：\(statusArray)")
                
                // 2.字典转模型
            
                // 遍历数组，字典转模型
                for dict in statusArray{
                    self?.statusList.append(MQStatusViewModel(statusInfos: MQStatusInfo(dict: dict)))
                }
                printLog("字典转模型后数组：\(self?.statusList)")
                
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
