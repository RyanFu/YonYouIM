//
//  YYIMExtProtocol.h
//  YonyouIMSdk
//
//  Created by litfb on 15/4/10.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YYIMBaseProtocol.h"
#import "YYUserExt.h"
#import "YYChatGroupExt.h"
#import "YYPubAccountExt.h"
#import "YYUserProfileSetting.h"

@protocol YYIMExtProtocol <YYIMBaseProtocol>

@required

/**
 *  加载用户Profile信息
 *  comople js 调用需要返回
 */
- (void)loadUserProfilesWithComplete:(void (^)(BOOL result,NSDictionary *dic, NSString *msg)) complete;

/**
 *  设置用户消息免打扰
 *
 *  @param noDisturb 免打扰
 *  @param userId    用户ID
 */
- (void)updateUserNoDisturb:(BOOL)noDisturb userId:(NSString *)userId;

/**
 *  设置用户置顶
 *
 *  @param stickTop 置顶
 *  @param userId   用户ID
 */
- (void)updateUserStickTop:(BOOL)stickTop userId:(NSString *)userId;

/**
 *  设置群组消息免打扰
 *
 *  @param noDisturb 免打扰
 *  @param groupId   群组ID
 */
- (void)updateGroupNoDisturb:(BOOL)noDisturb groupId:(NSString *)groupId;

/**
 *  设置群组置顶
 *
 *  @param stickTop 置顶
 *  @param groupId  群组ID
 */
- (void)updateGroupStickTop:(BOOL)stickTop groupId:(NSString *)groupId;

/**
 *  设置公共号消息免打扰
 *
 *  @param noDisturb 免打扰
 *  @param accountId 公共号ID
 */
- (void)updatePubAccountNoDisturb:(BOOL)noDisturb accountId:(NSString *)accountId;

/**
 *  设置公共号消息置顶
 *
 *  @param stickTop  置顶
 *  @param accountId 公共号ID
 */
- (void)updatePubAccountStickTop:(BOOL)stickTop accountId:(NSString *)accountId;

/**
 *  获取用户Profile
 *
 *  @return 用户Profile
 */
- (NSDictionary<NSString *,NSString *> *)getUserProfiles;

/**
 *  添加用户Profile
 *
 *  @param profileDic 用户profile
 */
- (void)setUserProfileWithDic:(NSDictionary<NSString *,NSString *> *)profileDic;

/**
 *  移除用户Profile
 *
 *  @param profileKeys 要移除的key
 */
- (void)removeUserProfileWithKeys:(NSArray<NSString *> *)profileKeys;

/**
 *  清空用户Profile
 */
- (void)clearUserProfiles;

/**
 *  根据用户ID获得用户消息设置
 *
 *  @param userId 用户ID
 *
 *  @return 用户消息设置
 */
- (YYUserExt *)getUserExtWithId:(NSString *)userId;

/**
 *  根据群组ID获得群组消息设置
 *
 *  @param groupId 群组ID
 *
 *  @return 群组消息设置
 */
- (YYChatGroupExt *)getChatGroupExtWithId:(NSString *)groupId;

/**
 *  根据公共号ID获得公共号消息设置
 *
 *  @param accountId 公共号ID
 *
 *  @return 公共号消息设置
 */
- (YYPubAccountExt *)getPubAccountExtWithId:(NSString *)accountId;

/**
 *  设置群组聊天是否显示成员名
 *
 *  @param showName 是否显示成员名
 *  @param groupId  群组ID
 */
- (void)setChatGroupShowName:(BOOL)showName groupId:(NSString *)groupId;

/**
 *  更新用户消息设置
 *
 *  @param userExt 用户消息设置
 */
- (void)updateUserExt:(YYUserExt *)userExt DEPRECATED_ATTRIBUTE;

/**
 *  更新群组消息设置
 *
 *  @param chatGroupExt 群组消息设置
 */
- (void)updateChatGroupExt:(YYChatGroupExt *)chatGroupExt DEPRECATED_ATTRIBUTE;

/**
 *  更新公共号消息设置
 *
 *  @param pubAccountExt 公共号消息设置
 */
- (void)updatePubAccountExt:(YYPubAccountExt *)pubAccountExt DEPRECATED_ATTRIBUTE;

/**
 设置沉浸模式

 @param silenceMode 是否沉浸
 @param complete  js调用需要，其他可以不需要，正常有代理触发结果
 */
- (void)updateSilenceMode:(BOOL)silenceMode complete:(void (^)(BOOL result, NSString *msg)) complete;

/**
 勿扰模式

 @param beginHour 开始时间 小时
 @param beginMinute 开始时间 分钟
 @param endHour 结束时间 小时
 @param endMinute 结束时间 分钟
 */
- (void)enableUserNoDisturbance:(NSInteger)beginHour beginMinute:(NSInteger)beginMinute endHour:(NSInteger)endHour endMinute:(NSInteger)endMinute;
/**
 *  获取用户Profile
 *
 *  @return 用户Profile
 */
- (YYUserProfileSetting *)getUserProfileSetting;

/**
 是否临时不被打扰

 @param fromId 
 @return 是否临时不被打扰
 */
- (BOOL)isTempNoDisturb:(NSString *)fromId;

/**
 设置静音
 
 @param mute 是否静音
 */
- (void)setUserMute:(BOOL)mute;
@end
