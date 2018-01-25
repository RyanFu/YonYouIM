//
//  YYIMOrgDelegate.h
//  YonyouIMSdk
//
//  Created by litfb on 15/6/24.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYOrg.h"

@protocol YYIMOrgDelegate <NSObject>

@optional

/**
 *  组织信息
 *
 *  @param parentId 组织ID
 *  @param org      组织
 */
- (void)didReceiveOrgWithParentId:(NSString *)parentId org:(YYOrg *)org;

/**
 *  获取组织信息失败
 *
 *  @param parentId 组织ID
 *  @param error    错误
 */
- (void)didNotReceiveOrgWithParentId:(NSString *)parentId error:(YYIMError *)error;

@end
