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
    private let appSecret = "e84b7f8fc7e5663e02899f20c6639ef7" // appSecret
    let redirectUri = "http://www.baidu.com"
    
    /// 网络单例
    static let shareManager:MQNetworkingTool = {
        // 指定 baseURL
        var instance = MQNetworkingTool(baseURL: nil)
        // 设置反序列化的支持格式
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return instance
    }()
    
    // MARK: - 微博数据
    /// 获取当前登录用户及其所关注（授权）用户的最新微博(加载微博数据)
    ///
    /// 使用一下 可在调用时直接点击链接进去查看
    /// - see: [http://open.weibo.com/wiki/2/statuses/home_timeline](http://open.weibo.com/wiki/2/statuses/home_timeline)
    /// - parameter since_id:   若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    /// - parameter max_id:     若指定此参数，则返回ID小于或等于max_id的微博，默认为0，id越大，微博越新。
    /// @return
    func loadAccountNewsWeiboContent(since_id since_id: Int, max_id: Int) -> RACSignal {
        
        var params = [String: AnyObject]()
        
        if since_id > 0 {
            params["since_id"] = since_id
        } else if max_id > 0 {
            params["max_id"] = max_id - 1
        }
        return request(.GET, URLString:readNewWeiBoURL , parameter: params)
    }
    
    // MARK: - OAuth 授权 URL
    // 使用一下 可在调用时直接点击链接进去查看
    /// - see: [http://open.weibo.com/wiki/Oauth2/authorize](http://open.weibo.com/wiki/Oauth2/authorize)
    var oAuthorizeURL:NSURL{
        let urlString = "\(oauthURL)?client_id=\(clientId)&redirect_uri=\(redirectUri)"
        return NSURL(string: urlString)!
    }
    
    // MARK: - 获取 AccessToken
    /// 获取 AccessToken
    ///
    /// - parameter code: 请求码/授权码
    /// - see: [http://open.weibo.com/wiki/OAuth2/access_token](http://open.weibo.com/wiki/OAuth2/access_token)
    func loadAccessToken(code:String) -> RACSignal{
        let parameterDict = ["client_id":clientId,"client_secret":appSecret, "grant_type": "authorization_code","code":code,"redirect_uri":redirectUri]
        return request(.POST, URLString: accessTokenURL, parameter: parameterDict,withToken: false)
    }
    
    // MARK: - 加载用户信息
    /// 加载用户信息
    ///
    /// - parameter token: token
    /// - parameter uid:   uid
    ///
    /// - returns: RACSignal
    func loadUserInfo(uid:String) ->RACSignal{
        let parameterDict = ["uid":uid]
        return request(.GET, URLString: usersShowURL, parameter: parameterDict)
    }
    
    /// 网络请求方法(对 AFN 的 GET & POST 进行了封装)
    ///
    /// - parameter method:    method
    /// - parameter URLString: urlString
    /// - parameter parameter: 参数字典
    /// - parameter withToken: 是否包含 accessToken，默认带 token 访问
    ///
    /// - returns: RAC Signal
    private func request(method:MQRequestMethod,URLString:String,var parameter:[String:AnyObject]?,withToken:Bool = true)->RACSignal{
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            if withToken { // 判断是否需要 token（需要）
                // 需要增加‘参数字典’中的token参数
                // 判断 token 是否存在，‘guard’ 与 ‘if let’ 相反
                guard let token = MQAccountViewModel.shareAccount.access_token else{
                    // token == nil 情况
                    // 发送一个 token ＝ nil 的错误
                    subscriber.sendError(NSError(domain: "com.MQSwiftSinaManager.error", code: -1001, userInfo: ["errorMsg":"token 为空"]))
                    return nil
                }
                // 后续的token 一定都是有值
                // 判断是否传递了参数字典
                if parameter == nil{
                    parameter = [String:AnyObject]()
                }
                parameter!["access_token"] = token
            }
            
            let successCallBack = { (task:NSURLSessionDataTask, result:AnyObject?) in
//                printLog("网络请求－ 成功回调结果：\(result)")
                
                /** 将结果发送给订阅者*/
                subscriber.sendNext(result)
                /** 发送完成 */
                subscriber.sendCompleted()
                
            }
            let failureCallBack = { (task:NSURLSessionDataTask?, error:NSError) in
                printLog("网络请求－失败回调结果：\(error)", logError: true)
                /** 发送错误 */
                subscriber.sendError(error)
            }
            
            if method == .GET {
                self.GET(URLString, parameters: parameter, progress: { (progress) in
                    printLog("Get 请求进度：\(progress.localizedDescription)")
                    }, success: successCallBack, failure: failureCallBack)
            }else{
                self.POST(URLString, parameters: parameter, progress: { (progress:NSProgress) in
                    printLog("Post 请求进度：\(progress.localizedDescription)")
                    }, success: successCallBack, failure: failureCallBack)
            }
            return nil
        })
    }
    
    // MARK: - 测试返回结果类型的请求方法
    /// 获取 AccessToken(测试返回结果代码)
    func loadAccessTokenToTestBackType(code:String) -> RACSignal{
        let parameterDict = ["client_id":clientId,"client_secret":appSecret,"grant_type": "authorization_code", "code":code,"redirect_uri":redirectUri]
        // 测试返回数据的代码：将结果转换成字符串（不让 AFN 做 JSON 反序列化）
        // 响应数据格式是 二进制的
        responseSerializer = AFHTTPResponseSerializer()
        return requestToTestBackType(.POST, URLString: accessTokenURL, parameter: parameterDict)
    }
    
    /// 网络请求方法(测试返回结果代码)
    func requestToTestBackType(method:MQRequestMethod,URLString:String,parameter:[String:AnyObject]?)->RACSignal{
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            let successCallBack = { (task:NSURLSessionDataTask, result:AnyObject?) in
//                printLog("网络请求－ 成功回调结果：\(result)")
                
                let str = NSString(data: result as! NSData, encoding: NSUTF8StringEncoding)
                printLog(str)
                
                /** 将结果发送给订阅者*/
                subscriber.sendNext(str)
                /** 发送完成 */
                subscriber.sendCompleted()
                
            }
            let failureCallBack = { (task:NSURLSessionDataTask?, error:NSError) in
                printLog("网络请求－失败回调结果：\(error)", logError: true)
                /** 发送错误 */
                subscriber.sendError(error)
            }
            
            if method == .GET {
                self.GET(URLString, parameters: parameter, progress: { (progress) in
                    printLog("Get 请求进度：\(progress.localizedDescription)")
                    }, success: successCallBack, failure: failureCallBack)
            }else{
                self.POST(URLString, parameters: parameter, progress: { (progress:NSProgress) in
                    printLog("Post 请求进度：\(progress.localizedDescription)")
                    }, success: successCallBack, failure: failureCallBack)
            }
            return nil
        })
    }
}
