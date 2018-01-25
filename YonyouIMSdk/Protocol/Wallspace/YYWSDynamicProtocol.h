//
//  YYWSDynamicProtocol.h
//  YonyouIMSdk
//
//  Created by litfb on 15/10/22.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSDynamicProtocol <NSObject>

/**
 *  取得动态列表(根据页码查询)
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/dynamic/wallspace/postList"
 */
- (void)getPostListWithParam:(NSString *)param;

/**
 *  取得动态列表(根据时间戳查询)
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/dynamic/wallspace/postListByTS"
 */
- (void)getPostListByTSWithParam:(NSString *)param;

/**
 *  获取与我相关未读动态
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/dynamic/wallspace/relateToMe"
 */
- (void)getRelateToMeWithParam:(NSString *)param;

/**
 *  根据通知消息获取一条动态
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/dynamic/wallspace/oneNewDynamic"
 */
- (void)getSingleDynamicWithParam:(NSString *)param;

/**
 *  查询圈子动态是否有更新
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/dynamic/wallspace/ifUpdated"
 */
- (void)getIfUpdatedWithParam:(NSString *)param;

@end
