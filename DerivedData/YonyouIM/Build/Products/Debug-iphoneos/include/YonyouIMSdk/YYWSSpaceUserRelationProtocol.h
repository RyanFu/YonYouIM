//
//  YYWSSpaceUserRelationProtocol.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSSpaceUserRelationProtocol <NSObject>

/**
 *  查询圈子列表（用户已加入的圈子）
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserRelation/spaceByUser"
 */
- (void)getJoinedSpacesWithParam:(NSString *)param;

/**
 *  用户加入圈子(开放型)
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserRelation/join"
 */
- (void)joinWallSpaceWithParam:(NSString *)param;

/**
 *  用户申请加入圈子(封闭型)
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserRelation/apply"
 */
- (void)applyInWallSpaceWithParam:(NSString *)param;

/**
 *  批量将用户加入圈子(不区分圈子类型)
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserRelation/add4admin"
 */
- (void)batchPullInSpaceWithParam:(NSString *)param;

/**
 *  查询某圈子的某个人的申请
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserRelation/oneApplyById"
 */
- (void)checkApplyStatusWithParam:(NSString *)param;

/**
 *  查询圈子成员列表
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserRelation/usersBySpace"
 */
- (void)getSpaceMembersWithParam:(NSString *)param;

/**
 *  退出圈子
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserRelation/remove"
 */
- (void)quitWallSpaceWithParam:(NSString *)param;

@end
