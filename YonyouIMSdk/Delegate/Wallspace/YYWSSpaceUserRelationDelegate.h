//
//  YYWSSpaceUserRelationDelegate.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSSpaceUserRelationDelegate <NSObject>

@optional

/**
 *  获取用户已加入的圈子成功
 *
 *  @param result 结果
 */
- (void)didGetJoinedSpaces:(NSString *)result;

/**
 *  获取用户已加入的圈子失败
 *
 *  @param error 错误
 */
- (void)didNotGetJoinedSpacesWithError:(NSError *)error;

/**
 *  加入开放型圈子成功
 *
 *  @param result 结果
 */
- (void)didJoinWallSpace:(NSString *)result;

/**
 *  加入开放型圈子失败
 *
 *  @param error 错误
 */
- (void)didNotJoinWallSpaceWithError:(NSError *)error;

/**
 *  申请加入封闭型圈子成功
 *
 *  @param result 结果
 */
- (void)didApplyInWallSpace:(NSString *)result;

/**
 *  申请加入封闭型圈子失败
 *
 *  @param error 错误
 */
- (void)didNotApplyInWallSpaceWithError:(NSError *)error;

/**
 *  批量将用户加入圈子(不区分圈子类型)成功
 *
 *  @param result 结果
 */
- (void)didBatchPullInSpace:(NSString *)result;

/**
 *  批量将用户加入圈子(不区分圈子类型)失败
 *
 *  @param error 错误
 */
- (void)didNotBatchPullInSpaceWithError:(NSError *)error;

/**
 *  查询某圈子的某个人的申请成功
 *
 *  @param result 结果
 */
- (void)didCheckApplyStatus:(NSString *)result;

/**
 *  查询某圈子的某个人的申请失败
 *
 *  @param error 错误
 */
- (void)didNotCheckApplyStatusWithError:(NSError *)error;

/**
 *  查询圈子成员列表成功
 *
 *  @param result 结果
 */
- (void)didGetSpaceMembers:(NSString *)result;

/**
 *  查询圈子成员列表失败
 *
 *  @param error 错误
 */
- (void)didNotGetSpaceMembersWithError:(NSError *)error;

/**
 *  退出圈子成功
 *
 *  @param result 结果
 */
- (void)didQuitWallSpace:(NSString *)result;

/**
 *  退出圈子失败
 *
 *  @param error 错误
 */
- (void)didNotQuitWallSpaceWithError:(NSError *)error;

@end
