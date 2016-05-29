//
//  MQHomeController.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/20.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

class MQHomeController: MQBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !MQAccountViewModel.shareAccount.userLogon {
            visitorView?.setupInfo(nil, message: "关注一些人，回这里看看有惊喜")
            return
        }
        loadWeiboContent()
    }
    
    /// 加载微博数据
    func loadWeiboContent() {
        MQNetworkingTool.shareManager.loadAccountNewsWeiboContent().subscribeNext({ (result) in
            printLog("加载微博数据成功结果：\(result)")
            }, error: { (error) in
                printLog("加载微博数据失败结果：\(error)", logError: true)
            }) { 
                printLog("加载微博数据完成")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
