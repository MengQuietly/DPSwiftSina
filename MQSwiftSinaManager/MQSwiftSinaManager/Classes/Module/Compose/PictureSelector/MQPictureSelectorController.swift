//
//  MQPictureSelectorController.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/6/5.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 可重用标识符
private let MQPictureSelectorCellID = "MQPictureSelectorCellID"
/// 最大选择照片数量
private let MQChooseMaxPictureCount = 9

// 照片选择器
class MQPictureSelectorController: UICollectionViewController,MQPictureSelectorCellWithRemoveBtnDelegate {
    
    // MARK: - 懒加载控件
    /// 照片数组 - 数据源
    private lazy var choosePictureArray = [UIImage]()
    /// 用户当前选中照片索引
    private var currentChoosePicture = 0
    
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
        // 至少要有一个按钮允许用户添加照片，如果达到最大数量限制，就不再添加
        return choosePictureArray.count + (choosePictureArray.count == MQChooseMaxPictureCount ? 0 : 1)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MQPictureSelectorCellID, forIndexPath: indexPath) as! MQPictureSelectorCell
        
        // 设置代理
        cell.pictureCloseDelegate = self
        
        // 设置图片，比数据源多一个，让最后一个作为添加照片的按钮
        cell.chooseImages = indexPath.item < choosePictureArray.count ? choosePictureArray[indexPath.item] : nil
        
        return cell
    }
    
    /// 选择照片
    /// Camera              相机
    /// PhotoLibrary        照片库 － 包含相册，包括通过 iTunes / iPhoto 同步的照片，同步的照片不允许在手机删除
    /// SavedPhotosAlbum    相册 － 相机拍摄，应用程序保存的图片，可以删除
    /// 是否允许编辑： pickVC.allowsEditing = true
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        printLog("---item:\(indexPath.item)")
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            printLog("无法访问相册")
            return
        }
        
        // 记录用户当前选中的照片
        currentChoosePicture = indexPath.item
        
        // 访问相册
        let pickVC = UIImagePickerController()
        
        // 监听照片选择
        pickVC.delegate = self
        
        presentViewController(pickVC, animated: true, completion: nil)
        
    }
    
    // MARK: - PictureSelectorCellDelegate
    private func pictureSelectorCellClickRemoveButton(cell: MQPictureSelectorCell){
        
        // 根据 cell 获得当前的索引
        if let indexPaths = collectionView?.indexPathForCell(cell) where indexPaths.item < choosePictureArray.count  {
            
            // 删除对应索引的图像
            choosePictureArray.removeAtIndex(indexPaths.item)
            
            // 刷新视图
            collectionView?.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MQPictureSelectorController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 选中照片代理方法
    ///
    /// - parameter picker:      picker 选择控制器
    /// - parameter image:       选中的图像
    /// - parameter editingInfo: 编辑字典，在开发选择用户头像时，格外有用！vc.allowsEditing = true
    ///                          一旦允许编辑，选中的图像会小
    ///
    /// 一旦实现了代理方法，就需要自己关闭控制器
    /// 凡事开发相册相关的应用，大多需要考虑内存的问题
    /// UIImageJPEGRepresentation 会严重影响图片质量
    /// 关于应用程序内存，UI的App空的程序运行占用 20M 左右，一个cocos2dx空模板建立应用程序运行会占 70M 内存
    /// 一般程序消耗在 100M 以内都是可以接受的
    /// 参考数据：在 5s 一次测试数据，一直 sdwebimage 加载网络图像
    /// 内存飙升到 500M 接收到第一次内存警告！内存释放后的结果120M，程序仍然能够正常运行
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // 用户是否选中了“＋”照片
        if currentChoosePicture < choosePictureArray.count {
            // 替换当前选中的图片
            choosePictureArray[currentChoosePicture] = image
        }else{
            // 追加照片
            choosePictureArray.append(image)
        }
        // 刷新视图
        collectionView?.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
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
    
    // 设置 ＋ 按钮图片
    var chooseImages: UIImage?{
        didSet{
            
            if chooseImages != nil {
                pictureBtn.setImage(chooseImages, forState: .Normal)
            } else {
                // 显示默认的加号图片
                pictureBtn.setImage(UIImage(named: "compose_pic_add"), forState: .Normal)
            }
            // 如果没有图像，隐藏删除按钮
            removeButton.hidden = (chooseImages == nil)
        }
    }
    
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
