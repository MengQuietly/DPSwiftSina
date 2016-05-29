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
        
        // 设置网络
        setupStatusBarForNetworking()
        // 设置外观
        setupAppearance()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.redColor()
        window?.rootViewController = MQWelomeController() //MQNewFeatureController() //MQTabBarController()
        window?.makeKeyAndVisible()
        
        return true
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

