//
//  YYWSPostProtocol.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSPostProtocol <NSObject>

/**
 *  发动态
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/post/publish"
 */
- (void)publishPostWithParam:(NSString *)param;

/**
 *  删除发言
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/post/wallspace/delpost"
 */
- (void)deletePostWithParam:(NSString *)param;

/**
 *  修改发言
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/post/update"
 */
- (void)updatePostWithParam:(NSString *)param;

@end
