//
//  UILabel+Extensions.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/30.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

// MARK: - UILabel 分类
/// 便利构造函数
///
/// - parameter title:          title
/// - parameter color:          color
/// - parameter fontSize:       fontSize
/// - parameter layoutWidth:    布局宽度，一旦大于 0，就是多行文本
///
/// - returns: UILabel

extension UILabel{
    convenience init(title:String?, color:UIColor, fontSize:CGFloat, layoutWidth: CGFloat = 0) {
        // 实例化当前对象
        self.init()
        
        // 设置对象属性
        text = title
        textColor = color
        font = UIFont.systemFontOfSize(fontSize)
        if layoutWidth > 0 { // 显示多行
            preferredMaxLayoutWidth = layoutWidth
            numberOfLines = 0
        }
    }
}

