//
//  YYWSDynamicDelegate.h
//  YonyouIMSdk
//
//  Created by litfb on 15/10/22.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSDynamicDelegate <NSObject>

@optional

/**
 *  取得动态列表(根据页码查询)成功
 *
 *  @param result 结果
 */
- (void)didGetPostList:(NSString *)result;

/**
 *  取得动态列表(根据页码查询)失败
 *
 *  @param error 错误
 */
- (void)didNotGetPostListWithError:(NSError *)error;

/**
 *  取得动态列表(根据时间戳查询)成功
 *
 *  @param result 结果
 */
- (void)didGetPostListByTS:(NSString *)result;

/**
 *  取得动态列表(根据时间戳查询)失败
 *
 *  @param error 错误
 */
- (void)didNotGetPostListByTSWithError:(NSError *)error;

/**
 *  获取与我相关未读动态成功
 *
 *  @param result 结果
 */
- (void)didGetRelateToMe:(NSString *)result;

/**
 *  获取与我相关未读动态失败
 *
 *  @param error 错误
 */
- (void)didNotGetRelateToMeWithError:(NSError *)error;

/**
 *  根据通知消息获取一条动态成功
 *
 *  @param result 结果
 */
- (void)didGetSingleDynamic:(NSString *)result;

/**
 *  根据通知消息获取一条动态失败
 *
 *  @param error 错误
 */
- (void)didNotGetSingleDynamicWithError:(NSError *)error;

/**
 *  查询圈子动态是否有更新成功
 *
 *  @param result 结果
 */
- (void)didGetIfUpdated:(NSString *)result;

/**
 *  查询圈子动态是否有更新失败
 *
 *  @param error 错误
 */
- (void)didNotGetIfUpdatedWithError:(NSError *)error;

@end
