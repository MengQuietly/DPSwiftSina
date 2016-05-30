//
//  MQUserInfo.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/30.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import Foundation

/// 用户模型
class MQUserInfo: NSObject {

    /// 用户UID
    var id: Int = 0
    /// 友好显示名称
    var name: String?
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    /// 认证类型 -1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified: Int = 0
    /// 会员等级 1-6
    var mbrank: Int = 0

    // MARK: - 构造函数
    init(dict:[String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String{
        let keys = ["id", "name", "profile_image_url", "verified", "mbrank"]
        return dictionaryWithValuesForKeys(keys).description
    }
}
