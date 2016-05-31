//
//  MQStatusPictureView.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/31.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 微博图片视图
class MQStatusPictureView: UICollectionView {

    // 构造函数的调用是底层自动转发的 init() -> initWithFrame -> initWithFrame:layout:
    // 默认的 layout 没有被初始化
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        // 注意：必须使用 UICollectionViewFlowLayout() 对 colectionView 进行初始化
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        backgroundColor = UIColor.redColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
