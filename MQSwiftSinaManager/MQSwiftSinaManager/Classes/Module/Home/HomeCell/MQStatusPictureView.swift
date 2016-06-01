//
//  MQStatusPictureView.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/31.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 可重用标识符
private let MQStatusPictureViewCellID = "MQStatusPictureViewCellID"

/// 微博图片视图
class MQStatusPictureView: UICollectionView {
    
    /// 微博数据视图模型
    var statusViewModel: MQStatusViewModel? {
        didSet{
            sizeToFit()
            
            // 刷新数据
            reloadData()
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
        
        // 4> 其他 2, 3, 5, 6, 7, 8, 9
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
        
        backgroundColor = UIColor.whiteColor()
        
        // 设置布局的间距
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = MQStatusPictureItemMargin
        layout.minimumLineSpacing = MQStatusPictureItemMargin
        
        // 指定数据源 － 让自己当自己的数据源
        // 1. 在自定义 view 中，代码逻辑相对简单，可以考虑自己充当自己的数据源
        // 2. dataSource & delegate 本身都是弱引用，自己充当自己的代理不会产生循环引用
        // 3. 除了配图视图，自定义 pickerView(省市联动的)
        dataSource = self
        // 注册可重用 cell
        registerClass(MQStatusPictureViewCell.self, forCellWithReuseIdentifier: MQStatusPictureViewCellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MQStatusPictureView: UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statusViewModel?.thumbnailURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MQStatusPictureViewCellID, forIndexPath: indexPath) as! MQStatusPictureViewCell
        cell.iconImgUrl = statusViewModel?.thumbnailURLs![indexPath.item]
        
        return cell
    }
}

/// 配图视图的 Cell
private class MQStatusPictureViewCell : UICollectionViewCell{
    
    /// 配图视图的 URL
    var iconImgUrl: NSURL?{
        didSet {
            iconView.sd_setImageWithURL(iconImgUrl)
        }
    }
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 添加控件
        addSubview(iconView)
        // 自动布局
        iconView.ff_Fill(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载
    private let iconView: UIImageView = UIImageView()
}
