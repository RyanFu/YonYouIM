//
//  YYWSPostManager.m
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWSPostManager.h"
#import "YYIMWallspaceConfig.h"
#import "YYIMStringUtility.h"
#import "YMAFNetworking.h"
#import "YMGCDAsyncSocket.h"
#import "YYIMWallspaceDelegate.h"
#import "YYIMWallspaceDefs.h"
#import "YMGCDMulticastDelegate.h"
#import "YYIMConfig.h"
#import "YYIMLogger.h"

@implementation YYWSPostManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

/**
 *  发动态
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/post/publish"
 */
- (void)publishPostWithParam:(NSString *)param {      //发布
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Post－publish param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotPublishPostWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotPublishPostWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotPublishPostWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    NSMutableDictionary *subdic = [NSMutableDictionary dictionaryWithDictionary:[newParamDic objectForKey:@"post"]];
    NSNumber *ts = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000];
    [subdic setObject:ts forKey:@"ts"];
    [subdic setObject:fullUserId forKey:@"username"];
    [newParamDic setObject:subdic forKey:@"post"];
    
    // 文件
    NSArray *arr = [newParamDic objectForKey:@"files"];
    // 判断如果携带文件字段跳到图片上传方法
    if (arr.count > 0) {
        [newParamDic setObject:[NSNumber numberWithInt:1] forKey:@"docType"];
        [self uploadPictureWithParam:newParamDic];
    } else {
        [self doPublishPostWithParam:newParamDic];
    }
}

- (void)doPublishPostWithParam:(NSDictionary *)paramDic{
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getPostPublishServlet];
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didPublishPost:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = error.userInfo[YMAFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        
        YYIMLogError(@"Post－publish request error:%ld-%@", (long)statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotPublishPostWithError:error];

    }];
}

/**
 *  上传图片
 *
 *  @param param
 */
- (void)uploadPictureWithParam:(NSMutableDictionary *)paramDic  {
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    
    // 拿到图片文件数组
    NSArray *files = [NSArray arrayWithArray:[paramDic objectForKey:@"files"]];
    
    __block int succeed = 0;
    __block int failed = 0;
    __block int finished = 0;
    // attachIdArray
    __block NSMutableArray *attachIdArray = [NSMutableArray array];
    // 遍历图片数组
    for (NSInteger counter = 0 ; counter < files.count ; counter++) {
        // 文件路径
        NSString *filePath = [files objectAtIndex:counter];
        // 文件名称
        NSString *fileName = [filePath lastPathComponent];
        // 文件大小
        NSFileManager *fileManager = [NSFileManager defaultManager];
        long long fileSize;
        if ([fileManager fileExistsAtPath:filePath]) {
            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
            fileSize = [fileAttributes fileSize];
        } else {
            YYIMLogError(@"file:%@ not exists!", filePath);
            // 失败数量++
            failed++;
            // 完成数量++
            finished++;
            // 全部完成
            if (finished == files.count) {
                if (succeed > 0) {
                    [paramDic setObject:attachIdArray forKey:@"attachIds"];
                    [self doPublishPostWithParam:paramDic];
                } else {
                    NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_ATTACH_UPLOAD_FAILD userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_ATTACH_UPLOAD_FAILD forKey:NSLocalizedDescriptionKey]];
                    [[self activeDelegate] didNotPublishPostWithError:error];
                }
            }
            continue;
        }
        
        NSMutableString *fullUrlString = [NSMutableString stringWithString:[[YYIMConfig sharedInstance] getResourceUploadServlet]];
        // token
        [fullUrlString appendFormat:@"?token=%@", token];
        // 文件名
        [fullUrlString appendFormat:@"&name=%@", fileName];
        // 文件大小
        [fullUrlString appendFormat:@"&size=%@", [NSNumber numberWithLongLong:fileSize]];
        // 文件发送者
        [fullUrlString appendFormat:@"&creator=%@", fullUserId];
        // 文件接收者
        [fullUrlString appendFormat:@"&receiver=%@", [[YYIMConfig sharedInstance] getJid]];
        // 上传文件类型
        [fullUrlString appendString:@"&mediaType=1"];
        // 是否断点上传
        [fullUrlString appendString:@"&breakpoint=0"];
        // 已上传的文件字节数
        [fullUrlString appendString:@"&uploaded=0"];
        // 客户端上传图片是否压缩
        [fullUrlString appendString:@"&original=0"];
        
        // 通过封装的AFnetworking方法上传imagedata
        YMAFHTTPUploadOperationManager *manager = [YMAFHTTPUploadOperationManager manager];
        [manager POST:fullUrlString parameters:nil constructingBodyWithBlock:^(id<YMAFMultipartFormData> formData) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" error:nil];
        } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            YYIMLogInfo(@"图片第%ld张，%@，上传成功%@", (long)counter, filePath, responseObject);
            // addAttachId
            [attachIdArray addObject:[responseObject objectForKey:@"attachId"]];
            // 成功数量++
            succeed++;
            // 完成数量++
            finished++;
            // 全部完成
            if (finished == files.count) {
                [paramDic setObject:attachIdArray forKey:@"attachIds"];
                [self doPublishPostWithParam:paramDic];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            YYIMLogInfo(@"图片第%ld张，%@，上传失败%@", (long)counter, filePath, [error localizedDescription]);
            // 失败数量++
            failed++;
            // 完成数量++
            finished++;
            // 全部完成
            if (finished == files.count) {
                if (succeed > 0) {
                    [paramDic setObject:attachIdArray forKey:@"attachIds"];
                    [self doPublishPostWithParam:paramDic];
                } else {
                    NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_ATTACH_UPLOAD_FAILD userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_ATTACH_UPLOAD_FAILD forKey:NSLocalizedDescriptionKey]];
                    [[self activeDelegate] didNotPublishPostWithError:error];
                }
            }

        }];
    }
}

/**
 *  删除发言
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/post/wallspace/delpost"
 */
- (void)deletePostWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Post－delpost param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotDeletePostWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotDeletePostWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotDeletePostWithError:error];
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
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getPostDelpostServlet];
    
    [manager POST:urlString parameters:newParamDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didDeletePost:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        
        YYIMLogError(@"Post－delpost request error:%ld-%@", (long)statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotDeletePostWithError:error];
    }];
}

/**
 *  修改发言
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/post/update"
 */
- (void)updatePostWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Post－update param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotUpdatePostWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotUpdatePostWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotUpdatePostWithError:error];
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
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getPostUpdateServlet];
    
    [manager POST:urlString parameters:newParamDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didUpdatePost:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        
        YYIMLogError(@"Post－update request error:%ld-%@", (long)statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotUpdatePostWithError:error];
    }];
}

@end
