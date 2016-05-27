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
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: MQNewFeatureCollectionViewCellID)
        
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MQNewFeatureCollectionViewCellID, forIndexPath: indexPath)
    
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.redColor() : UIColor.greenColor()
    
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
