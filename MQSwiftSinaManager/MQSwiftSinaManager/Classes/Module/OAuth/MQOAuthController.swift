//
//  MQOAuthController.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/20.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit
import SVProgressHUD

/// OAuth授权控制器
class MQOAuthController: UIViewController,UIWebViewDelegate {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView // 替换根视图 为 webView
        webView.delegate = self
        
        title = "新浪微博登录"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(closeBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(autoLoginBtnClick))
    }
    
    /// 关闭登录界面
    @objc private func closeBtnClick(){
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 自动填充
    @objc private func autoLoginBtnClick(){
        printLog(#function)
        
        let autoJS = "document.getElementById('userId').value = '18716655045@163.com';" +
        "document.getElementById('passwd').value = '521014!wenjing!';"
        // 执行 js 脚本
        webView.stringByEvaluatingJavaScriptFromString(autoJS)
        
    }
    
    /// 尽量让控制器不要管太多事情
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(NSURLRequest(URL: MQNetworkingTool.shareManager.oAuthorizeURL))
    }
    
    // MARK - UIWebViewDelegate
    /// webView 开始加载时
    ///
    /// - parameter webView: webView
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    /// webView 加载完成时
    ///
    /// - parameter webView: webView
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    /// webView 开始加载时
    /// 通常在 iOS 开发中，如果代理方法有 Bool 类型的返回值，返回 true 通常是一切正常
    /// - parameter webView:        webView
    /// - parameter request:        request
    /// - parameter navigationType: navigationType
    ///
    /// - returns: false
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 获取当前请求 url
        let urlString = request.URL!.absoluteString
        
        // 判断 urlString 前是否包含 redirectUri
        // 1.判断 request.url 的前半部分是否是回调地址，如果不是回调地址，继续加载
        if !urlString.hasPrefix(MQNetworkingTool.shareManager.redirectUri) {
            // 继续加载
            return true
        }
        // 2. 如果是回调地址，检查 query，查询字符串，判断是否包含 "code='
        // query 就是 URL 中 `?` 后面的所有内容
        let urlParameter = request.URL!.query
        if let query = urlParameter where query.hasPrefix("code="){
            // 3. 如果有，获取 code
            let code = query.substringFromIndex("code=".endIndex)
            
            // 4. 调用网络方法，获取 token
            MQNetworkingTool.shareManager.loadAccessToken(code).subscribeNext({ (result) in
                printLog("获取 accessToken 成功结果： \(result)")
                
                }, error: { (error) in
                    printLog("获取 accessToken 失败结果： \(error)", logError: true)
            })
            
        }else{
            printLog("取消", logError: true)
        }
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
