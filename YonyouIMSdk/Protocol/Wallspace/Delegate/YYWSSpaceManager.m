//
//  YYWSSpaceManager.m
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWSSpaceManager.h"
#import "YYIMConfig.h"
#import "YYIMWallspaceConfig.h"
#import "YYIMStringUtility.h"
#import "YMAFNetworking.h"
#import "YMGCDMulticastDelegate.h"
#import "YYIMWallspaceDelegate.h"
#import "YYIMWallspaceDefs.h"
#import "YYIMLogger.h"

@implementation YYWSSpaceManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

/**
 *  分页查询圈子列表（按圈子名称）
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/space/nameLike"
 */
- (void)searchWallSpaceByKeyWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Space－nameLike param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotSearchWallSpaceByKeyWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotSearchWallSpaceByKeyWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotSearchWallSpaceByKeyWithError:error];
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
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSpaceNameLikeServlet];
    
    [manager POST:urlString parameters:newParamDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didSearchWallSpaceByKey:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        YYIMLogError(@"Space－nameLike request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotSearchWallSpaceByKeyWithError:error];
    }];
}

/**
 *  分页查询圈子列表（按用户加入状态分类）
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/space/page"
 */
- (void)getWallSpaceListWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Space－page param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotGetWallSpaceListWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetWallSpaceListWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotGetWallSpaceListWithError:error];
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
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSpacePageServlet];
    
    [manager POST:urlString parameters:newParamDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didGetWallSpaceList:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        YYIMLogError(@"Space－page request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotGetWallSpaceListWithError:error];
    }];
}

/**
 *  创建圈子
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/space/create"
 */
- (void)createWallSpaceWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Space－create param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotCreateWallSpaceWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotCreateWallSpaceWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotCreateWallSpaceWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    NSMutableDictionary *subdic =[NSMutableDictionary dictionaryWithDictionary:[newParamDic objectForKey:@"space"]];
    [subdic setValue:fullUserId forKey:@"admin"];
    [subdic setValue:fullUserId forKey:@"creator"];
    [newParamDic setValue:subdic forKey:@"space"];
    
    NSString *fav = [subdic objectForKey:@"fav"];
    if ([YYIMStringUtility isEmpty:fav]) {
        [self doCreateWallSpace:newParamDic];
    } else {
        [self uploadPictureWithParam:newParamDic isCreate:YES];
    }
}

- (void)doCreateWallSpace:(NSMutableDictionary *)paramDic {
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSpaceCreateServlet];
    
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didCreateWallSpace:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        YYIMLogError(@"Space－create request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotCreateWallSpaceWithError:error];
    }];
}

/**
 *  上传图片
 *
 *  @param param
 */
- (void)uploadPictureWithParam:(NSMutableDictionary *)paramDic isCreate:(BOOL)isCreate  {
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    
    NSMutableDictionary *subdic =[NSMutableDictionary dictionaryWithDictionary:[paramDic objectForKey:@"space"]];
    
    // 文件路径
    NSString *filePath = [subdic objectForKey:@"fav"];
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
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_ATTACH_UPLOAD_FAILD userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_ATTACH_UPLOAD_FAILD forKey:NSLocalizedDescriptionKey]];
        
        if (isCreate) {
            [[self activeDelegate] didNotCreateWallSpaceWithError:error];
        } else {
            [[self activeDelegate] didNotModifyWallSpaceWithError:error];
        }
        return;
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
    
    
    YMAFHTTPUploadOperationManager *manager = [YMAFHTTPUploadOperationManager sharedManager];
    
    [manager POST:fullUrlString parameters:nil constructingBodyWithBlock:^(id<YMAFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" error:nil];
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        YYIMLogInfo(@"圈子头像，%@，上传成功%@", filePath, (NSString *)responseObject);
        // AttachId
        NSString *attachId = [responseObject objectForKey:@"attachId"];
        [subdic setValue:attachId forKey:@"iconId"];
        [paramDic setValue:subdic forKey:@"space"];
        
        if (isCreate) {
            [self doCreateWallSpace:paramDic];
        } else {
            [self doModifyWallSpace:paramDic];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        YYIMLogError(@"圈子头像，%@，上传失败%@", filePath, [error localizedDescription]);
        NSError *err = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_ATTACH_UPLOAD_FAILD userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_ATTACH_UPLOAD_FAILD forKey:NSLocalizedDescriptionKey]];
        
        if (isCreate) {
            [[self activeDelegate] didNotCreateWallSpaceWithError:err];
        } else {
            [[self activeDelegate] didNotModifyWallSpaceWithError:err];
        }
    }];
}

