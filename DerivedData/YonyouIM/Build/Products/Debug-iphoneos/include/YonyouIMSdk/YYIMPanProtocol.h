//
//  YYIMPanProtocol.h
//  YonyouIMSdk
//
//  Created by litfb on 15/7/6.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYIMBaseProtocol.h"
#import "YYIMDefs.h"
#import "YYIMAttachProgressDelegate.h"

@protocol YYIMPanProtocol <YYIMBaseProtocol>

@required

// in all interface when fileSet is kYYIMFileSetGroup groupId must not nil,other groupId will ignore

- (void)setPanEnable:(BOOL)enable;

/**
 *  根据目录ID获得目录信息
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *
 *  @return YYFile
 */
- (YYFile *)getDirWithId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  根据目录ID获得子目录/文件集合
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *
 *  @return NSArray<YYFile>
 */
- (NSArray *)getFilesWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  根据目录信息向服务器请求子目录/文件信息
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)loadFileWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  上传文件
 *
 *  @param dirId      目录ID
 *  @param fileSet    kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId    群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *  @param assetArray NSArray<ALAsset>
 */
- (void)uploadFileWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId assets:(NSArray *)assetArray;

/**
 *  上传文件
 *
 *  @param dirId      目录ID
 *  @param fileSet    kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId    群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *  @param assetArray NSArray<ALAsset>
 *  @param isOriginal 是否原图
 */
- (void)uploadFileWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId assets:(NSArray *)assetArray isOriginal:(BOOL)isOriginal;

/**
 *  根据关键字搜索文件
 *
 *  @param keyword 关键字
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)searchFileWithKeyword:(NSString *)keyword fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  新建目录
 *
 *  @param name        目录名称
 *  @param parentDirId 父目录ID
 *  @param fileSet     kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId     群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)createDirWithName:(NSString *)name parentDirId:(NSString *)parentDirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  重命名目录
 *
 *  @param dirId   目录ID
 *  @param name    目录名称
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)renameDirWithId:(NSString *)dirId newName:(NSString *)name fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  移动目录
 *
 *  @param dirId       目录ID
 *  @param parentDirId 新的父目录ID
 *  @param fileSet     kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId     群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)moveDirWithId:(NSString *)dirId newParentDirId:(NSString *)parentDirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  根据目录ID删除目录
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)deleteDirWithId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  将文件保存到云盘
 *
 *  @param attachId 文件ID
 *  @param dirId    目录ID
 *  @param fileSet  kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId  群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)createAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  重命名文件
 *
 *  @param attachId 文件ID
 *  @param dirId    目录ID
 *  @param name     新文件名
 *  @param fileSet  kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId  群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)renameAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId newName:(NSString *)name fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  移动文件
 *
 *  @param attachId 文件ID
 *  @param dirId    目录ID
 *  @param newDirId 新目录ID
 *  @param fileSet  kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId  群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)moveAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId newDirId:(NSString *)newDirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  根据ID删除文件
 *
 *  @param attachId 文件ID
 *  @param dirId    目录ID
 *  @param fileSet  kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId  群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)deleteAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  下载文件
 *
 *  @param attachId 文件ID
 *  @param dirId    目录ID
 *  @param fileSet  kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId  群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)downloadAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  批量下载文件
 *
 *  @param attachIdArray 文件IDArray
 *  @param dirId         目录ID
 *  @param fileSet       kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId       群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)downloadAttachmentsWithId:(NSArray *)attachIdArray dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

@end
