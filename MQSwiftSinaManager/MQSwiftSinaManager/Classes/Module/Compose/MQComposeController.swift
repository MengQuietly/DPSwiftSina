//
//  MQComposeController.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/6/3.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 发布微博
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
        view.backgroundColor = UIColor.whiteColor()
        prepareNavBar()
        prepareToolBar()
        prepareTextView()
    }
    
    /// 设置输入框
    private func prepareTextView() {
        view.addSubview(writeTxtView)
        
        // 自动布局
        writeTxtView.translatesAutoresizingMaskIntoConstraints = false
        
        // topLayoutGuide 能够自动判断顶部的控件(状态栏/navbar)
        let viewDict: [String: AnyObject] = ["top":topLayoutGuide,"tv":writeTxtView,"tb":toolBars]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tv]-0-|", options: [], metrics: nil, views: viewDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[top]-0-[tv]-0-[tb]-0-|", options: [], metrics: nil, views: viewDict))
        
        writeTxtView.addSubview(placeholderLabel)
        placeholderLabel.frame = CGRect(origin: CGPoint(x: 5, y: 8), size: placeholderLabel.bounds.size)
    }
    
    /// 设置工具栏
    private func prepareToolBar() {
        view.addSubview(toolBars)
        
        let toolBarIconArray = [
            ["toobarIconName":"compose_toolbar_picture","toolBarBtnAction":"pictureBarBtnClick"],
            ["toobarIconName":"compose_toolbar_mention","toolBarBtnAction":"mentionBarBtnClick"],
            ["toobarIconName":"compose_toolbar_trend","toolBarBtnAction":"trendBarBtnClick"],
            ["toobarIconName":"compose_toolbar_emoticon","toolBarBtnAction":"emoticonBarBtnClick"],
            ["toobarIconName":"compose_toolbar_more","toolBarBtnAction":"moreBarBtnClick"]
        ]
        
        toolBars.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: MQAppWith, height: 44))
        
        // 添加按钮 Array
        var btnItems = [UIBarButtonItem]()
        
        for dict in toolBarIconArray {
            
            // 添加 toolbar 的 item
            btnItems.append(UIBarButtonItem(imageName: dict["toobarIconName"]!, target: self, actionName: dict["toolBarBtnAction"]))
            // 添加 toolbar 的 item 间的弹簧间距
            btnItems.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        btnItems.removeLast()
        toolBars.items = btnItems
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
    
    /// 选择照片
    @objc private func pictureBarBtnClick(){
        printLog("选择照片")
    }
    
    /// @ 好友
    @objc private func mentionBarBtnClick(){
        printLog("@ 好友")
    }
    
    /// 选择 热门
    @objc private func trendBarBtnClick(){
        printLog("选择热门")
    }
    
    /// 选择表情
    @objc private func emoticonBarBtnClick(){
        printLog("选择 表情")
    }
    
    /// 更多
    @objc private func moreBarBtnClick(){
        printLog("选择更多")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 懒加载控件
    /// 文本视图
    private lazy var writeTxtView: UITextView = {
        let writeContentView = UITextView()
        writeContentView.backgroundColor = UIColor.redColor()
        writeContentView.text = "分享新鲜事"
        writeContentView.textColor = UIColor.darkGrayColor()
        writeContentView.font = UIFont.systemFontOfSize(19)
        // 允许垂直拖拽
        writeContentView.alwaysBounceVertical = true
        return writeContentView
        
    }()
    
    /// 占位标签
    private lazy var placeholderLabel = UILabel(title: "分享新鲜事", color: UIColor.lightGrayColor(), fontSize: 18)
        
    /// 工具栏
    private lazy var toolBars = UIToolbar()
}
