//
//  YYWSReplyDelegate.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSReplyDelegate <NSObject>

@optional

/**
 *  回复成功
 *
 *  @param result 结果
 */
- (void)didAddTextReply:(NSString *)result;

/**
 *  回复失败
 *
 *  @param error 错误
 */
- (void)didNotAddTextReplyWithError:(NSError *)error;

/**
 *  点赞成功
 *
 *  @param result 结果
 */
- (void)didAddPraiseReply:(NSString *)result;

/**
 *  点赞失败
 *
 *  @param error 错误
 */
- (void)didNotAddPraiseReplyWithError:(NSError *)error;

/**
 *  取消点赞成功
 *
 *  @param result 结果
 */
- (void)didCancelPraiseReply:(NSString *)result;

/**
 *  取消点赞失败
 *
 *  @param error 错误
 */
- (void)didNotCancelPraiseReplyWithError:(NSError *)error;

/**
 *  回复数量统计成功
 *
 *  @param result 结果
 */
- (void)didGetTextReplyCount:(NSString *)result;

/**
 *  回复数量统计失败
 *
 *  @param error 错误
 */
- (void)didNotGetTextReplyCountWithError:(NSError *)error;

/**
 *  点赞数量统计成功
 *
 *  @param result 结果
 */
- (void)didGetPraiseReplyCount:(NSString *)result;

/**
 *  点赞数量统计失败
 *
 *  @param error 错误
 */
- (void)didNotGetPraiseReplyCountWithError:(NSError *)error;

/**
 *  删除回复成功
 *
 *  @param result 结果
 */
- (void)didRemoveReply:(NSString *)result;

/**
 *  删除回复失败
 *
 *  @param error 错误
 */
- (void)didNotRemoveReplyWithError:(NSError *)error;

@end
