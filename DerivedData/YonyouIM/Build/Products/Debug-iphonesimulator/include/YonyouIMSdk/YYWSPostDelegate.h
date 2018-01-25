//
//  YYWSPostDelegate.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSPostDelegate <NSObject>

@optional

/**
 *  发言(可包括图片或文件)成功
 *
 *  @param result 结果
 */
- (void)didPublishPost:(NSString *)result;

/**
 *  发言(可包括图片或文件)
 *
 *  @param error 错误
 */
- (void)didNotPublishPostWithError:(NSError *)error;

/**
 *  删除发言成功
 *
 *  @param result 结果
 */
- (void)didDeletePost:(NSString *)result;

/**
 *  删除发言失败
 *
 *  @param error 错误
 */
- (void)didNotDeletePostWithError:(NSError *)error;

/**
 *  更新发言成功
 *
 *  @param result 结果
 */
- (void)didUpdatePost:(NSString *)result;

/**
 *  更新发言失败
 *
 *  @param error 错误
 */
- (void)didNotUpdatePostWithError:(NSError *)error;

@end
