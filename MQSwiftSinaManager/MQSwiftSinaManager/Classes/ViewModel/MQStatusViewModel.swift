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
    
    /// 用户头像 URL
    var avatarUrl : NSURL?{
        return NSURL(string: statusInfo.user!.profile_image_url ?? "")
    }
    
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
        super.init()
    }
}
