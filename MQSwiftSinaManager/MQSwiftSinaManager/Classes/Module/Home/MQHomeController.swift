//
//  MQHomeController.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/20.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit
import SVProgressHUD

/// HomeCell 重用标识符
private let MQHomeCellID = "MQHomeCellID"

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
        // 注册重用 cell
        tableView.registerClass(MQStatusCell.self, forCellReuseIdentifier: MQHomeCellID)
        // 以下两句就可以自动处理行高，条件：
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // 取消分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// 类似于 OC 的分类，同时可以将遵守的协议方法，分离出来
extension MQHomeController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusesListModel.statusList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /// 1. dequeueReusableCellWithIdentifier:indexPath 一定会返回一个cell，必须注册可重用cell
        /// 注册：registerClass/registerNib(XIB)/在 SB 中指定
        /// 如果缓冲区 cell 不存在，会使用原型 cell 实例化一个新的 cell
        /// 2. dequeueReusableCellWithIdentifier，会查询可重用cell，如果注册原型cell，能够查询到，否则，返回 nil
        /// 需要后续判断 if (cell == nil) ，是在 iOS 5.0 开发使用的
        let cell = tableView.dequeueReusableCellWithIdentifier(MQHomeCellID, forIndexPath: indexPath) as! MQStatusCell
        
        // 1. 获取微博数据
        let statusInfos = statusesListModel.statusList[indexPath.item] as! MQStatusViewModel
        
        // 2. 设置数据
        cell.statusViewModel = statusInfos
        
        // 3. 返回 cell
        return cell
    }
}
