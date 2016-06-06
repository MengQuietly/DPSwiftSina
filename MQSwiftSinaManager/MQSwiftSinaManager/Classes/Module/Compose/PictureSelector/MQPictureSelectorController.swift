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
class MQPictureSelectorController: UICollectionViewController, MQPictureSelectorCellWithRemoveBtnDelegate  {

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
        self.collectionView!.registerClass(MQPictureSelectorCell.self, forCellWithReuseIdentifier: MQPictureSelectorCellID)

    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MQPictureSelectorCellID, forIndexPath: indexPath) as! MQPictureSelectorCell
        
        cell.backgroundColor = UIColor.redColor()
        // 设置代理
        cell.pictureCloseDelegate = self
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        printLog("---item:\(indexPath.item)")
    }
    
    // MARK: - PictureSelectorCellDelegate
    private func pictureSelectorCellClickRemoveButton(cell: MQPictureSelectorCell){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

/// 照片 Cell closeBtn 协议
private protocol MQPictureSelectorCellWithRemoveBtnDelegate: NSObjectProtocol {
    
    /// 选中删除按钮 - collectionView / tableView Cell 一个视图会包含多个 cell，在定义代理方法的时候，一定要传 cell
    /// 通过 cell 的属性，控制器能够判断出点击的对象
    func pictureSelectorCellClickRemoveButton(cell: MQPictureSelectorCell)
}

/// 照片选择 Cell
private class MQPictureSelectorCell: UICollectionViewCell {
    
    /// 定义代理
    weak var pictureCloseDelegate: MQPictureSelectorCellWithRemoveBtnDelegate?
    
    /// 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpUI() {
        // 添加控件
        contentView.addSubview(pictureBtn)
        contentView.addSubview(removeButton)
        
        // 自动布局
        pictureBtn.frame = bounds
        
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        let viewDict = ["btn":removeButton]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[btn]-0-|", options: [], metrics: nil, views: viewDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[btn]", options: [], metrics: nil, views: viewDict))
        
        // 禁用 照片选择按钮 - 就可以触发 collectionView 的 didSelected 代理方法
        // 禁用按钮有一个损失：不会再显示高亮图像
        pictureBtn.userInteractionEnabled = false
        
        // 添加监听方法
        removeButton.addTarget(self, action: #selector(removeButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    /// 点击删除按钮事件
    @objc private func removeButtonClick() {
        printLog("－－－点击删除按钮")
        
        pictureCloseDelegate?.pictureSelectorCellClickRemoveButton(self)
        
    }
    
    /// 懒加载控件
    /// 添加照片按钮
    private lazy var pictureBtn = UIButton(imageName: "compose_pic_add")
    /// 删除照片按钮
    private lazy var removeButton: UIButton = UIButton(imageName: "compose_photo_close")
}

