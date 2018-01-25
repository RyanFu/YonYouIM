//
//  YYWSSpaceProtocol.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSSpaceProtocol <NSObject>

/**
 *  分页查询圈子列表（按圈子名称）
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/space/nameLike"
 */
- (void)searchWallSpaceByKeyWithParam:(NSString *)param;

/**
 *  分页查询圈子列表（按用户加入状态分类）
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/space/page"
 */
- (void)getWallSpaceListWithParam:(NSString *)param;

/**
 *  创建圈子
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/space/create"
 */
- (void)createWallSpaceWithParam:(NSString *)param;

/**
 *  修改圈子
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/space/modify"
 */
- (void)modifyWallSpaceWithParam:(NSString *)param;

/**
 *  删除圈子
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/space/delete"
 */
- (void)deleteWallSpaceWithParam:(NSString *)param;

@end
