//
//  MQStatusCell.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/30.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 控件间的间距
private let MQStatusCellMargin: CGFloat = 12

/// 微博Cell
class MQStatusCell: UITableViewCell {
    
    /// 微博数据视图模型
    var statusViewModel: MQStatusViewModel? {
        didSet{
            // 模型数值被设置之后，马上要产生的连锁反应 - 界面UI发生变化
            cellWithTopView.statusViewModel = statusViewModel
        }
    }
    
    // MARK: - 搭建界面
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI(){
        // 添加控件
        contentView.addSubview(cellWithTopView)
        
        // 自动布局
        cellWithTopView.ff_AlignInner(type: ff_AlignType.TopRight, referView: contentView, size: CGSize(width: MQAppWith, height: 50))
    }
    
    // MARK: - 懒加载
    private lazy var cellWithTopView:MQStatusCellWithTopView = MQStatusCellWithTopView()
    private lazy var cellWithBottomView:MQStatusCellWithBottomView = MQStatusCellWithBottomView()
    private lazy var contentLabel = UILabel(title: nil, color: UIColor.darkGrayColor(), fontSize: 15, layoutWidth: MQAppWith - 2 * MQStatusCellMargin)
    
    
}
