//
//  YYIMPanDBHelper.h
//  YonyouIMSdk
//
//  Created by litfb on 15/7/7.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYIMBaseDBHelper.h"
#import "YYFile.h"

@interface YYIMPanDBHelper : YYIMBaseDBHelper

+ (instancetype) sharedInstance;

#pragma mark file

- (YYFile *)getFileWithId:(NSString *)attachId dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

- (NSArray *)getFilesWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

- (YYFile *)getDirWithId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

- (void)batchUpdateFileWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId files:(NSArray *)fileArray ts:(NSTimeInterval)ts;

- (YYAttach *)getAttachWithId:(NSString *)attachId;

- (YYAttach *)getAttachWithUploadKey:(NSString *)uploadKey;

- (void)createAttach:(YYAttach *)attach;

- (void)updateAttachDownloadState:(NSString *)attachId downloadState:(YYIMAttachDownloadState)downloadState path:(NSString *)path;

- (void)updateAttachUploadState:(NSString *)uploadKey attachId:(NSString *)attachId uploadState:(YYIMAttachUploadState)uploadState;

- (void)updateFaildAttach;

@end
