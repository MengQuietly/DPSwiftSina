//
//  MQAccountViewModel.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/25.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit
import ReactiveCocoa

/// 用户账户视图模型
class MQAccountViewModel: NSObject {
    // 单例
    static let shareAccount = MQAccountViewModel()
    
    // 当单例后的对象执行完成后就会执行 init 方法，初始化 AccountInfo 对象，为对象赋值
    override init() {
        userAccount = MQAccountInfo.loadUserAccount()
    }
    // 用户账户
    var userAccount : MQAccountInfo?
    var access_token : String?{
        return userAccount?.access_token
    }
    
    /// 用户登录标记
    var userLogon:Bool{
        return access_token != nil
    }

    func loadUserAccount(code:String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            // 4. 调用网络方法，获取 token
            
            /// doNext : 是可以给信号增加附加操作，第一个信号完成后，将第一个信号的result  直接传递给第二个信号
            /// doNext ： 后一定要加 subscriberXXX ，否则 doNext 不会被执行到
            //            MQNetworkingTool.shareManager.loadAccessToken(code).subscribeNext({ (result) in})
            MQNetworkingTool.shareManager.loadAccessToken(code).doNext({ (result) -> Void in
                printLog("获取 accessToken 成功结果： \(result)")
                let accountInfo = MQAccountInfo(dict: result as! [String : AnyObject])
                printLog("返回对象：\(accountInfo)")
                
                // 设置属性（不设置，将为nil）
                self.userAccount = accountInfo 
                
                /// 加载用户信息
                MQNetworkingTool.shareManager.loadUserInfo(accountInfo.uid!).subscribeNext({ (result) -> Void in
                    let dict = result as! [String: AnyObject]
                    printLog("加载用户信息 成功结果：result = \(result),dict = \(dict)")
                    accountInfo.name = dict["name"] as? String
                    accountInfo.avatar_large = dict["avatar_large"] as? String
                    
                    printLog("accountInfo=\(accountInfo)")
                    // 保存帐号
                    accountInfo.saveUserAccount()
                    
                    /// 通知订阅者网络数据加载完成
                    subscriber.sendCompleted()
                    }, error: { (error) -> Void in
                        /// 通知发送失败
                        subscriber.sendError(error)
                        printLog("加载用户信息 失败结果： \(error)", logError: true)
                })
            }).subscribeError( { (error) -> Void in
                subscriber.sendError(error)
                printLog("获取 accessToken 失败结果： \(error)", logError: true)
            })
            return nil
        })
        
    }
    
}
