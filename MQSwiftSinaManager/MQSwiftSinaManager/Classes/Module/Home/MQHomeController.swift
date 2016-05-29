//
//  MQHomeController.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/20.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit
import SVProgressHUD

/// MVVM 中控制器／视图模型不能直接引用模型
class MQHomeController: MQBaseTableViewController {
    
    /// 微博列表视图模型
    private lazy var statusesListModel = MQStatusListModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !MQAccountViewModel.shareAccount.userLogon {
            visitorView?.setupInfo(nil, message: "关注一些人，回这里看看有惊喜")
            return
        }
        loadWeiboList()
    }
    
    /// 加载微博数据
    func loadWeiboList() {
        
        statusesListModel.loadStatuses().subscribeNext({ (error) in
            printLog("首页加载微博数据失败", logError: true)
            SVProgressHUD.showInfoWithStatus("您的网络不给力！")
            }) { 
                // 刷新表格
                self.tableView.reloadData()
        }
//        statusesListModel.loadStatuses().subscribeNext({ (error) -> Void in
//            printLog("首页加载微博数据失败", logError: true)
//            SVProgressHUD.showInfoWithStatus("您的网络不给力！")
//            }) { () -> Void in
//                // 刷新表格
//                self.tableView.reloadData()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
