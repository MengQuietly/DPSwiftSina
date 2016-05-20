//
//  MQVisitorLoginView.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/20.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

class MQVisitorLoginView: UIView {

    /// 设置界面信息
    ///
    /// - parameter imageName: 图像名称
    /// - parameter message:   消息文字
    func setupInfo(imageName:String?,message:String){
        
        msgLabel.text = message
        
        // 判断是否传递图片，有图片就不是首页
        if let imgName = imageName {
            iconView.image = UIImage(named: imgName)
            homeIconView.hidden = true // 隐藏小房子
            sendSubviewToBack(maskIconView) // 将遮罩移动到底部
        }else{
            startAnimation()
        }
    }
    /// 首页图标的动画
    private func startAnimation(){
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        // 设置动画不被删除：当iconView 被销毁时，动画会被自动释放
        anim.removedOnCompletion = false
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    // MARK: - 界面布局
    /// 纯代码 开发调用
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    /// SB 开发调用
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    /// 设置界面－负责 添加、设置界面位置
    private func setupUI(){
        
        // 添加控件
        addSubview(iconView)
        addSubview(homeIconView)
        addSubview(maskIconView)
        addSubview(msgLabel)
        addSubview(registerBtn)
        addSubview(loginBtn)
        
        // 设置布局
        // 1> 图标
        // 默认情况下，纯代码开发不支持自动布局，若要支持自动布局，需将控件 translatesAutoresizingMaskIntoConstraints＝false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        // "view1.attr1 = view2.attr2 * multiplier + constant"
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -60))
        // 2> home图标
        homeIconView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: homeIconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: homeIconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        // 3> 设置文本
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: msgLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: msgLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        //提示： 若要设置一个固定数值：参照对象设置为 nil，参照的属性需设置为 NSLayoutAttribute.NotAnAttribute
        addConstraint(NSLayoutConstraint(item: msgLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 224))
        // 4> 注册按钮
        registerBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: msgLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: msgLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35))
        
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: msgLabel, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: msgLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35))
        
        maskIconView.translatesAutoresizingMaskIntoConstraints = false
        // VFL 可视化布局语言
        // H: 水平方向、V: 垂直方向、|: 边界、[]: 控件
        // metrics: 极少用,一般为nil
        // views: [key, VFL 中[] 括起的名称, value: 控件] -> 控件和 VFL 的映射
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[v]-0-|", options: [], metrics: nil, views: ["v":maskIconView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[v]-(-35)-[otherBtn]", options: [], metrics: nil, views: ["v":maskIconView,"otherBtn":registerBtn]))
        
        
        // 设置背景颜色 - 灰度图 r = g = b
        // 提高程序效率的一个细节，如果能够用颜色表示，就不要用图片
        backgroundColor = UIColor(white: 237.0 / 255.0, alpha: 1.0)
        
    }
    // MARK: - 懒加载控件
    // 图标
    private lazy var iconView:UIImageView = UIImageView(image: UIImage(named:"visitordiscover_feed_image_smallicon"))
    // 小房子
    private lazy var homeIconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    // 遮罩视图：不要使用maskView
    private lazy var maskIconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    // 消息文字
    private lazy var msgLabel:UILabel = {
        let label = UILabel()
        label.text = "登录后，别人评论你的微博，发给你的消息，会在这里收到通知"
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    // 注册按钮
    lazy var registerBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState.Normal)
        return btn
    }()
    // 登录按钮
    lazy var loginBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState.Normal)
        return btn
    }()

}
