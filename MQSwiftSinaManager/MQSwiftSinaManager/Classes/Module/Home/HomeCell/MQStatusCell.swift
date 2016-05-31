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
 /// 默认 pictureItem 大小
let MQStatusPictureItemWith: CGFloat = 90
 /// 默认 pictureItem 间距
let MQStatusPictureItemMargin: CGFloat = 10

/// 默认 picture 每行最大图片数量
let MQStatusPictureRowMaxCount: CGFloat = 3
/// 默认 picture 最大尺寸
let MQStatusPictureMaxWith: CGFloat = (MQStatusPictureItemWith + MQStatusPictureItemMargin) * MQStatusPictureRowMaxCount - MQStatusPictureItemMargin

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
        
        selectionStyle = UITableViewCellSelectionStyle.None
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI(){
        cellTopSepView.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        // 1.添加控件
        contentView.addSubview(cellTopSepView)
        contentView.addSubview(cellWithTopView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(cellWithBottomView)
        
        // 2.自动布局
        // 1> 顶部分隔视图
        cellTopSepView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSize(width: MQAppWith, height: 10))
        
        // 2> 顶部视图
        cellWithTopView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: cellTopSepView, size: CGSize(width: MQAppWith, height: 50))
        
        // 3> 正文标签
        contentLabel.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: cellWithTopView, size: nil, offset: CGPoint(x: MQStatusCellMargin, y: MQStatusCellMargin))
        
        // 4> 配图视图
        pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: MQStatusPictureMaxWith,height: MQStatusPictureMaxWith), offset: CGPoint(x: 0, y: MQStatusCellMargin))
        
        // 5> 底部视图
        cellWithBottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: MQAppWith,height: 44), offset: CGPoint(x: -MQStatusCellMargin, y: MQStatusCellMargin))
        
        // 指定底部视图相对底边约束(设置了tableview 自动检索行高，需设置此约束)
        cellWithBottomView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: contentView, size: nil)
    }
    
    // MARK: - 懒加载 - 从上倒下，从左到右 的顺序来写懒加载的代码，便于后期的维护
    // 1.顶部分割视图
    private lazy var cellTopSepView:UIView = UIView()
    /// 2. 顶部视图
    private lazy var cellWithTopView:MQStatusCellWithTopView = MQStatusCellWithTopView()
    /// 3. 文本标签
    private lazy var contentLabel = UILabel(title: nil, color: UIColor.darkGrayColor(), fontSize: 15, layoutWidth: MQAppWith - 2 * MQStatusCellMargin)
    /// 4. 配图视图
    private lazy var pictureView:MQStatusPictureView = MQStatusPictureView()
    /// 5. 底部视图
    private lazy var cellWithBottomView:MQStatusCellWithBottomView = MQStatusCellWithBottomView()
    
}

extension MQStatusCell{
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        self.alpha = highlighted ? 0.4 :1.0
    }
}
