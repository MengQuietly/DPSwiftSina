//
//  MQWelomeController.swift
//  MQSwiftSinaManager
//
//  Created by 文静 on 16/5/27.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 欢迎界面
class MQWelomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
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

        avatarIconView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: avatarIconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: avatarIconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -200))
        
        welomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: welomeLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: welomeLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -150))
        
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
