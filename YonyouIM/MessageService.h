//
//  MessageService.h
//  CloudHR
//
//  Created by Chenly on 16/7/19.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const IMMessagesShouldReloadNotification;

@protocol SUMExtension;

@interface MessageService : NSObject

/*
 登录有信 IM
 var command = {
	"method": "YYIM.login",
	"params": {
        "usercode": "code",
        "password": "123456",
        "userName": "name"
	}
 }
 */
- (void)login:(id<SUMExtension>)args;

/*
 退出登录
 var command = {
	"method": "YYIM.logout",
 }
 */
- (void)logout:(id<SUMExtension>)args;

/*
 设置用户信息
 var command = {
	"method": "YYIM.updateUserInfo",
	"params": {
        "userID": "15210101015", // 用户名
        "userName": "张三" // 昵称
	}
 }
 */
- (void)updateUserInfo:(id<SUMExtension>)args;

/*
 拉取消息列表
 var command = {
	"method": "YYIM.fetchMessages",
	"params": {
        "callback": "callback()"
	}
 }
 */
- (void)fetchMessages:(id<SUMExtension>)args;

/*
 发起聊天
 var command = {
	"method": "YYIM.chat",
	"params": {
        "chatID": "15210101015", // 从消息列表获取
	}
 }
 */
- (void)chat:(id<SUMExtension>)args;

/*
 添加消息监听
 var command = {
	"method": "YYIM.registerMessageObserver",
    "params": {
        "callback": "callback()"    // 收到消息时候回调
	}
 }
 */
- (void)registerMessageObserver:(id<SUMExtension>)args;

/*
 更新消息已读状态
 var command = {
	"method": "YYIM.updateMessageReaded",
    "params": {
        "accountID": "cloudhr"  // a
	}
 }
 */
- (void)updateMessageReaded:(id<SUMExtension>)args;

// 获取所有群组
- (void)getChatGroups:(id<SUMExtension>)args;

// 获取群组所有成员
- (void)getChatGroupMember:(id<SUMExtension>)args;

// 群组添加成员
- (void)groupAddMember:(id<SUMExtension>)args;

// 群组踢除成员
- (void)groupKickMember:(id<SUMExtension>)args;
// 转发
- (void)forwardMessage:(id<SUMExtension>)args;

@end
