//
//  MQCommonTools.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/20.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

/// 常用工具
import Foundation

/// 输出日志
/// 注意：
/// 1.调用 printLog(msg) 时，需要配置 “build Setting 中 swift Compiler－Custom flags 的 Other Swift flags 项，添加 ‘-D DEBUG’“ 后才会打印信息
/// 2.调用 printLog(msg) 时，若上线则 删除之前添加的 ‘-D DEBUG’ 项
/// 3.调用 printLog(msg,logError: error) 则是否上线都会打印
/// - parameter message:  日志消息
/// - parameter logError: 错误标记，默认是 false，如果是 true，发布时仍然会输出
/// - parameter file:     文件名
/// - parameter method:   方法名
/// - parameter line:     代码行数
func printLog<T>(message: T, logError: Bool = false, file: String = #file, method: String = #function, line: Int = #line) {
    if logError {
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    } else {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
}
