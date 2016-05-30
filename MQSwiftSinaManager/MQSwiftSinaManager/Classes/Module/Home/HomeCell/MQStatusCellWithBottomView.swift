//
//  MQStatusCellWithBottomView.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/30.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

class MQStatusCellWithBottomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI(){
        // 设置背景颜色
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        // 添加控件
        addSubview(forwardButton)
        addSubview(commonButton)
        addSubview(likeButton)
        
        // 自动布局
        ff_HorizontalTile([forwardButton, commonButton, likeButton], insets: UIEdgeInsetsZero)
    }

    // MARK: - 懒加载
    private lazy var forwardButton: UIButton = UIButton(title: " 转发", imageName: "timeline_icon_retweet", color: UIColor.darkGrayColor(), fontSize: 12)
    private lazy var commonButton: UIButton = UIButton(title: " 评论", imageName: "timeline_icon_comment", color: UIColor.darkGrayColor(), fontSize: 12)
    private lazy var likeButton: UIButton = UIButton(title: " 赞", imageName: "timeline_icon_unlike", color: UIColor.darkGrayColor(), fontSize: 12)
}
