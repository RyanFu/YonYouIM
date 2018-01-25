//
//  YYWSSpaceDelegate.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSSpaceDelegate <NSObject>

@optional

/**
 *  分页查询圈子列表（按圈子名称）成功
 *
 *  @param result 结果
 */
- (void)didSearchWallSpaceByKey:(NSString *)result;

/**
 *  分页查询圈子列表（按圈子名称）失败
 *
 *  @param error 错误
 */
- (void)didNotSearchWallSpaceByKeyWithError:(NSError *)error;

/**
 *  分页查询圈子列表（按用户加入状态分类）成功
 *
 *  @param result 结果
 */
- (void)didGetWallSpaceList:(NSString *)result;

/**
 *  分页查询圈子列表（按用户加入状态分类）失败
 *
 *  @param error 错误
 */
- (void)didNotGetWallSpaceListWithError:(NSError *)error;

/**
 *  创建圈子成功
 *
 *  @param result 结果
 */
- (void)didCreateWallSpace:(NSString *)result;

/**
 *  创建圈子失败
 *
 *  @param error 错误
 */
- (void)didNotCreateWallSpaceWithError:(NSError *)error;

/**
 *  修改圈子成功
 *
 *  @param result 结果
 */
- (void)didModifyWallSpace:(NSString *)result;

/**
 *  修改圈子失败
 *
 *  @param error 错误
 */
- (void)didNotModifyWallSpaceWithError:(NSError *)error;

/**
 *  删除圈子成功
 *
 *  @param result 结果
 */
- (void)didDeleteWallSpace:(NSString *)result;

/**
 *  删除圈子失败
 *
 *  @param error 错误
 */
- (void)didNotDeleteWallSpaceWithError:(NSError *)error;

@end
