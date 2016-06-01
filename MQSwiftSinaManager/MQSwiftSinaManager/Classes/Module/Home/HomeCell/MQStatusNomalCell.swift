//
//  MQStatusNomalCell.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/6/1.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 原创微博 cell
class MQStatusNomalCell: MQStatusCell {
    override func setUpUI() {
        super.setUpUI()
        
        // 4> 配图视图
        let pictureCons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: MQStatusPictureMaxWith,height: MQStatusPictureMaxWith), offset: CGPoint(x: 0, y: MQStatusCellMargin))
        // 记录配图视图约束
        pictureViewWidthLayout = pictureView.ff_Constraint(pictureCons, attribute: NSLayoutAttribute.Width)
        pictureViewHeightLayout = pictureView.ff_Constraint(pictureCons, attribute: NSLayoutAttribute.Height)
        pictureViewTopLayout = pictureView.ff_Constraint(pictureCons, attribute: NSLayoutAttribute.Top)

    }
}
