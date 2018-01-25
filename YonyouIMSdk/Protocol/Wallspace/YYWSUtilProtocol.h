//
//  YYWSUtilProtocol.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSUtilProtocol <NSObject>

/**
 *  搜索用户
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/util/searchUser"
 */
- (void)searchUserWithParam:(NSString *)param;

@end
