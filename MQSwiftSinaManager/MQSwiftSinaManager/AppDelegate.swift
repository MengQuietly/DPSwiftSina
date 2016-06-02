//
//  AppDelegate.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/18.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        printLog("用户账户信息－打印方法:\(MQAccountInfo.loadUserAccount())")
        printLog("用户账户信息－打印属性:\(MQAccountViewModel.shareAccount.userAccount)")
        
        // 注册通知
        // object：监听由哪个对象发出的通知，若为 nil 表接收所有对象发送的 ‘name’通知
        let selectors = #selector(AppDelegate.switchRootViewControllerNotification)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selectors, name: MQSwitchRootViewControllerNotification, object: nil)
        // 设置网络
        setupStatusBarForNetworking()
        // 设置外观
        setupAppearance()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.redColor()
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    /// 切换根控制器的通知监听方法
    @objc private func switchRootViewControllerNotification(notification:NSNotification){
        printLog("切换根控制器的通知：\(notification)")
        
        // 提示：在发布通知时：
        // 若只是传递消息，post name
        // 若传递消息同时，希望传递一个数值，可通过 ‘object’ 来传递数值
        // 若传递消息同时，希望传递更多内容，可通过 ‘userInfo’ 字典来传递
        window?.rootViewController = (notification.object == nil) ? MQTabBarController() : MQWelomeController()
    }
    
    /// 注销通知
    deinit{
        // 注销指定名称的通知，在程序被销毁时，才会被调用，可省略
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MQSwitchRootViewControllerNotification, object: nil)
    }
    
    /// 启动默认根控制器
    ///
    /// - returns: 启动控制器
    private func defaultViewController() -> UIViewController{
        // 1. 判断用户是否登录
        if MQAccountViewModel.shareAccount.userLogon {
            // 2. 若已登录，判断是否是新版本
            return isNewVersion() ? MQNewFeatureController() : MQWelomeController()
        }
        
        // 3. 若没登录，返回Main
        return MQTabBarController()
    }
    
    /// 检查是否是新版本
    ///
    /// - returns: true／false
    private func isNewVersion() -> Bool{
    
        // 1.获取当前版本号
        let currentVersions = Double(NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String)!
        
        printLog("当前版本号：\(currentVersions)")
        // 2.获取之前版本号（若没有，返回0）
        let versionKey = "com.MQSwfitSinaManager.cn.version"
        let beforeVersions = NSUserDefaults.standardUserDefaults().doubleForKey(versionKey)
        printLog("之前版本号：\(beforeVersions)")
        // 3.保存当前版本号
        NSUserDefaults.standardUserDefaults().setDouble(currentVersions, forKey: versionKey)
        // 4.比较版本号，返回结果
        return currentVersions > beforeVersions
    }
    
    /// 修改 navBar、tabBar 字体颜色
    /// 设置全局外观：修改要尽早，一经设置，全局有效
    func setupAppearance(){
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.redColor()
    }
    
    /// 设置网络指示器
    func setupStatusBarForNetworking(){
        // 设置网络指示器，一旦设置，发起网络请求，会在状态栏显示菊花，指示器只负责 AFN 的网络请求，其他网络框架不负责
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        
        // 设置缓存大小：NSURLCache 会把 GET 请求的数据做缓存
        // 缓存的磁盘路径：/Library/Caches/(application bundle id)
        // AFN 作者 MATTT，使用 苹果原生 缓存NSURLCache
        // 内存缓存是 4M，磁盘缓存是 20M
        // 提示：URLSession 只有 dataTask 会被缓存，downloadTask（一般文件大，存储在Temp随时删除）／uploadTask 不被缓存
        // 扩展：1.终端 $ cd /Library/Caches/(application bundle id) 下，
        //      2.$ sqlite3 Cache.db 得到4个文件
        //      3. 文件 blob 表：保存接收到的图像，文件 receiver 表：保存接收到的二进制数据 JSON，文件 response 表：保存缓存响应
        //      4.$ select * from receiver文件名; // 查看里面的内容
        let cache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(cache)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

