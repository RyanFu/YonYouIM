//
//  YYIMPanDelegate.h
//  YonyouIMSdk
//
//  Created by litfb on 15/7/6.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYFile.h"

@protocol YYIMPanDelegate <NSObject>

@optional

/**
 *  根据目录ID加载文件成功
 *
 *  @param dirId     目录ID
 *  @param fileSet   kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId   群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *  @param fileArray NSArray<YYFile>
 */
- (void)didLoadFileWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId files:(NSArray *)fileArray;

/**
 *  根据目录加载文件失败
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *  @param error   错误
 */
- (void)didNotLoadFileWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId error:(YYIMError *)error;

/**
 *  上传文件成功
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)didUploadFileWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  上传文件失败
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *  @param error   错误
 */
- (void)didNotUploadFileWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId error:(YYIMError *)error;

/**
 *  文件搜索结果
 *
 *  @param fileArray NSArray<YYFile>
 */
- (void)didReceiveFileSearchResultWithFiles:(NSArray *)fileArray;

/**
 *  文件搜索失败
 *
 *  @param error 错误
 */
- (void)didNotReceiveFileSearchResult:(YYIMError *)error;

/**
 *  新建目录成功
 *
 *  @param name        目录名称
 *  @param parentDirId 父目录ID
 *  @param fileSet     kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId     群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)didCreateDirWithName:(NSString *)name parentDirId:(NSString *)parentDirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  新建目录失败
 *
 *  @param name        目录名称
 *  @param parentDirId 父目录ID
 *  @param fileSet     kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId     群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *  @param error       错误
 */
- (void)didNotCreateDirWithName:(NSString *)name parentDirId:(NSString *)parentDirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId error:(YYIMError *)error;

/**
 *  重命名目录成功
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)didRenameDirWithId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  重命名目录失败
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *  @param error   错误
 */
- (void)didNotRenameDirWithId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId error:(YYIMError *)error;

/**
 *  移动目录成功
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)didMoveDirWithId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  移动目录失败
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *  @param error   错误
 */
- (void)didNotMoveDirWithId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId error:(YYIMError *)error;

/**
 *  删除目录成功
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)didDeleteDirWithId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  删除目录失败
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *  @param error   错误
 */
- (void)didNotDeleteDirWithId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId error:(YYIMError *)error;

/**
 *  将文件保存到云盘成功
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)didCreateAttachmentWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  将文件保存到云盘失败
 *
 *  @param dirId   目录ID
 *  @param fileSet kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId 群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *  @param error   错误
 */
- (void)didNotCreateAttachmentWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId error:(YYIMError *)error;

/**
 *  重命名文件成功
 *
 *  @param attachId 文件ID
 *  @param dirId    目录ID
 *  @param fileSet  kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId  群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)didRenameAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  重命名文件失败
 *
 *  @param attachId 文件ID
 *  @param dirId    目录ID
 *  @param fileSet  kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId  群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *  @param error    错误
 */
- (void)didNotRenameAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId error:(YYIMError *)error;

/**
 *  移动文件成功
 *
 *  @param attachId 文件ID
 *  @param dirId    目录ID
 *  @param fileSet  kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId  群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)didMoveAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  移动文件失败
 *
 *  @param attachId 文件ID
 *  @param dirId    目录ID
 *  @param fileSet  kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId  群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *  @param error    错误
 */
- (void)didNotMoveAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId error:(YYIMError *)error;

/**
 *  删除文件成功
 *
 *  @param attachId 文件ID
 *  @param dirId    目录ID
 *  @param fileSet  kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId  群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 */
- (void)didDeleteAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

/**
 *  删除文件失败
 *
 *  @param attachId 文件ID
 *  @param dirId    目录ID
 *  @param fileSet  kYYIMFileSetPublic:公共,kYYIMFileSetGroup:群组,kYYIMFileSetPerson:个人
 *  @param groupId  群组ID:fileSet为kYYIMFileSetGroup时必须，其他时无效
 *  @param error    错误
 */
- (void)didNotDeleteAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId error:(YYIMError *)error;

@end
