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
    
    // MARK: - 构造函数
    // NSArray & NSDictionary 在 swfit 中极少用，contentOfFile  加载 plist 才会用
    init(dict:[String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String{
        let keys = ["created_at", "id", "text", "source"]
        return dictionaryWithValuesForKeys(keys).description
    }
}
