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
    
    // MARK: - 懒加载
    private lazy var cellWithTopView:MQStatusCellWithTopView = MQStatusCellWithTopView()
    private lazy var cellWithBottomView:MQStatusCellWithBottomView = MQStatusCellWithBottomView()
    private lazy var contentLabel = UILabel(title: nil, color: UIColor.darkGrayColor(), fontSize: 15, layoutWidth: MQAppWith - 2 * MQStatusCellMargin)
    
}
