//
//  MQStatusForwardCell.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/6/1.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 转发微博 cell
class MQStatusForwardCell: MQStatusCell {
    
    /// 重写父类的 － 微博数据视图模型
    /// 不需要 super，父类的 didSet 仍然能够正常执行 -> 只需要设置子类的控件内容
    override var statusViewModel: MQStatusViewModel? {
        didSet{
            forwardLabel.text = statusViewModel?.forwardText
        }
    }
    
    // 设置 UI（重写 父类 MQStatusCell 的 ）
    override func setUpUI() {
        
        // 执行父类的方法
        super.setUpUI()
        
        // 添加控件
        contentView.insertSubview(backgroundBtn, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: backgroundBtn)
        
        // 设置布局
        // 1> 背景按钮
        backgroundBtn.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -MQStatusCellMargin, y: MQStatusCellMargin))
        backgroundBtn.ff_AlignVertical(type: ff_AlignType.TopRight, referView: cellWithBottomView, size: nil)
        
        // 2> 转发文字
        forwardLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: backgroundBtn, size: nil, offset: CGPoint(x: MQStatusCellMargin, y: MQStatusCellMargin))
        
        // 4> 配图视图
        let pictureCons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: forwardLabel, size: CGSize(width: MQStatusPictureMaxWith,height: MQStatusPictureMaxWith), offset: CGPoint(x: 0, y: MQStatusCellMargin))
        // 记录配图视图约束
        pictureViewWidthLayout = pictureView.ff_Constraint(pictureCons, attribute: NSLayoutAttribute.Width)
        pictureViewHeightLayout = pictureView.ff_Constraint(pictureCons, attribute: NSLayoutAttribute.Height)
        pictureViewTopLayout = pictureView.ff_Constraint(pictureCons, attribute: NSLayoutAttribute.Top)
    }

    // MARK: - 懒加载控件
    /// 转发背景颜色按钮
    private lazy var backgroundBtn:UIButton = {
        let backgroundBtns = UIButton()
        backgroundBtns.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        return backgroundBtns
    }()
    
    /// 转发的文字
    private lazy var forwardLabel = UILabel(title: "转发weibo微博",color: UIColor.darkGrayColor(),fontSize: 14,layoutWidth: MQAppWith - 2 * MQStatusCellMargin)
    
}
