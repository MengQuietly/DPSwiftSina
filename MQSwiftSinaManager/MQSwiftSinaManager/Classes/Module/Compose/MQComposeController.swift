//
//  MQComposeController.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/6/3.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

class MQComposeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// 设置导航栏
    private func prepareNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(closeNavBarBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(sendNavBarBtnClick))
    
        let titleViews = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 32))
        let titleLabel = UILabel(title: "发布微博", color: UIColor.darkGrayColor(), fontSize: 15)
        let username = MQAccountViewModel.shareAccount.userAccount?.name
        let nameLabel = UILabel(title: "\(username!)", color: UIColor.lightGrayColor(), fontSize: 12)
        titleViews.addSubview(titleLabel)
        titleViews.addSubview(nameLabel)
        
        titleLabel.ff_AlignInner(type: ff_AlignType.TopCenter, referView: titleViews, size: nil)
        nameLabel.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: titleViews, size: nil)
        
        navigationItem.titleView = titleViews
    }
    
    // MARK: - 创建界面
    /// 专门来创建界面的函数
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.redColor()
        prepareNavBar()
    }
    
    // MARK: - 监听方法
    /// 取消发送微博
    @objc private func closeNavBarBtnClick(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 发送微博
    @objc private func sendNavBarBtnClick(){
        printLog("发送微博")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
