//
//  MQTabBarController.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/20.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

class MQTabBarController: UITabBarController {

    /// 苹果专门为 “代码创建视图” 层次机构设计的函数，可和 XIB／SB 等价
    override func loadView() {
        super.loadView()
    }

    /// 视图将要出现，可能会被调用多次
    /// 不适合做多次执行的代码
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 视图将要出现的时候，tabbar中的按钮才会创建
        print(tabBar.subviews)
        
        setupComposeButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 添加所有的子控制器，注意：不会添加 tabBar 中的按钮
        // 在 iOS 开发中，懒加载是无处不在的，视图资源只有在需要显示的时候，才会被创建
        addChildViewControllers()
        
        // 此时 tabbar的按钮没有被创建
        print(tabBar.subviews)
    }
    
    /// 添加所有子控制器
    private func addChildViewControllers() {
        self.addChildViewController(MQHomeController(), title: "首页",image: "tabbar_home",selImage: "tabbar_home_selected")
        self.addChildViewController(MQMessageController(), title: "消息",image: "tabbar_message_center",selImage: "tabbar_message_center_selected")
        self.addChildViewController(UIViewController())
        self.addChildViewController(MQDiscoverController(), title: "发现",image: "tabbar_discover",selImage: "tabbar_discover_selected")
        self.addChildViewController(MQProfileController(), title: "我",image: "tabbar_profile",selImage: "tabbar_profile_selected")
    }
    
    /// 添加独立子控制器
    ///
    /// - parameter viewController: 视图控制器
    /// - parameter title:          title
    /// - parameter image:          image
    /// - parameter selImage:       selImage
    private func addChildViewController(viewController:(UIViewController),title:(String),image:(String),selImage:(String)){
        viewController.title = title
        viewController.tabBarItem.image = UIImage(named: image)
        viewController.tabBarItem.selectedImage = UIImage(named: selImage)
        
        let navVC = UINavigationController(rootViewController: viewController)
        addChildViewController(navVC)
    }

    // MARK：懒加载控件
    private lazy var composedButton:UIButton = {
        
        let btn = UIButton()
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: #selector(composeBtnClick) , forControlEvents: UIControlEvents.TouchUpInside)
        self.tabBar.addSubview(btn)
        
        return btn
    }()

    /// 添加撰写按钮，并且设置撰写按钮位置
    private func setupComposeButton(){
        let count = childViewControllers.count
        let w = tabBar.bounds.width / CGFloat(count)
        let rect = CGRect(x: 0, y: 0, width: w, height: tabBar.bounds.height)
        composedButton.frame = CGRectOffset(rect, 2 * w, 0)
    }

    /// 按钮监听方法，由运行循环来调用的，因此不能直接使用 private
    /// swift 中，所有的函数如果不使用 private 修饰，是全局共享的
    /// @objc 关键字能够保证运行循环能够调用，走的 oc 的消息机制，调用之前不再判断方法是否存在,和 private 联用，就能够做到对方法的保护
    @objc private func composeBtnClick(){
        print(#function)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
