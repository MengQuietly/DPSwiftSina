//
//  MQNetworkingTool.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/20.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit
import AFNetworking
import ReactiveCocoa

enum MQRequestMethod: String {
    case GET = "GET"
    case POST = "POST"
}

/// 网络工具类
class MQNetworkingTool: AFHTTPSessionManager {
    // MARK: - App 信息
    private let clientId = "3170863229" // appKey
    private let appSecret = "26d9fb97279ccde43d2130df2407425a" // appSecret
    let redirectUri = "http://www.baidu.com"
    
    /// 网络单例
    static let shareManager:MQNetworkingTool = {
        // 指定 baseURL
        var instance = MQNetworkingTool(baseURL: nil)
        // 设置反序列化的支持格式
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return instance
    }()
    
    // MARK: - OAuth 授权 URL
    // 使用一下 可在调用时直接点击链接进去查看
    /// - see: [http://open.weibo.com/wiki/Oauth2/authorize](http://open.weibo.com/wiki/Oauth2/authorize)
    var oAuthorizeURL:NSURL{
        let urlString = "\(oauthURL)?client_id=\(clientId)&redirect_uri=\(redirectUri)"
        return NSURL(string: urlString)!
    }
    
    /// 获取 AccessToken
    ///
    /// - parameter code: 请求码/授权码
    ///
    /// - see: [http://open.weibo.com/wiki/OAuth2/access_token](http://open.weibo.com/wiki/OAuth2/access_token)
    func loadAccessToken(code:String) -> RACSignal{
        let parameterDict = ["client_id":clientId,"client_secret":appSecret, "code":code,"redirect_uri":redirectUri]
        return request(.POST, URLString: accessTokenURL, parameter: parameterDict)
    }
    /// 网络请求方法
    ///
    /// - parameter method:    method
    /// - parameter URLString: urlString
    /// - parameter parameter: 参数字典
    ///
    /// - returns: RAC Signal
    func request(method:MQRequestMethod,URLString:String,parameter:[String:AnyObject]?)->RACSignal{
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            let successCallBack = { (task:NSURLSessionDataTask, result:AnyObject?) in
                print("网络请求－ 成功回调结果：\(result)")
                
                /** 将结果发送给订阅者*/
                subscriber.sendNext(result)
                /** 发送完成 */
                subscriber.sendCompleted()
                
            }
            let failureCallBack = { (task:NSURLSessionDataTask?, error:NSError) in
                print("网络请求－失败回调结果：\(error)")
                /** 发送错误 */
                subscriber.sendError(error)
            }
            
            if method == .GET {
                self.GET(URLString, parameters: parameter, progress: { (progress) in
                    print("Get 请求进度：\(progress.localizedDescription)")
                    }, success: successCallBack, failure: failureCallBack)
            }else{
                self.POST(URLString, parameters: parameter, progress: { (progress:NSProgress) in
                    print("Post 请求进度：\(progress.localizedDescription)")
                    }, success: successCallBack, failure: failureCallBack)
            }
            return nil
        })
    }

}
