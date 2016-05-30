//
//  UIButton+Extensions.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/30.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

// MARK: - UIButton 分类
/// 便利构造函数
///
/// - parameter title:     title
/// - parameter imageName: imageName
/// - parameter color:     color
/// - parameter fontSize:  fontSize
///
/// - returns: UIButton
extension UIButton{
     convenience init(title: String, imageName: String, color: UIColor, fontSize: CGFloat){
        self.init()
        setTitle(title, forState: UIControlState.Normal)
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setTitleColor(color, forState: UIControlState.Normal)
        
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
}
