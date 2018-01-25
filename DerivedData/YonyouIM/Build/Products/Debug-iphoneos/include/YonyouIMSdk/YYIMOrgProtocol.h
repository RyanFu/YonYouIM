//
//  YYIMOrgProtocol.h
//  YonyouIMSdk
//
//  Created by litfb on 15/6/24.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YYIMBaseProtocol.h"
#import "YYOrg.h"

@protocol YYIMOrgProtocol <YYIMBaseProtocol>

@required

/**
 *  设置是否开启组织功能
 *
 *  @param enable
 */
- (void)setOrgEnable:(BOOL)enable;

/**
 *  获得根组织对象
 *
 *  @return YYOrg
 */
- (YYOrg *)getRootOrg;

/**
 *  根据组织ID获得组织对象
 *
 *  @param parentId 组织ID
 *
 *  @return YYOrg
 */
- (YYOrg *)getOrgWithParentId:(NSString *)parentId;

/**
 *  根据组织ID向服务器请求组织信息
 *
 *  @param parentId 组织ID
 */
- (void)loadOrgWithParentId:(NSString *)parentId;

@end
