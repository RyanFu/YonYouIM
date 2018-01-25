//
//  YYWSSpaceUserAuthDelegate.h
//  YonyouIMSdk
//
//  Created by litfb on 15/10/22.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSSpaceUserAuthDelegate <NSObject>

@optional

/**
 *  批量同意加入圈子申请成功
 *
 *  @param result 结果
 */
- (void)didBatchAgreeApplies:(NSString *)result;

/**
 *  批量同意加入圈子申请失败
 *
 *  @param error 错误
 */
- (void)didNotBatchAgreeAppliesWithError:(NSError *)error;

/**
 *  批量拒绝加入圈子申请成功
 *
 *  @param result 结果
 */
- (void)didBatchDenyApplies:(NSString *)result;

/**
 *  批量拒绝加入圈子申请失败
 *
 *  @param error 错误
 */
- (void)didNotBatchDenyAppliesWithError:(NSError *)error;

/**
 *  查询某圈子的全部未审批申请成功
 *
 *  @param result 结果
 */
- (void)didGetApplyListBySid:(NSString *)result;

/**
 *  查询某圈子的全部未审批申请失败
 *
 *  @param error 错误
 */
- (void)didNotGetApplyListBySidWithError:(NSError *)error;

/**
 *  查询某管理员帐号管理的圈子的全部未审核加入申请成功
 *
 *  @param result 结果
 */
- (void)didGetApplyListByManger:(NSString *)result;

/**
 *  查询某管理员帐号管理的圈子的全部未审核加入申请失败
 *
 *  @param error 错误
 */
- (void)didNotGetApplyListByMangerWithError:(NSError *)error;

@end
