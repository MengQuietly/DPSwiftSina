//
//  MQRequestURL.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/20.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

/// 请求用户授权Token: GET/POST
let oauthURL = "https://api.weibo.com/oauth2/authorize"
/// 获取授权过的Access Token：POST
let accessTokenURL = "https://api.weibo.com/oauth2/access_token"
/// 根据用户ID获取用户信息
let usersShowURL = "https://api.weibo.com/2/users/show.json"
 /// 获取当前登录用户及其所关注（授权）用户的最新微博
let readNewWeiBoURL = "https://api.weibo.com/2/statuses/home_timeline.json"