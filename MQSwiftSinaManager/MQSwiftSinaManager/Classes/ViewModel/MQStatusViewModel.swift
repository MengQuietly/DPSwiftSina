//
//  MQStatusViewModel.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/30.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 微博的视图模型，供界面显示使用
class MQStatusViewModel: NSObject {
   
    /// 微博对象
    var statusInfo : MQStatusInfo
    
    /// 当前模型对应的缓存行高
    var cellRowHeight: CGFloat = 0
    
    /// 被转发的原创微博文字，格式: @作者:原文
    var forwardText: String?{
        let userName = statusInfo.retweeted_status?.user?.name ?? ""
        let forwardTitle = statusInfo.retweeted_status?.text ?? ""
        
        return "@\(userName):\n\(forwardTitle)"
    }
    
    /// 用户头像 URL
    var avatarUrl : NSURL?{
        return NSURL(string: statusInfo.user!.profile_image_url ?? "")
    }
    
    /// 如果是原创微博有图，在 pic_urls 数组中记录
    /// 如果是`转发微博`有图，在 retweeted_status.pic_urls 数组中记录
    /// 如果`转发微博`有图，pic_urls 数组中没有图
    /// 配图缩略图 URL 数组
    var thumbnailURLs: [NSURL]?
    
    /// 认证类型 -1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    /// imageWithNamed 方法能够缓存图像，所以两个计算型属性的效率不会受到影响
    /// 设置计算型属性的时候，需要考虑到性能
    var vipImg : UIImage?{
        switch statusInfo.user?.verified ?? -1 {
        case 0:
            return UIImage(named: "avatar_vip")
        case 2,3,5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:
            return UIImage(named: "avatar_grassroot")
        default:
            return nil
        }
    }
    
    /// 会员等级 1-6
    var memberImg : UIImage?{
        if statusInfo.user?.mbrank > 0 && statusInfo.user?.mbrank < 7 {
            return UIImage(named: "common_icon_membership_level\(statusInfo.user!.mbrank)")
        }
        return nil
    }
    
    // MARK: - 构造函数
    init(statusInfos: MQStatusInfo) {
        self.statusInfo = statusInfos
        
        // 给缩略图数组设置数值
        // 转发的原创微博有图，statusInfos.pic_urls 一定没有图
        // 原创（statusInfos.pic_urls）是否有图像，转发（statusInfos.retweeted_status?.pic_urls）是否有图像
        if let picUrlsList = statusInfos.retweeted_status?.pic_urls ?? statusInfos.pic_urls {
            
            thumbnailURLs = [NSURL]()
            
            // 遍历数组，插入 URL
            for dict in picUrlsList {
                // 第一个 `!` 确保字典中 thumbnail_pic `key` 一定存在
                // 第二个 `!` 确保后台返回 URL字符串 一定能创建出 URL，通常由后台返回的URL是添加过百分号转义的！
                thumbnailURLs?.append(NSURL(string: dict["thumbnail_pic"]!)!)
            }

        }
        
        super.init()
    }
    
    override var description: String {
        return statusInfo.description + " 缩略图 URL 数组 \(thumbnailURLs)"
    }
}
