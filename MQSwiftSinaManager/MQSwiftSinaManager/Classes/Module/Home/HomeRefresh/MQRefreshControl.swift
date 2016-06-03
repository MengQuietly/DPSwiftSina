//
//  MQRefreshControl.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/6/2.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 向下拖拽的偏移量，超过 -60 旋转箭头
private let MQRefreshControlMaxOffsetY: CGFloat = -60

/// 刷新控件，负责和控制器交互
class MQRefreshControl: UIRefreshControl {
    
    /// 停止刷新
    override func endRefreshing() {
        super.endRefreshing()
        // 停止动画
        refreshView.stopAnimation()
    }

    // MARK: - KVO 监听方法
    // 监听对象的 key value 一旦变化，就会调用此方法
    // 越向下 y 越小，小到一定程度，自动进入刷新状态
    // 越向上推动表格，y值越大，刷新控件始终在视图上
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        // 判断是否是上拉（上拉不反应）
        if frame.origin.y > 0 {
            return
        }
        
        // 判断是否正在刷新
        if refreshing {
            refreshView.loadingAnimation()
            return
        }
        
        if frame.origin.y < MQRefreshControlMaxOffsetY && !refreshView.rotateFlag {
            printLog("反过来")
            refreshView.rotateFlag = true
        } else if frame.origin.y >= MQRefreshControlMaxOffsetY && refreshView.rotateFlag{
            printLog("转过去")
            refreshView.rotateFlag = false
        }
    }
    
    // 销毁 KVO 监听
    deinit {
        self.removeObserver(self, forKeyPath: "frame")
    }
    
    // MARK: - 构造函数
    override init() {
        super.init()
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {        
        super.init() // coder: aDecoder

        setUpUI()
    }
    
    private func setUpUI(){
        
        // KVO － self 监听 self.frame
        self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        
        // 隐藏转轮
        tintColor = UIColor.clearColor()
        
        // 添加控件
        addSubview(refreshView)
        
        // 自动布局
        refreshView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: refreshView.bounds.size)
        
    }
    // MARK: - 懒加载控件
    private lazy var refreshView = MQRefreshView.refreshViews()
    
}

/// 刷新视图，单独负责显示内容&动画
class MQRefreshView: UIView {
    
    /// 旋转标记
    private var rotateFlag = false{
        didSet {
            rotateTipAnimation()
        }
    }
    
    /// 加载图标（圆圈）
    @IBOutlet weak var loadingImg: UIImageView!
    /// 提示视图
    @IBOutlet weak var tipView: UIView!
    /// 下拉提示图标（箭头）
    @IBOutlet weak var pullRefreshImg: UIImageView!
    
    /// 负责从 XIB 加载视图
    class func refreshViews() -> MQRefreshView{
        return NSBundle.mainBundle().loadNibNamed("MQRefreshView", owner: nil, options: nil).last as! MQRefreshView
    }
    
    /// 旋转提示图标动画
    private func rotateTipAnimation(){
        
        // 若旋转为 2 ＊ M_PI，则就近原则，就不会有任何效果
        var angle = CGFloat(M_PI)
        angle += rotateFlag ? -0.01 : 0.01
        
        UIView.animateWithDuration(1.0) {
            
            // 在 iOS 的 block 动画中，旋转是默认顺时针，就近原则
            self.pullRefreshImg.transform = CGAffineTransformRotate(self.pullRefreshImg.transform, angle)
        }
    }
    
    /// 加载动画
    private func loadingAnimation(){
        
        // 通过 key 能够拿到图层上的动画
        let loadAnimKey = "loadAnimKey"
        if loadingImg.layer.animationForKey(loadAnimKey) != nil {
            return
        }
        
        // 隐藏箭头刷新视图
        tipView.hidden = true
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 1
        
        loadingImg.layer.addAnimation(anim, forKey: loadAnimKey)
    }
    
    /// 停止动画
    private func stopAnimation(){
        tipView.hidden = false
        
        loadingImg.layer.removeAllAnimations()
    }
}