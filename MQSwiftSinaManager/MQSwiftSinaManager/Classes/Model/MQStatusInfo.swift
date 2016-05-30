//
//  MQStatusInfo.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/29.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 微博模型
class MQStatusInfo: NSObject {
    /// 创建时间
    var created_at: String?
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
    /// 用户模型 － 如果直接使用 KVC，会变成字典
    var user: MQUserInfo?
    
    // MARK: - 构造函数
    // NSArray & NSDictionary 在 swfit 中极少用，contentOfFile  加载 plist 才会用
    init(dict:[String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        // 判断 key 是否是 "User"
        if key == "user" {
            // 如果 key 是 user, value 是字典
            // 调用 User 的构造函数创建 user 对象属性
            user = MQUserInfo(dict: value as! [String: AnyObject])
            // 如果不return，user 属性又会被默认的 KVC 方法，设置成字典
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String{
        let keys = ["created_at", "id", "text", "source","user"]
        return dictionaryWithValuesForKeys(keys).description
    }
}
