//
//  MQStatusListModel.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/29.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SDWebImage

/// 微博列表视图模型－分离网络方法
class MQStatusListModel: NSObject {
    
    // 微博数据数组 － AnyObject 原因不详
    lazy var statusList:[AnyObject] = [MQStatusViewModel]()
    
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
            
                // 定义并且创建一个临时数组，记录当前网络请求返回的结果
                var arrayM = [AnyObject]()
                
                // 遍历数组，字典转模型
                for dict in statusArray{
                    arrayM.append(MQStatusViewModel(statusInfos: MQStatusInfo(dict: dict)))
                }
                
                // 添加尾随闭包
                self?.cacheWebImage(arrayM as! [MQStatusViewModel]){
                    self?.statusList += arrayM
                    
                    printLog("字典转模型后数组：\(self?.statusList)")
                    
                    // 3.通知调用方
                    subscriber.sendCompleted()
                }
                
            }, error: { (error) in
                    printLog("加载微博数据失败结果：\(error)", logError: true)
                    subscriber.sendError(error)
            }) {}
            
            return nil
        })
    }
    
    /// 缓存网络图片
    ///
    /// - parameter array:    视图模型数组
    /// - parameter finished: 完成回调
    private func cacheWebImage(array: [MQStatusViewModel],finished:()->()){
        
        // 记录缓存图像大小
        var imgDataLength = 0
        
        // 1>调度组
        let groups = dispatch_group_create()
        
        // 遍历视图模型数组
        for viewModel in array {
            
            // 目标：只需要缓存单张图片
            let imgCount = viewModel.thumbnailURLs?.count ?? 0
            if imgCount != 1 {
                continue
            }
            
            // 2>入组 - 紧贴着 block/闭包，enter & leave 要配对出现
            dispatch_group_enter(groups)
            
            // 使用 SDWebImage 的核心函数下载图片
            SDWebImageManager.sharedManager().downloadImageWithURL(viewModel.thumbnailURLs![0], options: [], progress: nil, completed: { (image, _, _, _, _) in
                
                // 代码执行到此，图片已经缓存完成，不一定有 image
                if image != nil{
                    // 将 image 转换成二进制数据
                    let pngData = UIImagePNGRepresentation(image)
                    imgDataLength += pngData?.length ?? 0
                }
                // 3>出组 - block 的最后一句
                dispatch_group_leave(groups)
            })
            
            // 4>调度组监听
            dispatch_group_notify(groups, dispatch_get_main_queue(), { 
                printLog("缓存完成:\(NSHomeDirectory()),大小：\(imgDataLength/1024) K")
                
                // 执行闭包
                finished()
            })
            
            printLog("－－－－－－调度组后：\(viewModel.thumbnailURLs)")
        }
    }
}
