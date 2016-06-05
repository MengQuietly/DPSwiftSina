//
//  UIBarButtonItem+Extensions.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/6/3.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 便利构造函数
    ///
    /// - parameter imageName:  imageName
    /// - parameter target:     target
    /// - parameter actionName: actionName
    ///
    /// - returns: UIBarButtonItem
    convenience init(imageName: String,target: AnyObject?,actionName: String?) {
     
        let barItemBtn = UIButton(imageName: imageName)
        
        if target != nil && actionName != nil{
            barItemBtn.addTarget(target, action: Selector(actionName!), forControlEvents: UIControlEvents.TouchUpInside)
        }
        self.init(customView: barItemBtn)
    }
}
