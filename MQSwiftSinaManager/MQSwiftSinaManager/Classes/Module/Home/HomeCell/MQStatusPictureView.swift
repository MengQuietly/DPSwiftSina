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
    
    /// 微博数据视图模型
    var statusViewModel: MQStatusViewModel? {
        didSet{
            sizeToFit()
        }
    }
    
    /// 设置视图大小
    /// 当调用 ‘sizeToFit()’ 方法时，系统会调用此方法，此方法又会调用 ‘setPictureSize()’ 方法
    ///
    /// - returns: ‘-> CGSize’ 表设置当前视图大小
    override func sizeThatFits(size: CGSize) -> CGSize {
        return setPictureSize()
    }
    
    /// 根据模型中的图片数量来计算视图大小
    private func setPictureSize() -> CGSize{
        
        // 1. 准备工作
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
      
        // 设置默认大小
        layout.itemSize = CGSize(width: MQStatusPictureItemWith, height: MQStatusPictureItemWith)
        
        // 2. 根据图片数量来计算大小
        let pictureCount = statusViewModel?.thumbnailURLs?.count ?? 0
        
        // 1> 没有图
        if pictureCount == 0 {
            return CGSizeZero
        }
        
        // 2> 1张图
        if pictureCount == 1 {
            // TODO: - 临时返回一个大小
            let size = CGSize(width: 150, height: 150)
            layout.itemSize = size
            return size
        }
        
        // 3> 4张图 2 * 2
        if pictureCount == 4 {
            let w = 2 * MQStatusPictureItemWith + MQStatusPictureItemMargin
            return CGSize(width: w, height: w)
        }
        
        // 4> 其他
        /**
         2, 3,
         5, 6,
         7, 8, 9
         */
        // 计算显示图片的行数
        let pictureRow = CGFloat((pictureCount - 1) / Int(MQStatusPictureRowMaxCount) + 1)
        let pictureH = (MQStatusPictureItemWith + MQStatusPictureItemMargin) * pictureRow - MQStatusPictureItemMargin
        
        return CGSize(width: MQStatusPictureMaxWith, height: pictureH)
    }

    // 构造函数的调用是底层自动转发的 init() -> initWithFrame -> initWithFrame:layout:
    // 默认的 layout 没有被初始化
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        // 注意：必须使用 UICollectionViewFlowLayout() 对 colectionView 进行初始化
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        backgroundColor = UIColor.redColor()
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = MQStatusPictureItemMargin
        layout.minimumLineSpacing = MQStatusPictureItemMargin
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
