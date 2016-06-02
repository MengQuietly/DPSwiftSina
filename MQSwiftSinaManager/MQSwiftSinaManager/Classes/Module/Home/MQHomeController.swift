//
//  MQHomeController.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/20.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit
import SVProgressHUD

// MARK: - 关于表格自动计算行高问题
// 注意：在实际开发中，自动布局约束通常是加多了，一旦po 错，可尝试阅读错误输出，删除一些不必要的约束，就能解决！
// 1.不要使用自动计算行高（tableView.rowHeight = UITableViewAutomaticDimension）
// 2.不要使用底部约束（MQStatusCell 中 cellWithBottomView.ff_AlignInner）
// 3.需要考虑缓存

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
        tableView.registerClass(MQStatusNomalCell.self, forCellReuseIdentifier: MQStatusNomalCellID)
        tableView.registerClass(MQStatusForwardCell.self, forCellReuseIdentifier: MQStatusForwardCellID)
        
        // 以下两句就可以自动处理行高，条件：
        // 提示：如果不使用自动计算行高，UITableViewAutomaticDimension，一定不要设置底部约束（需去除 statusBottomView 约束）
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = 300 // UITableViewAutomaticDimension
        
        // 取消分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        loadWeiboList()
    }
    
    /// 加载微博数据
    func loadWeiboList() {
        
        statusesListModel.loadStatuses().subscribeNext({ (result) in
            // TODO:
            }, error: { (error) in
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
        
        // 0. 获取微博数据
        let viewModel = statusesListModel.statusList[indexPath.row] as! MQStatusViewModel
        
        /// 1) dequeueReusableCellWithIdentifier:indexPath 一定会返回一个cell，必须注册可重用cell
        /// 注册：registerClass/registerNib(XIB)/在 SB 中指定
        /// 如果缓冲区 cell 不存在，会使用原型 cell 实例化一个新的 cell
        /// 2) dequeueReusableCellWithIdentifier，会查询可重用cell，如果注册原型cell，能够查询到，否则，返回 nil
        /// 需要后续判断 if (cell == nil) ，是在 iOS 5.0 开发使用的
        /// 1.获得可重用cell的同时要获得行高
        let cell = tableView.dequeueReusableCellWithIdentifier(viewModel.cellID, forIndexPath: indexPath) as! MQStatusCell
        
        // 2. 设置数据
        cell.statusViewModel = viewModel
        
        // 3. 返回 cell
        return cell
    }
    
    /// 默认情况下，会计算所有行的行高（因为 UITableView 继承自 UIScrollView，UIScrollerView 的滚动依赖于 contentSize，而 要把所有行高斗计算出来，才能准确知道 contentSize）
    /// 若设置了预估行高（estimatedRowHeight），会根据预估行高，来计算需要显示行的尺寸！
    /// 注意：
    /// 1) 没设置 预估行高，执行顺序为：numberOfRowsInSection（多次）－cellForRowAtIndexPath－heightForRowAtIndexPath（多次）－cellForRowAtIndexPath；
    /// 2) 设置了 预估行高，执行顺序为：numberOfRowsInSection（多次）－heightForRowAtIndexPath（多次）－cellForRowAtIndexPath；（但 设置行高还是会调用 3 次）
    /// 提示：若行高是固定的，千万不要实现此代理！行高的代理方法，在每个版本的 Xcode 和 iOS 模拟器上执行频率都不一样
    /// 苹果在底层一直在做优化
    /// 需行高的缓存！‘只计算一次！ 有一个地方能记录当前的行高！’
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // 0. 获得模型
        let viewModel = statusesListModel.statusList[indexPath.row] as! MQStatusViewModel
        
        if viewModel.cellRowHeight > 0 {
            printLog("statusCell 缓存行高：\(viewModel.cellRowHeight)")
            return viewModel.cellRowHeight
        }
        
        // 1. 获得 cell(注意：不能使用 带 dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) 方法，否则会死循环［因为调用indexpath 代理时，会调用 heightForRowAtIndexPath 此代理方法］)
        let cell = tableView.dequeueReusableCellWithIdentifier(viewModel.cellID) as! MQStatusCell
        
        // 3. 记录缓存行高
        viewModel.cellRowHeight = cell.cellRowHeight(viewModel)
        
        // 2. 返回行高
        return viewModel.cellRowHeight
        
    }
}
