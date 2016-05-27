//
//  MQNewFeatureController.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/27.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

// 可重用标识符号
private let MQNewFeatureCollectionViewCellID = "MQNewFeatureCollectionViewCellID"
/// 新特性图片数量
private let MQNewFeatureImageCount = 4

/// 新特性界面
class MQNewFeatureController: UICollectionViewController {

    /// 实现 init() 构造函数，方便外部代码调用，不需额外指定布局属性
    /// 注意： 这里的 init() 方法前不需要添加 override
    /// - returns: <#return value description#>
    init(){
        // 调用父类默认构造函数初始化 UICollectionView
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 注册可重用 cell
        // 注意：UITableViewCell.class 而这里是：UICollectionViewCell.self
        self.collectionView!.registerClass(MQNewFeatureControllerCell.self, forCellWithReuseIdentifier: MQNewFeatureCollectionViewCellID)
        
        prepareLayout()
    }

    /// 准备布局
    private func prepareLayout() {
        // 获得当前布局属性
        let layouts = collectionViewLayout as! UICollectionViewFlowLayout
        
        layouts.itemSize = view.bounds.size
        layouts.minimumInteritemSpacing = 0
        layouts.minimumLineSpacing = 0
        layouts.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MQNewFeatureImageCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MQNewFeatureCollectionViewCellID, forIndexPath: indexPath) as! MQNewFeatureControllerCell
    
        cell.iconIndex = indexPath.item
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

/// 新特性 Cell，private 保证此 cell 只被当前控制器使用
private class MQNewFeatureControllerCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    var iconIndex = 0 {
        didSet {
            iconView.image = UIImage(named: "new_feature_\(iconIndex + 1)")
        }
    }
    
    // MARK: - 懒加载属性：图像视图
    private lazy var iconView = UIImageView()
    
    // 设置界面元素
    private func setUpUI(){
        // 添加控件
        addSubview(iconView)
        
        // 指定布局
        iconView.frame = bounds
    }
}
