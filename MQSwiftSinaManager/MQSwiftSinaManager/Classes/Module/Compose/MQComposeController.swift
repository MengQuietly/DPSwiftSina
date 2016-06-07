//
//  MQComposeController.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/6/3.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 发布微博
class MQComposeController: UIViewController, UITextViewDelegate {
    
    /// 工具栏底部约束
    private var toolbarBottomCons: NSLayoutConstraint?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 激活键盘
        writeTxtView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MQComposeController.keyBoardChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    // 注销通知
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /// 键盘变化监听方法
    @objc private func keyBoardChange(noti: NSNotification) {
        
        printLog(noti)
        
        // 获取最终的frame － OC 中将结构体保存在字典中，存成 NSValue
        let rect = noti.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        // 获取动画时长
        let duration = noti.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        
        toolbarBottomCons?.constant = -MQAppHeight + rect.origin.y
        
        // 动画
        UIView.animateWithDuration(duration) { 
            self.view.layoutIfNeeded()
        }
    }
    
    /// 设置导航栏
    private func prepareNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(closeNavBarBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(sendNavBarBtnClick))
        navigationItem.rightBarButtonItem?.enabled = false
    
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
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        
        // 是否有文本：显示 placeholder、发送按钮
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        
    }
    
    // MARK: - 创建界面
    /// 专门来创建界面的函数
    override func loadView() {
        view = UIView()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.whiteColor()
        prepareNavBar()
        prepareToolBar()
        prepareTextView()
        preparePictureSelectView()
    }
    
    /// 准备照片视图
    private func preparePictureSelectView() {
        
        // 0. 添加子控制器 － 提示：实际开发中发现响应者链条无法正常传递，通常就是忘记添加子控制器
        // storyboard 中有一个 containerView，纯代码中没有这个控件
        // 本质上就是一个 UIView
        // 1> addSubView(vc.view)
        // 2> addChildViewController(vc)
        addChildViewController(pictureSelectorVC)
        
        // 1. 添加视图
        
        // 将视图插入 toolbars 下面
        view.insertSubview(pictureSelectorVC.view, belowSubview: toolBars)
        
        // 2. 自动布局
        pictureSelectorVC.view.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: MQAppWith, height: MQAppHeight * 0.6))
    }
    
    /// 设置输入框
    private func prepareTextView() {
        view.addSubview(writeTxtView)
        
        // 自动布局
        writeTxtView.translatesAutoresizingMaskIntoConstraints = false
        
        // topLayoutGuide 能够自动判断顶部的控件(状态栏/navbar)
        let viewDict: [String: AnyObject] = ["top":topLayoutGuide,"tv":writeTxtView,"tb":toolBars]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tv]-0-|", options: [], metrics: nil, views: viewDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[top]-0-[tv]-0-[tb]", options: [], metrics: nil, views: viewDict))
        
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
        
        let cons = toolBars.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: MQAppWith, height: 44))
        
        // 记录底部约束
        toolbarBottomCons = toolBars.ff_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        // 确认获得约束
        printLog("获取约束：\(toolbarBottomCons)")
        
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
        // 关闭键盘
        writeTxtView.resignFirstResponder()
        
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
        writeContentView.delegate = self
        writeContentView.backgroundColor = UIColor.redColor()
//        writeContentView.text = "分享新鲜事"
        writeContentView.textColor = UIColor.darkGrayColor()
        writeContentView.font = UIFont.systemFontOfSize(19)
        // 允许垂直拖拽
        writeContentView.alwaysBounceVertical = true
        // 拖拽 txtView 关闭键盘
        writeContentView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        return writeContentView
        
    }()
    
    /// 占位标签
    private lazy var placeholderLabel = UILabel(title: "分享新鲜事", color: UIColor.lightGrayColor(), fontSize: 18)
        
    /// 工具栏
    private lazy var toolBars = UIToolbar()
    
    /// 照片选择控制器
    private lazy var pictureSelectorVC = MQPictureSelectorController()
    
}
