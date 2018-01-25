//
//  YYWSReplyProtocol.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSReplyProtocol <NSObject>

/**
 *  回复文字
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/reply/wallspace/reply"
 */
- (void)addTextReplyWithParam:(NSString *)param;

/**
 *  点赞
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/reply/wallspace/praise"
 */
- (void)addPraiseReplyWithParam:(NSString *)param;

/**
 *  取消点赞
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/reply/wallspace/cancelPraise"
 */
- (void)cancelPraiseReplyWithParam:(NSString *)param;

/**
 *  回复数量统计
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/reply/wallspace/replyCount"
 */
- (void)getTextReplyCountWithParam:(NSString *)param;

/**
 *  点赞数量统计
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/reply/wallspace/praiseCount"
 */
- (void)getPraiseReplyCountWithParam:(NSString *)param;

/**
 *  删除发言回复
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/reply/wallspace/removeReply"
 */
- (void)removeReplyWithParam:(NSString *)param;

@end
