//
//  YYWSReplyManager.m
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWSReplyManager.h"
#import "YYIMWallspaceConfig.h"
#import "YYIMStringUtility.h"
#import "YMAFNetworking.h"
#import "YMGCDMulticastDelegate.h"
#import "YYIMWallspaceDelegate.h"
#import "YYIMWallspaceDefs.h"
#import "YYIMConfig.h"
#import "YYIMLogger.h"

@implementation YYWSReplyManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

/**
 *  回复文字
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/reply/wallspace/reply"
 */
- (void)addTextReplyWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Reply－reply param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotAddTextReplyWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotAddTextReplyWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotAddTextReplyWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    NSMutableDictionary *subdic = [NSMutableDictionary dictionaryWithDictionary:[newParamDic objectForKey:@"reply"]];
    [subdic setObject:fullUserId forKey:@"userFrom"];
    [newParamDic setObject:subdic forKey:@"reply"];
    
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getReplyReplyServlet];
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didAddTextReply:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = error.userInfo[YMAFNetworkingOperationFailingURLResponseErrorKey];
        
        YYIMLogError(@"Reply－reply request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotAddTextReplyWithError:error];
    }];
}

/**
 *  点赞
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/reply/wallspace/praise"
 */
- (void)addPraiseReplyWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Reply－praise param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotAddPraiseReplyWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotAddPraiseReplyWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotAddPraiseReplyWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    NSMutableDictionary *subdic = [NSMutableDictionary dictionaryWithDictionary:[newParamDic objectForKey:@"praise"]];
    [subdic setObject:fullUserId forKey:@"userFrom"];
    NSNumber *ts = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000];
    [subdic setObject:ts forKey:@"ts"];
    [newParamDic setObject:subdic forKey:@"praise"];
    
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getReplyPraiseServlet];
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didAddPraiseReply:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = error.userInfo[YMAFNetworkingOperationFailingURLResponseErrorKey];
        
        YYIMLogError(@"Reply－praise request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotAddPraiseReplyWithError:error];
    }];
}

/**
 *  取消点赞
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/reply/wallspace/cancelPraise"
 */
- (void)cancelPraiseReplyWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Reply－cancelPraise param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotCancelPraiseReplyWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotCancelPraiseReplyWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotCancelPraiseReplyWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    NSMutableDictionary *subDic = [NSMutableDictionary dictionaryWithDictionary:[newParamDic objectForKey:@"praise"]];
    [subDic setObject:fullUserId forKey:@"userFrom"];
    [newParamDic setObject:subDic forKey:@"praise"];
    
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getReplyCancelPraiseServlet];
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didCancelPraiseReply:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = error.userInfo[YMAFNetworkingOperationFailingURLResponseErrorKey];
        
        YYIMLogError(@"Reply－cancelPraise request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotCancelPraiseReplyWithError:error];
    }];
}

/**
 *  回复数量统计
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/reply/wallspace/replyCount"
 */
- (void)getTextReplyCountWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Reply－replyCount param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotGetTextReplyCountWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetTextReplyCountWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetTextReplyCountWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getReplyReplyCountServlet];
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didGetTextReplyCount:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = error.userInfo[YMAFNetworkingOperationFailingURLResponseErrorKey];
        
        YYIMLogError(@"Reply－replyCount request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotGetTextReplyCountWithError:error];
    }];
}

/**
 *  点赞数量统计
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/reply/wallspace/praiseCount"
 */
- (void)getPraiseReplyCountWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Reply－praiseCount param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotGetPraiseReplyCountWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetPraiseReplyCountWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetPraiseReplyCountWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getReplyPraiseCountServlet];
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didGetPraiseReplyCount:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = error.userInfo[YMAFNetworkingOperationFailingURLResponseErrorKey];
        
        YYIMLogError(@"Reply－praiseCount request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotGetPraiseReplyCountWithError:error];
    }];
}

/**
 *  删除发言回复
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/reply/wallspace/removeReply"
 */
- (void)removeReplyWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Reply－removeReply param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotRemoveReplyWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotRemoveReplyWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotRemoveReplyWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    [newParamDic setObject:fullUserId forKey:@"userFrom"];
    
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getReplyRemoveReplyServlet];
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didRemoveReply:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = error.userInfo[YMAFNetworkingOperationFailingURLResponseErrorKey];
        
        YYIMLogError(@"Reply－removeReply request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotRemoveReplyWithError:error];
    }];
}

@end
