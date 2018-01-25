//
//  YYWSSpaceUserAuthManager.m
//  YonyouIMSdk
//
//  Created by litfb on 15/10/22.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWSSpaceUserAuthManager.h"
#import "YMAFNetworking.h"
#import "YMGCDMulticastDelegate.h"
#import "YYIMWallSpaceDelegate.h"
#import "YYIMWallspaceDefs.h"
#import "YYIMStringUtility.h"
#import "YYIMConfig.h"
#import "YYIMWallspaceConfig.h"
#import "YYIMLogger.h"

@implementation YYWSSpaceUserAuthManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

/**
 *  批量同意加入圈子申请
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserAuth/agreeApply"
 */
- (void)batchAgreeAppliesWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse SpaceUserAuth－agreeApply param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotBatchAgreeAppliesWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotBatchAgreeAppliesWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotBatchAgreeAppliesWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    [newParamDic setValue:fullUserId forKey:@"userId"];
    
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSuaAgreeApplyServlet];
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didBatchAgreeApplies:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = error.userInfo[YMAFNetworkingOperationFailingURLResponseErrorKey];
        
        YYIMLogError(@"SpaceUserAuth－agreeApply request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotBatchAgreeAppliesWithError:error];
        
    }];
}

/**
 *  批量拒绝加入圈子的申请
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserAuth/denyApply"
 */
- (void)batchDenyAppliesWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse SpaceUserAuth－denyApply param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotBatchDenyAppliesWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotBatchDenyAppliesWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotBatchDenyAppliesWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    [newParamDic setValue:fullUserId forKey:@"userId"];
    
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSuaDenyApplyServlet];
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didBatchDenyApplies:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = error.userInfo[YMAFNetworkingOperationFailingURLResponseErrorKey];
        
        YYIMLogError(@"SpaceUserAuth－denyApply request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotBatchDenyAppliesWithError:error];
        
    }];
}

/**
 *  查询某圈子的全部未审批申请
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserAuth/getApplyListBySid"
 */
- (void)getApplyListBySidWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse SpaceUserAuth－getApplyListBySid param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotGetApplyListBySidWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetApplyListBySidWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetApplyListBySidWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    [newParamDic setValue:fullUserId forKey:@"userId"];
    
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSuaGetApplyListBySidServlet];
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didGetApplyListBySid:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = error.userInfo[YMAFNetworkingOperationFailingURLResponseErrorKey];
        
        YYIMLogError(@"SpaceUserAuth－getApplyListBySid request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotGetApplyListBySidWithError:error];
        
    }];
}

/**
 *  查询某管理员帐号管理的圈子的全部未审核加入申请
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserAuth/getApplyListByManger"
 */
- (void)getApplyListByMangerWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse SpaceUserAuth－getApplyListByManger param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotGetApplyListByMangerWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetApplyListByMangerWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetApplyListByMangerWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    [newParamDic setValue:fullUserId forKey:@"userId"];
    
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSuaGetApplyListByMangerServlet];
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didGetApplyListByManger:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = error.userInfo[YMAFNetworkingOperationFailingURLResponseErrorKey];
        
        YYIMLogError(@"SpaceUserAuth－getApplyListByManger request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotGetApplyListByMangerWithError:error];
    }];
}

@end
