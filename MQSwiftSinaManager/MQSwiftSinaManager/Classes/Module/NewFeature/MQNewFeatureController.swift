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
    
    // 此代理方法中的 indexPath 参数是之前显示的 cell 的 indexPath，所以获取当前 cell 需自己获取
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        // 取出当前显示的 Cell 的indexPath
        let path = collectionView.indexPathsForVisibleItems().last!
        
        // 是否为最后一个item
        if path.item == MQNewFeatureImageCount - 1  {
            // 获取cell
            let cell = collectionView.cellForItemAtIndexPath(path)  as! MQNewFeatureControllerCell
            cell.startBtnWithAnimationShow()
        }
    }
}

/// 新特性 Cell，private 保证此 cell 只被当前控制器使用,在当前文件中，所有的 private 都是摆设
private class MQNewFeatureControllerCell: UICollectionViewCell{
    // frame 的大小来自于 layout 的 itemSize
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    // 图像索引属性
    private var iconIndex = 0 {
        didSet {
            iconView.image = UIImage(named: "new_feature_\(iconIndex + 1)")
            pointView.currentPage = iconIndex
            startBtn.hidden = true
        }
    }
    
    // MARK: - 懒加载属性：
    // 图像视图
    private lazy var iconView = UIImageView()
    // 索引点
    private lazy var pointView : UIPageControl = {
        let pointViews = UIPageControl()
        pointViews.hidesForSinglePage = true
        pointViews.numberOfPages = MQNewFeatureImageCount
        pointViews.currentPageIndicatorTintColor =  UIColor.orangeColor()
        pointViews.pageIndicatorTintColor = UIColor.grayColor()
        pointViews.backgroundColor = UIColor.clearColor()
        return pointViews
    }()
    
    // 开始按钮
    private lazy var startBtn : UIButton = {
        let startBtns = UIButton()
    
        startBtns.setBackgroundImage(UIImage(named:"new_feature_button"), forState: UIControlState.Normal)
        startBtns.setBackgroundImage(UIImage(named:"new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        startBtns.sizeToFit()
        startBtns.addTarget(self, action: #selector(startBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return startBtns
    }()
    
    // 启动按钮点击事件：若类是 private 的，即使没有对方法进行修饰，运行循环同样无法调用监听方法，所以必须加 @Objc
    @objc private func startBtnClick(){
        printLog(#function)
        NSNotificationCenter.defaultCenter().postNotificationName(MQSwitchRootViewControllerNotification, object: nil)
    }
    
    // 设置界面元素
    private func setUpUI(){
        // 添加控件
        addSubview(iconView)
        addSubview(startBtn)
        addSubview(pointView)
        
        // 指定布局
        iconView.frame = bounds
        
        // 自动布局约束是添加在父视图上的
        startBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: startBtn, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: startBtn, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -80))
        
        // 索引点布局
        pointView.frame.size = CGSizeMake(20 * CGFloat(MQNewFeatureImageCount), 20)
        pointView.translatesAutoresizingMaskIntoConstraints = false;
        addConstraint(NSLayoutConstraint(item: pointView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: pointView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -20))
    }
    
    // 动画显示启动按钮
    private func startBtnWithAnimationShow(){
        startBtn.hidden = false
        startBtn.transform = CGAffineTransformMakeScale(0, 0)
        // usingSpringWithDamping：弹性系数，0-1，越小越弹
        // initialSpringVelocity：初始速度
        UIView.animateWithDuration(1.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: { 
            self.startBtn.transform = CGAffineTransformIdentity
            }) { (_) in
                
        }
    }
}
