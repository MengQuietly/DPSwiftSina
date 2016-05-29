//
//  MQWelomeController.swift
//  MQSwiftSinaManager
//
//  Created by 文静 on 16/5/27.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit
import SDWebImage

/// 欢迎界面
class MQWelomeController: UIViewController {

    // 头像底部约束
    private var iconBottomLayout: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        // 设置网络头像
        avatarIconView.sd_setImageWithURL(MQAccountViewModel.shareAccount.avatarUrl, placeholderImage: UIImage(named: "avatar_default_big"))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 开始动画
        // 1.计算 icon 约束数值
        let h = -(UIScreen.mainScreen().bounds.height + iconBottomLayout!.constant)
        // 2.修改约束数值
        // 使用自动布局，苹果提供了一个自动布局系统，在后台维护界面元素的位置和大小
        // 一旦使用了自动布局，就不要再直接设置 frame
        // 自动布局系统会 ‘收集’ 界面上所有需要重新调整位置／大小的控件的约束，会将当前所有的约束变化应用到控件上
        // 若开发中需要抢行更新约束，可直接调用 layoutIfNeeded 方法，会将当前所有的约束变化应用到控件上
        iconBottomLayout?.constant = h
        
        welomeLabel.alpha = 0
        // 开发中需注意：不要让重要的控件移出屏幕外侧
        UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: { 
            // 若需要更新布局
            self.view.layoutIfNeeded()
            }) { (_) in
                UIView.animateWithDuration(0.8, animations: { 
                    self.welomeLabel.alpha = 1
                    }, completion: { (_) in
                        
                })
        }
    }
    
    /// 设置布局
    private func setUpUI(){
        // 添加控件
        view.addSubview(backImgView)
        view.addSubview(avatarIconView)
        view.addSubview(welomeLabel)
        
        // 自动布局
        backImgView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[v]-0-|", options: [], metrics: nil, views: ["v":backImgView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[v]-0-|", options: [], metrics: nil, views: ["v":backImgView]))

        // 头像 img 约束
        avatarIconView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: avatarIconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        // 记录头像垂直方向约束
//        // 第一种写法：
//        self.iconBottomLayout = NSLayoutConstraint(item: avatarIconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -200)
//        view.addConstraint(self.iconBottomLayout!)

        // 第二种写法：将新建的约束添加到视图的约束数组中
        view.addConstraint(NSLayoutConstraint(item: avatarIconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -200))
        self.iconBottomLayout = view.constraints.last
        
        // 约束头像宽高
        view.addConstraint(NSLayoutConstraint(item: avatarIconView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 90))
        view.addConstraint(NSLayoutConstraint(item: avatarIconView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 90))
            
        // 欢迎回来label 约束
        welomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: welomeLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: avatarIconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: welomeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: avatarIconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
    }
    
    // MARK: － 懒加载控件
    // 背景图片
    private lazy var backImgView = UIImageView(image: UIImage(named: "ad_background"))
    // 头像图片
    private lazy var avatarIconView : UIImageView = {
        
        let avatarIcon = UIImageView(image: UIImage(named: "avatar_default_big"))
        avatarIcon.layer.cornerRadius = avatarIcon.frame.width * 0.5
        avatarIcon.layer.masksToBounds = true
        return avatarIcon
        
    }()
    
    // 欢迎回来
    private lazy var welomeLabel: UILabel = {
        let welomeLabels = UILabel()
        welomeLabels.text = "欢迎回来"
        welomeLabels.textColor = UIColor.grayColor()
        return welomeLabels
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
