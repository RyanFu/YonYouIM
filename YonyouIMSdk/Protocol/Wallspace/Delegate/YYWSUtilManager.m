//
//  YYWSUtilManager.m
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWSUtilManager.h"
#import "YMAFNetworking.h"
#import "YMGCDMulticastDelegate.h"
#import "YYIMWallSpaceDelegate.h"
#import "YYIMWallspaceDefs.h"
#import "YYIMStringUtility.h"
#import "YYIMConfig.h"
#import "YYIMWallspaceConfig.h"
#import "YYIMLogger.h"

@implementation YYWSUtilManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

/**
 *  搜索用户
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/util/searchUser"
 */
- (void)searchUserWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Util－searchUser param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotSearchUserWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotSearchUserWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotSearchUserWithError:error];
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
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getUtilSearchUserServlet];
    
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didSearchUser:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = error.userInfo[YMAFNetworkingOperationFailingURLResponseErrorKey];
        
        YYIMLogError(@"Util－searchUser request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotSearchUserWithError:error];
        
    }];
}

@end
