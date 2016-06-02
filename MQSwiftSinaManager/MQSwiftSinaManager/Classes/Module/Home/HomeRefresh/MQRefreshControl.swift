//
//  MQRefreshControl.swift
//  MQSwiftSinaManager
//
//  Created by 文静 on 16/6/2.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

class MQRefreshControl: UIRefreshControl {

    override init() {
        super.init()
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setUpUI()
    }
    
    private func setUpUI(){
        
        // 隐藏转轮
        tintColor = UIColor.clearColor()
        
        // 添加控件
        addSubview(refreshView)
        
        // 自动布局
        refreshView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: refreshView.bounds.size)
        
    }
    // MARK: - 懒加载控件
    private lazy var refreshView = MQRefreshView.refreshViews()
    
}

/// 刷新视图，单独负责显示内容&动画
class MQRefreshView: UIView {
    /// 负责从 XIB 加载视图
    class func refreshViews() -> MQRefreshView{
        return NSBundle.mainBundle().loadNibNamed("MQRefreshView", owner: nil, options: nil).last as! MQRefreshView
    }
}