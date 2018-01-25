//
//  YYChatGroupMember.h
//  YonyouIM
//
//  Created by litfb on 15/1/19.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYUser.h"

/**
 *  群组成员
 */
@interface YYChatGroupMember : NSObject

/**
 *  群组Id
 */
@property (nonatomic) NSString *groupId;

/**
 *  群组成员Id
 */
@property (nonatomic) NSString *memberId;

/**
 *  群组成员名称
 */
@property (nonatomic) NSString *memberName;

/**
 *  群组成员头像
 */
@property (nonatomic) NSString *memberPhoto;

/**
 *  群组成员角色
 */
@property (nonatomic) NSString *memberRole;

/**
 *  群组成员用户对象
 */
@property (retain, nonatomic) YYUser *user;

/**
 身份更改时间
 */
@property (assign, nonatomic) NSTimeInterval assignAdminTime;

/**
 *  获取头像
 *
 *  @return 头像地址
 */
- (NSString *)getMemberPhoto;

/**
 所有人
 
 @return 返回所有人 用户数据
 */
+ (YYChatGroupMember *)allUser;

@end
