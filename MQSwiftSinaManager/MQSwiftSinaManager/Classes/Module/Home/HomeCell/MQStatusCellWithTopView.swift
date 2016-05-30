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
            // 设置 微博姓名
            nameLabel.text = statusViewModel?.statusInfo.user?.name
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
        
        // 1.添加控件
        addSubview(avatarImg)
        addSubview(nameLabel)
        addSubview(memberImg)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        // 2.自动布局
        let offset = CGPoint(x: MQStatusCellMargin, y: 0)
        
        avatarImg.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: CGSize(width: MQStatusAvatarWidth, height: MQStatusAvatarWidth), offset: CGPoint(x: MQStatusCellMargin, y: MQStatusCellMargin))
        nameLabel.ff_AlignHorizontal(type: ff_AlignType.TopRight, referView: avatarImg, size: nil, offset: offset)
        memberImg.ff_AlignHorizontal(type: ff_AlignType.TopRight, referView: nameLabel, size: nil, offset: offset)
        timeLabel.ff_AlignHorizontal(type: ff_AlignType.BottomRight, referView: avatarImg, size: nil, offset: offset)
        sourceLabel.ff_AlignHorizontal(type: ff_AlignType.BottomRight, referView: timeLabel, size: nil, offset: offset)
    }
    
    // MARK: - 懒加载
    // 头像
    private lazy var avatarImg = UIImageView(image: UIImage(named: "avatar_default_big"))
    // 昵称
    private lazy var nameLabel = UILabel(title: "宝宝", color: UIColor.darkGrayColor(), fontSize: 14)
    // VIP
    private lazy var memberImg = UIImageView(image: UIImage(named: "common_icon_membership_level1"))
    // 时间
    private lazy var timeLabel = UILabel(title: "刚刚", color: UIColor.orangeColor(), fontSize: 10)
    // 来源
    private lazy var sourceLabel = UILabel(title: "来自 新浪微博", color: UIColor.darkGrayColor(), fontSize: 10)
    
}
