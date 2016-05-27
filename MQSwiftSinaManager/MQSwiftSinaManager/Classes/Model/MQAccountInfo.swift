//
//  MQAccountInfo.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/20.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

/// 账户信息
class MQAccountInfo: NSObject,NSCoding {
    
    /// 用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别
    var access_token :String?
    
    /// access_token的生命周期，单位是秒数。
    /// token是不安全的，对于第三方的接口，只能访问有限的资源
    /// 开发者的有效期是5年，一般用户是3天，在程序开发中，一定注意判断token是否过期
    /// 如果过期，需要用户重新登录
    var expires_in :NSTimeInterval = 0{
        // didSet 作用：当 expires_in 属性变化后，在此方法中更新 expires_date
        didSet {
            // 计算过期日期
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    // 过期日期
    var expires_date: NSDate?
    
    /// 授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。
    var uid :String?
    
    var name :String?
    
    var avatar_large :String?
    
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /// 打印对象时，输出详细信息（便于调试，自定义对象重写此方法）
    /// 在 Swift / OC 中，任何对象都有一个 description 的属性，用处就是用来打印对象信息
    /// 默认 字典／数组／字符串 都有自己的格式，而自定义对象，默认格式：'<类名：地址>'，不利于调试
    override var description: String{
        let keys = ["access_token","expires_in","uid","expires_date","name","avatar_large"]
        printLog("打印结果：\(dictionaryWithValuesForKeys(keys).description)")
        // KVC 的模型转字典（2种写法）
        // 第一种：直接使用 “\(变量名)”强转
//        return "\(dictionaryWithValuesForKeys(keys))"
        // 第二种： 调用 description 进行转换
        return dictionaryWithValuesForKeys(keys).description
    }
    
    // XCode 7.0 beta 5后，取消了 String 的拼接路径函数，改成了 NSString 的函数
    static let path = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("account.plist")
    
    /// 将当前对象归档保存
    func saveUserAccount() {
        // 对象函数中，调用静态属性：使用 ‘类名.属性’
        printLog("account.plist 文档保存路径： \(MQAccountInfo.path)")
        // 键值归档
        NSKeyedArchiver.archiveRootObject(self, toFile: MQAccountInfo.path)
    }
    /// 加载用户账户
    ///
    /// - returns: 账户信息，若账户还没登录，返回 nil（所以 ‘?’）
    class func loadUserAccount() -> MQAccountInfo? {
        // 解档加载用户账户时，需判断 token 有效期
        let account = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? MQAccountInfo
        
        if let date = account?.expires_date {
            /// 比较日期 date > 当前日期 NSDate() ，降序
            if date.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                return account
            }
        }
        
        return nil
    }
    
    // MARK: - NSCoding 归档解档
    /// 归档 ： 将当前对象保存到磁盘前，转换成二进制数据，跟序列化相似
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    /// 解档 ： 将二进制数据从磁盘加载，转换成自定义对象时调用，跟反序列化相似
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
}
