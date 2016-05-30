//
//  MQStatusCell.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/30.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 控件间的间距
let MQStatusCellMargin: CGFloat = 12
/// 头像大小
let MQStatusAvatarWidth: CGFloat = 35

/// 微博Cell
class MQStatusCell: UITableViewCell {
    
    /// 微博数据视图模型
    var statusViewModel: MQStatusViewModel? {
        didSet{
            // 模型数值被设置之后，马上要产生的连锁反应 - 界面UI发生变化
            cellWithTopView.statusViewModel = statusViewModel
            contentLabel.text = statusViewModel?.statusInfo.text
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
        // 1.添加控件
        contentView.addSubview(cellWithTopView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(cellWithBottomView)
        
        // 2.自动布局
        cellWithTopView.ff_AlignInner(type: ff_AlignType.TopRight, referView: contentView, size: CGSize(width: MQAppWith, height: 50))
        contentLabel.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: cellWithTopView, size: nil, offset: CGPoint(x: MQStatusCellMargin, y: MQStatusCellMargin))
        cellWithBottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: MQAppWith,height: 44), offset: CGPoint(x: -MQStatusCellMargin, y: MQStatusCellMargin))
    }
    
    // MARK: - 懒加载
    private lazy var cellWithTopView:MQStatusCellWithTopView = MQStatusCellWithTopView()
    private lazy var cellWithBottomView:MQStatusCellWithBottomView = MQStatusCellWithBottomView()
    private lazy var contentLabel = UILabel(title: nil, color: UIColor.darkGrayColor(), fontSize: 15, layoutWidth: MQAppWith - 2 * MQStatusCellMargin)
    
    
}