/**
 *  修改圈子
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/space/modify"
 */
- (void)modifyWallSpaceWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Space－modify param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotModifyWallSpaceWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotModifyWallSpaceWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotModifyWallSpaceWithError:error];
        return;
    }
    
    // 处理参数
    NSMutableDictionary *newParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [newParamDic setValue:token forKey:@"token"];
    [newParamDic setValue:fullUserId forKey:@"userId"];
    
    NSDictionary *subdic = [newParamDic objectForKey:@"space"];
    NSString *fav = [subdic objectForKey:@"fav"];
    if ([YYIMStringUtility isEmpty:fav]) {
        [self doModifyWallSpace:newParamDic];
    } else {
        [self uploadPictureWithParam:newParamDic isCreate:NO];
    }
}

- (void)doModifyWallSpace:(NSMutableDictionary *)paramDic {
    YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
    manager.requestSerializer = [[YMAFJSONRequestSerializer alloc] init];
    manager.responseSerializer = [[YMAFHTTPResponseSerializer alloc] init];
    
    // url
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSpaceModifyServlet];
    
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didModifyWallSpace:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        YYIMLogError(@"Space－modify request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotModifyWallSpaceWithError:error];
    }];
}

/**
 *  删除圈子
 *
 *  @param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/space/delete"
 */
- (void)deleteWallSpaceWithParam:(NSString *)param {
    // 转换param的json为NSDictionary
    NSError *error = nil;
    NSData *data = [[YYIMStringUtility decodeFromEscapeString:param] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    // 转换失败
    if (error) {
        NSLog(@"parse Space－delete param error:%@", [error localizedDescription]);
        [[self activeDelegate] didNotDeleteWallSpaceWithError:error];
        return;
    }
    // token
    NSString *token = [[YYIMConfig sharedInstance] getToken];
    // 未取得token
    if ([YYIMStringUtility isEmpty:token]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_TOKEM_NOT_EXIST userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_TOKEM_NOT_EXIST forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotDeleteWallSpaceWithError:error];
        return;
    }
    // 当前登录User
    NSString *fullUserId = [[YYIMConfig sharedInstance] getFullUser];
    // 未取得User
    if ([YYIMStringUtility isEmpty:fullUserId]) {
        NSError *error = [NSError errorWithDomain:YW_ERROR_DOMAIN code:YW_ERROR_CODE_USERID_NOT_SET userInfo:[NSDictionary dictionaryWithObject:YW_ERROR_DESC_USERID_NOT_SET forKey:NSLocalizedDescriptionKey]];
        [[self activeDelegate] didNotDeleteWallSpaceWithError:error];
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
    NSString *urlString = [[YYIMWallspaceConfig sharedInstance] getSpaceDeleteServlet];
    
    [manager POST:urlString parameters:paramDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[self activeDelegate] didDeleteWallSpace:(NSString *)responseObject];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSHTTPURLResponse *response = [error.userInfo objectForKey:YMAFNetworkingOperationFailingURLResponseErrorKey];
        YYIMLogError(@"Space－delete request error:%ld-%@", (long)response.statusCode,[error localizedDescription]);
        [[self activeDelegate] didNotDeleteWallSpaceWithError:error];
    }];
}

@end
