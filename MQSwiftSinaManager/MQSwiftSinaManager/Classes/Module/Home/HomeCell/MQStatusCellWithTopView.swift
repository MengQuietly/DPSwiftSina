//
//  MQStatusCellWithTopView.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/30.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// statusCell 顶部视图
class MQStatusCellWithTopView: UIView {

    /// 微博的视图模型
    var statusViewModel: MQStatusViewModel? {
        didSet{
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        
        backgroundColor = UIColor.redColor()
        // 添加控件
        
        // 自动布局
        
    }
    
}
