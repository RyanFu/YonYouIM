//
//  YYWSSpaceUserRelationManager.m
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWSSpaceUserRelationManager.h"
#import "YMAFNetworking.h"
#import "YMGCDMulticastDelegate.h"
#import "YYIMWallSpaceDelegate.h"
#import "YYIMWallspaceDefs.h"
#import "YYIMStringUtility.h"
#import "YYIMConfig.h"
#import "YYIMWallspaceConfig.h"
#import "YYIMLogger.h"

@implementation YYWSSpaceUserRelationManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

/**
 *  查询圈子列表（用户已加入的圈子）
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserRelation/spaceByUser"
 */
- (void)getJoinedSpacesWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse SpaceUserRelation－spaceByUser param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotGetJoinedSpacesWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetJoinedSpacesWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetJoinedSpacesWithError:error];
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
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSurSpaceByUserServlet];
    
    [manager POST:urlString parameters:newParamDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didGetJoinedSpaces:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        YYIMLogError(@"SpaceUserRelation－spaceByUser request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotGetJoinedSpacesWithError:error];
    }];
}

/**
 *  用户加入圈子(开放型)
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserRelation/join"
 */
- (void)joinWallSpaceWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse SpaceUserRelation－join param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotJoinWallSpaceWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotJoinWallSpaceWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotJoinWallSpaceWithError:error];
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
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSurJoinServlet];
    
    [manager POST:urlString parameters:newParamDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didJoinWallSpace:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        YYIMLogError(@"SpaceUserRelation－join request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotJoinWallSpaceWithError:error];
    }];
}

/**
 *  用户申请加入圈子(封闭型)
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserRelation/apply"
 */
- (void)applyInWallSpaceWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse SpaceUserRelation－apply param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotApplyInWallSpaceWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotApplyInWallSpaceWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotApplyInWallSpaceWithError:error];
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
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSurApplyServlet];
    
    [manager POST:urlString parameters:newParamDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didApplyInWallSpace:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        YYIMLogError(@"SpaceUserRelation－apply request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotApplyInWallSpaceWithError:error];
    }];
}

/**
 *  批量将用户加入圈子(不区分圈子类型)
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserRelation/add4admin"
 */
- (void)batchPullInSpaceWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse SpaceUserRelation－add4admin param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotBatchPullInSpaceWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotBatchPullInSpaceWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotBatchPullInSpaceWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    [newParamDic setValue:fullUserId forKey:@"admin"];
    
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSurAdd4AdminServlet];
    
    [manager POST:urlString parameters:newParamDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didBatchPullInSpace:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        YYIMLogError(@"SpaceUserRelation－add4admin request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotBatchPullInSpaceWithError:error];
    }];
}

/**
 *  查询某圈子的某个人的申请
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserRelation/oneApplyById"
 */
- (void)checkApplyStatusWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse SpaceUserRelation－oneApplyById param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotCheckApplyStatusWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotCheckApplyStatusWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotCheckApplyStatusWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSurOneApplyByIdServlet];
    
    [manager POST:urlString parameters:newParamDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didCheckApplyStatus:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        YYIMLogError(@"SpaceUserRelation－oneApplyById request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotCheckApplyStatusWithError:error];
    }];
}

/**
 *  查询圈子成员列表
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserRelation/usersBySpace"
 */
- (void)getSpaceMembersWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse SpaceUserRelation－usersBySpace param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotGetSpaceMembersWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetSpaceMembersWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetSpaceMembersWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSurUsersBySpaceServlet];
    
    [manager POST:urlString parameters:newParamDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didGetSpaceMembers:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        YYIMLogError(@"SpaceUserRelation－usersBySpace request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotGetSpaceMembersWithError:error];
    }];
}

/**
 *  退出圈子
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/spaceUserRelation/remove"
 */
- (void)quitWallSpaceWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse SpaceUserRelation－remove param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotQuitWallSpaceWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotQuitWallSpaceWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotQuitWallSpaceWithError:error];
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
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSurRemoveServlet];
    
    [manager POST:urlString parameters:newParamDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didQuitWallSpace:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        YYIMLogError(@"SpaceUserRelation－remove request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotQuitWallSpaceWithError:error];
    }];
}

@end
