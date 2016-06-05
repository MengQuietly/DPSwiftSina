//
//  MQPictureSelectorController.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/6/5.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

// 可重用标识符
private let MQPictureSelectorCellID = "MQPictureSelectorCellID"

// 照片选择器
class MQPictureSelectorController: UICollectionViewController {

    // MARK: - 搭建界面
    init() {
        let layout = UICollectionViewFlowLayout()
        // 初始化 collectionView
        super.init(collectionViewLayout: layout)
        
        // 设置布局 -> 屏幕越大，展现的内容越多！不完全是等比例放大！
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        // 注册可重用 cell
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: MQPictureSelectorCellID)

    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MQPictureSelectorCellID, forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.redColor()
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
