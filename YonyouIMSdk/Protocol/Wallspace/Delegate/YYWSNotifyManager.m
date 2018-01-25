//
//  YYWSNotifyManager.m
//  YonyouIMSdk
//
//  Created by litfb on 15/10/26.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWSNotifyManager.h"
#import "YYIMWallspaceConfig.h"
#import "YYIMStringUtility.h"
#import "YMAFNetworking.h"
#import "YMGCDAsyncSocket.h"
#import "YYIMWallspaceDelegate.h"
#import "YYIMWallspaceDefs.h"
#import "YMGCDMulticastDelegate.h"
#import "YYIMConfig.h"
#import "YYIMLogger.h"

@implementation YYWSNotifyManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

/**
 *  取得通知列表
 *
 *  @param param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/wsNotify/notifyList"
 */
- (void)getNotifyListWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Notify－notifyList param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotGetNotifyListWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetNotifyListWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetNotifyListWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:fullUserId forKey:@"userId"];
    [newParamDic setValue:token forKey:@"token"];
    
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getWsNotifyNotifyListServlet];
    
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didGetNotifyList:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        YYIMLogError(@"Dynamic－notifyList request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotGetNotifyListWithError:error];
    }];
}

@end
