//
//  YYWSSpaceUserAuthProtocol.h
//  YonyouIMSdk
//
//  Created by litfb on 15/10/22.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSSpaceUserAuthProtocol <NSObject>

/**
 *  批量同意加入圈子申请
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserAuth/agreeApply"
 */
- (void)batchAgreeAppliesWithParam:(NSString *)param;

/**
 *  批量拒绝加入圈子的申请
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserAuth/denyApply"
 */
- (void)batchDenyAppliesWithParam:(NSString *)param;

/**
 *  查询某圈子的全部未审批申请
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserAuth/getApplyListBySid"
 */
- (void)getApplyListBySidWithParam:(NSString *)param;

/**
 *  查询某管理员帐号管理的圈子的全部未审核加入申请
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserAuth/getApplyListByManger"
 */
- (void)getApplyListByMangerWithParam:(NSString *)param;

@end
