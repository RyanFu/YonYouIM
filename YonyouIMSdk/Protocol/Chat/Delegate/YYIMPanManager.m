//
//  YYIMPanManager.m
//  YonyouIMSdk
//
//  Created by litfb on 15/7/6.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "YYIMPanManager.h"
#import "JUMPFramework.h"
#import "YYIMStringUtility.h"
#import "YYIMJUMPHelper.h"
#import "YYIMPanDBHelper.h"
#import "YYFile.h"
#import "YYIMResourceUtility.h"
#import "YYIMHttpUtility.h"
#import "YYIMConfig.h"
#import "YYIMChat.h"
#import "YYIMLogger.h"
#import "YYIMConfig.h"

@interface YYIMPanManager ()<JUMPStreamDelegate>

@property BOOL enable;

@end

@implementation YYIMPanManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)setPanEnable:(BOOL)enable {
    self.enable = enable;
}

- (YYFile *)getDirWithId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if (!self.enable) {
        return nil;
    }
    
    if (fileSet == kYYIMFileSetGroup && [YYIMStringUtility isEmpty:groupId]) {
        return nil;
    }
    if ([YYIMStringUtility isEmpty:dirId]) {
        return nil;
    }
    return [[YYIMPanDBHelper sharedInstance] getDirWithId:dirId fileSet:fileSet group:groupId];
}

- (NSArray *)getFilesWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if (!self.enable) {
        return nil;
    }
    
    if (fileSet == kYYIMFileSetGroup && [YYIMStringUtility isEmpty:groupId]) {
        return [NSArray array];
    }
    if ([YYIMStringUtility isEmpty:dirId]) {
        return [NSArray array];
    }
    NSArray *array = [[YYIMPanDBHelper sharedInstance] getFilesWithDirId:dirId fileSet:fileSet group:groupId];
    for (YYFile *file in array) {
        if (![file isDir]) {
            [file setUser:[[YYIMChat sharedInstance].chatManager getUserWithId:[file fileCreator]]];
        }
    }
    return array;
}

- (void)loadFileWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if (!self.enable) {
        return;
    }
    
    YYIMLogInfo(@"loadFileWithDirId:%@:%ld:%@", dirId, (long)fileSet, groupId);
    if (fileSet == kYYIMFileSetGroup && [YYIMStringUtility isEmpty:groupId]) {
        [[self activeDelegate] didNotLoadFileWithDirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"groupId should not nil"]];
        return;
    }
    
    if ([YYIMStringUtility isEmpty:dirId]) {
        [[self activeDelegate] didNotLoadFileWithDirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"dirId should not nil"]];
        return;
    }
    
    YYFile *file = [[YYIMPanDBHelper sharedInstance] getDirWithId:dirId fileSet:fileSet group:groupId];
    
    NSString *owner;
    switch (fileSet) {
        case kYYIMFileSetPublic:
            owner = [YYIMJUMPHelper getAppId];
            break;
        case kYYIMFileSetGroup:
            owner = [YYIMJUMPHelper genFullGroupJidString:groupId];
            break;
        case kYYIMFileSetPerson:
            owner = nil;
            break;
        default:
            return;
    }
    
    // JUMPIQ
    NSString *packetId = [JUMPStream generateJUMPID];
    JUMPIQ *iq = [JUMPIQ iqWithOpData:JUMP_OPDATA(JUMPAttachmentRequestPacketOpCode) packetID:packetId];
    [iq setObject:dirId forKey:@"dirId"];
    if (owner) {
        [iq setObject:owner forKey:@"owner"];
    }
    if (file) {
        [iq setObject:[NSNumber numberWithLongLong:[file ts]] forKey:@"ts"];
    }
    [iq setObject:[NSNumber numberWithInt:0] forKey:@"start"];
    [iq setObject:[NSNumber numberWithInt:INT32_MAX] forKey:@"size"];
    
    [[self tracker] addPacket:iq
                       target:self
                     selector:@selector(handleGetFileResponse:withInfo:)
                      timeout:30];
    // 发包
    [[self activeStream] sendPacket:iq];
}

- (void)uploadFileWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId assets:(NSArray *)assetArray {
    if (!self.enable) {
        return;
    }
    
    [self uploadFileWithDirId:dirId fileSet:fileSet group:groupId assets:assetArray isOriginal:NO];
}

- (void)uploadFileWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId assets:(NSArray *)assetArray isOriginal:(BOOL)isOriginal {
    if (!self.enable) {
        return;
    }
    
    if ([YYIMStringUtility isEmpty:dirId]) {
        [self.activeDelegate didNotUploadFileWithDirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"dirId should not nil"]];
        return;
    }
    
    if (fileSet == kYYIMFileSetGroup && [YYIMStringUtility isEmpty:groupId]) {
        [self.activeDelegate didNotUploadFileWithDirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"groupId should not nil"]];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (id obj in assetArray) {
            if (![obj isMemberOfClass:[ALAsset class]]) {
                return;
            }
            // asset
            ALAsset *asset = (ALAsset *)obj;
            
            NSString *imagePath;
            NSString *fileName;
            if (isOriginal) {
                imagePath = [YYIMResourceUtility saveAssets:asset];
                fileName = [[asset defaultRepresentation] filename];
            } else {
                CGImageRef imageRef = [[asset defaultRepresentation] fullScreenImage];
                // 缩图
                UIImage *thumbImage = [YYIMResourceUtility thumbImage:[UIImage imageWithCGImage:imageRef] maxSide:1280.0f];
                // 保存image到Document
                imagePath = [YYIMResourceUtility saveImage:thumbImage];
                fileName = [imagePath lastPathComponent];
            }
            
            [[YYIMChat sharedInstance].chatManager uploadAttach:imagePath fileName:fileName receiver:nil mediaType:kYYIMUploadMediaTypeImage isOriginal:isOriginal complete:^(BOOL result, YYAttach *attach, YYIMError *error) {
                if (result && attach) {
                    [self.activeDelegate didUploadFileWithDirId:dirId fileSet:fileSet group:groupId];
                    [self createAttachmentWithId:[attach attachId] dirId:dirId fileSet:fileSet group:groupId];
                } else {
                    [self.activeDelegate didNotUploadFileWithDirId:dirId fileSet:fileSet group:groupId error:error];
                }
            }];
        }
    });
}

- (void)searchFileWithKeyword:(NSString *)keyword fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if (!self.enable) {
        return;
    }
    
    if ([YYIMStringUtility isEmpty:keyword]) {
        [[self activeDelegate] didNotReceiveFileSearchResult:nil];
        return;
    }
    
    if (fileSet == kYYIMFileSetGroup && [YYIMStringUtility isEmpty:groupId]) {
        [[self activeDelegate] didNotReceiveFileSearchResult:nil];
        return;
    }
    
    NSString *owner;
    switch (fileSet) {
        case kYYIMFileSetPublic:
            owner = [YYIMJUMPHelper getAppId];
            break;
        case kYYIMFileSetGroup:
            owner = [YYIMJUMPHelper genFullGroupJidString:groupId];
            break;
        case kYYIMFileSetPerson:
            owner = nil;
            break;
        default:
            return;
    }
    
    // JUMPIQ
    NSString *packetId = [JUMPStream generateJUMPID];
    JUMPIQ *iq = [JUMPIQ iqWithOpData:JUMP_OPDATA(JUMPAttachmentSearchPacketOpCode) packetID:packetId];
    if (owner) {
        [iq setObject:owner forKey:@"owner"];
    }
    if (keyword) {
        [iq setObject:keyword forKey:@"keyword"];
    }
    [iq setObject:[NSNumber numberWithInt:0] forKey:@"start"];
    [iq setObject:[NSNumber numberWithInt:20] forKey:@"size"];
    
    [[self tracker] addPacket:iq
                       target:self
                     selector:@selector(handleSearchFileResponse:withInfo:)
                      timeout:30];
    // 发包
    [[self activeStream] sendPacket:iq];
}

- (void)createDirWithName:(NSString *)name parentDirId:(NSString *)parentDirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if (!self.enable) {
        return;
    }
    
    if ([YYIMStringUtility isEmpty:name]) {
        [self.activeDelegate didNotCreateDirWithName:name parentDirId:parentDirId fileSet:fileSet group:groupId  error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"dir name should not nil"]];
        return;
    }
    
    if ([YYIMStringUtility isEmpty:parentDirId]) {
        [self.activeDelegate didNotCreateDirWithName:name parentDirId:parentDirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"parentDirId should not nil"]];
        return;
    }
    
    if (fileSet == kYYIMFileSetGroup && [YYIMStringUtility isEmpty:groupId]) {
        [self.activeDelegate didNotCreateDirWithName:name parentDirId:parentDirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"groupId should not nil"]];
        return;
    }
    
    NSString *owner;
    switch (fileSet) {
        case kYYIMFileSetPublic:
            owner = [YYIMJUMPHelper getAppId];
            break;
        case kYYIMFileSetGroup:
            owner = [YYIMJUMPHelper genFullGroupJidString:groupId];
            break;
        case kYYIMFileSetPerson:
            owner = nil;
            break;
        default:
            return;
    }
    
    // JUMPIQ
    NSString *packetId = [JUMPStream generateJUMPID];
    JUMPIQ *iq = [JUMPIQ iqWithOpData:JUMP_OPDATA(JUMPDirectoryOperationPacketOpCode) packetID:packetId];
    [iq setObject:@"create" forKey:@"operation"];
    if (owner) {
        [iq setObject:owner forKey:@"owner"];
    }
    [iq setObject:name forKey:@"name"];
    [iq setObject:parentDirId forKey:@"newDirId"];
    
    [[self tracker] addPacket:iq
                       target:self
                     selector:@selector(handleDirCreateResponse:withInfo:)
                      timeout:30];
    // 发包
    [[self activeStream] sendPacket:iq];
}

- (void)renameDirWithId:(NSString *)dirId newName:(NSString *)name fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if (!self.enable) {
        return;
    }
    
    if ([YYIMStringUtility isEmpty:dirId]) {
        [self.activeDelegate didNotRenameDirWithId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"dirId should not nil"]];
        return;
    }
    
    if ([YYIMStringUtility isEmpty:name]) {
        [self.activeDelegate didNotRenameDirWithId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"name should not nil"]];
        return;
    }
    
    if (fileSet == kYYIMFileSetGroup && [YYIMStringUtility isEmpty:groupId]) {
        [self.activeDelegate didNotRenameDirWithId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"groupId should not nil"]];
        return;
    }
    
    NSString *owner;
    switch (fileSet) {
        case kYYIMFileSetPublic:
            owner = [YYIMJUMPHelper getAppId];
            break;
        case kYYIMFileSetGroup:
            owner = [YYIMJUMPHelper genFullGroupJidString:groupId];
            break;
        case kYYIMFileSetPerson:
            owner = nil;
            break;
        default:
            return;
    }
    
    // JUMPIQ
    NSString *packetId = [JUMPStream generateJUMPID];
    JUMPIQ *iq = [JUMPIQ iqWithOpData:JUMP_OPDATA(JUMPDirectoryOperationPacketOpCode) packetID:packetId];
    [iq setObject:@"rename" forKey:@"operation"];
    [iq setObject:dirId forKey:@"dirId"];
    if (owner) {
        [iq setObject:owner forKey:@"owner"];
    }
    [iq setObject:name forKey:@"name"];
    
    [[self tracker] addPacket:iq
                       target:self
                     selector:@selector(handleDirRenameResponse:withInfo:)
                      timeout:30];
    // 发包
    [[self activeStream] sendPacket:iq];
}

- (void)moveDirWithId:(NSString *)dirId newParentDirId:(NSString *)parentDirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if (!self.enable) {
        return;
    }
    
    if ([YYIMStringUtility isEmpty:dirId]) {
        [self.activeDelegate didNotMoveDirWithId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"dirId should not nil"]];
        return;
    }
    
    if ([YYIMStringUtility isEmpty:parentDirId]) {
        [self.activeDelegate didNotMoveDirWithId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"newParentDirId should not nil"]];
        return;
    }
    
    if (fileSet == kYYIMFileSetGroup && [YYIMStringUtility isEmpty:groupId]) {
        [self.activeDelegate didNotMoveDirWithId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"groupId should not nil"]];
        return;
    }
    
    NSString *owner;
    switch (fileSet) {
        case kYYIMFileSetPublic:
            owner = [YYIMJUMPHelper getAppId];
            break;
        case kYYIMFileSetGroup:
            owner = [YYIMJUMPHelper genFullGroupJidString:groupId];
            break;
        case kYYIMFileSetPerson:
            owner = nil;
            break;
        default:
            return;
    }
    
    // JUMPIQ
    NSString *packetId = [JUMPStream generateJUMPID];
    JUMPIQ *iq = [JUMPIQ iqWithOpData:JUMP_OPDATA(JUMPDirectoryOperationPacketOpCode) packetID:packetId];
    [iq setObject:@"move" forKey:@"operation"];
    [iq setObject:dirId forKey:@"dirId"];
    if (owner) {
        [iq setObject:owner forKey:@"owner"];
    }
    [iq setObject:parentDirId forKey:@"newDirId"];
    
    [[self tracker] addPacket:iq
                       target:self
                     selector:@selector(handleDirMoveResponse:withInfo:)
                      timeout:30];
    // 发包
    [[self activeStream] sendPacket:iq];
}

- (void)deleteDirWithId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if (!self.enable) {
        return;
    }
    
    if ([YYIMStringUtility isEmpty:dirId]) {
        [self.activeDelegate didNotDeleteDirWithId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"dirId should not nil"]];
        return;
    }
    
    if (fileSet == kYYIMFileSetGroup && [YYIMStringUtility isEmpty:groupId]) {
        [self.activeDelegate didNotDeleteDirWithId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"groupId should not nil"]];
        return;
    }
    
    NSString *owner;
    switch (fileSet) {
        case kYYIMFileSetPublic:
            owner = [YYIMJUMPHelper getAppId];
            break;
        case kYYIMFileSetGroup:
            owner = [YYIMJUMPHelper genFullGroupJidString:groupId];
            break;
        case kYYIMFileSetPerson:
            owner = nil;
            break;
        default:
            return;
    }
    
    // JUMPIQ
    NSString *packetId = [JUMPStream generateJUMPID];
    JUMPIQ *iq = [JUMPIQ iqWithOpData:JUMP_OPDATA(JUMPDirectoryOperationPacketOpCode) packetID:packetId];
    [iq setObject:@"delete" forKey:@"operation"];
    [iq setObject:dirId forKey:@"dirId"];
    if (owner) {
        [iq setObject:owner forKey:@"owner"];
    }
    
    [[self tracker] addPacket:iq
                       target:self
                     selector:@selector(handleDirDeleteResponse:withInfo:)
                      timeout:30];
    // 发包
    [[self activeStream] sendPacket:iq];
}

- (void)createAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if (!self.enable) {
        return;
    }
    
    NSString *owner;
    switch (fileSet) {
        case kYYIMFileSetPublic:
            owner = [YYIMJUMPHelper getAppId];
            break;
        case kYYIMFileSetGroup:
            owner = [YYIMJUMPHelper genFullGroupJidString:groupId];
            break;
        case kYYIMFileSetPerson:
            owner = nil;
            break;
        default:
            return;
    }
    
    // JUMPIQ
    NSString *packetId = [JUMPStream generateJUMPID];
    JUMPIQ *iq = [JUMPIQ iqWithOpData:JUMP_OPDATA(JUMPAttachmentOperationPacketOpCode) packetID:packetId];
    [iq setObject:@"create" forKey:@"operation"];
    if (owner) {
        [iq setObject:owner forKey:@"owner"];
    }
    [iq setObject:attachId forKey:@"attachId"];
    [iq setObject:dirId forKey:@"newDirId"];
    
    [[self tracker] addPacket:iq
                       target:self
                     selector:@selector(handleAttachCreateResponse:withInfo:)
                      timeout:30];
    // 发包
    [[self activeStream] sendPacket:iq];
}

- (void)renameAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId newName:(NSString *)name fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if (!self.enable) {
        return;
    }
    
    if ([YYIMStringUtility isEmpty:attachId]) {
        [[self activeDelegate] didNotRenameAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"attachId should not nil"]];
        return;
    }
    
    if ([YYIMStringUtility isEmpty:dirId]) {
        [[self activeDelegate] didNotRenameAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"dirId should not nil"]];
        return;
    }
    
    if ([YYIMStringUtility isEmpty:name]) {
        [[self activeDelegate] didNotRenameAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"name should not nil"]];
        return;
    }
    
    if (fileSet == kYYIMFileSetGroup && [YYIMStringUtility isEmpty:groupId]) {
        [[self activeDelegate] didNotRenameAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"groupId should not nil"]];
        return;
    }
    
    NSString *owner;
    switch (fileSet) {
        case kYYIMFileSetPublic:
            owner = [YYIMJUMPHelper getAppId];
            break;
        case kYYIMFileSetGroup:
            owner = [YYIMJUMPHelper genFullGroupJidString:groupId];
            break;
        case kYYIMFileSetPerson:
            owner = nil;
            break;
        default:
            return;
    }
    
    // JUMPIQ
    NSString *packetId = [JUMPStream generateJUMPID];
    JUMPIQ *iq = [JUMPIQ iqWithOpData:JUMP_OPDATA(JUMPAttachmentOperationPacketOpCode) packetID:packetId];
    [iq setObject:@"rename" forKey:@"operation"];
    [iq setObject:attachId forKey:@"attachId"];
    [iq setObject:dirId forKey:@"dirId"];
    if (owner) {
        [iq setObject:owner forKey:@"owner"];
    }
    [iq setObject:name forKey:@"name"];
    
    [[self tracker] addPacket:iq
                       target:self
                     selector:@selector(handleAttachRenameResponse:withInfo:)
                      timeout:30];
    // 发包
    [[self activeStream] sendPacket:iq];
}

- (void)moveAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId newDirId:(NSString *)newDirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if (!self.enable) {
        return;
    }
    
    if ([YYIMStringUtility isEmpty:attachId]) {
        [[self activeDelegate] didNotMoveAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"attachId should not nil"]];
        return;
    }
    
    if ([YYIMStringUtility isEmpty:dirId]) {
        [[self activeDelegate] didNotMoveAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"dirId should not nil"]];
        return;
    }
    
    if ([YYIMStringUtility isEmpty:newDirId]) {
        [[self activeDelegate] didNotMoveAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"newDirId should not nil"]];
        return;
    }
    
    if (fileSet == kYYIMFileSetGroup && [YYIMStringUtility isEmpty:groupId]) {
        [[self activeDelegate] didNotMoveAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"groupId should not nil"]];
        return;
    }
    
    NSString *owner;
    switch (fileSet) {
        case kYYIMFileSetPublic:
            owner = [YYIMJUMPHelper getAppId];
            break;
        case kYYIMFileSetGroup:
            owner = [YYIMJUMPHelper genFullGroupJidString:groupId];
            break;
        case kYYIMFileSetPerson:
            owner = nil;
            break;
        default:
            return;
    }
    
    // JUMPIQ
    NSString *packetId = [JUMPStream generateJUMPID];
    JUMPIQ *iq = [JUMPIQ iqWithOpData:JUMP_OPDATA(JUMPAttachmentOperationPacketOpCode) packetID:packetId];
    [iq setObject:@"move" forKey:@"operation"];
    [iq setObject:attachId forKey:@"attachId"];
    [iq setObject:dirId forKey:@"dirId"];
    if (owner) {
        [iq setObject:owner forKey:@"owner"];
    }
    [iq setObject:newDirId forKey:@"newDirId"];
    
    [[self tracker] addPacket:iq
                       target:self
                     selector:@selector(handleAttachMoveResponse:withInfo:)
                      timeout:30];
    // 发包
    [[self activeStream] sendPacket:iq];
}

- (void)deleteAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if (!self.enable) {
        return;
    }
    
    if ([YYIMStringUtility isEmpty:attachId]) {
        [[self activeDelegate] didNotDeleteAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"attachId should not nil"]];
        return;
    }
    
    if ([YYIMStringUtility isEmpty:dirId]) {
        [[self activeDelegate] didNotDeleteAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"dirId should not nil"]];
        return;
    }
    
    if (fileSet == kYYIMFileSetGroup && [YYIMStringUtility isEmpty:groupId]) {
        [[self activeDelegate] didNotDeleteAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId error:[YYIMError errorWithCode:YMERROR_CODE_ILLEGAL_ARGUMENT errorMessage:@"groupId should not nil"]];
        return;
    }
    
    NSString *owner;
    switch (fileSet) {
        case kYYIMFileSetPublic:
            owner = [YYIMJUMPHelper getAppId];
            break;
        case kYYIMFileSetGroup:
            owner = [YYIMJUMPHelper genFullGroupJidString:groupId];
            break;
        case kYYIMFileSetPerson:
            owner = nil;
            break;
        default:
            return;
    }
    
    // JUMPIQ
    NSString *packetId = [JUMPStream generateJUMPID];
    JUMPIQ *iq = [JUMPIQ iqWithOpData:JUMP_OPDATA(JUMPAttachmentOperationPacketOpCode) packetID:packetId];
    [iq setObject:@"delete" forKey:@"operation"];
    [iq setObject:attachId forKey:@"attachId"];
    [iq setObject:dirId forKey:@"dirId"];
    if (owner) {
        [iq setObject:owner forKey:@"owner"];
    }
    
    [[self tracker] addPacket:iq
                       target:self
                     selector:@selector(handleAttachDeleteResponse:withInfo:)
                      timeout:30];
    // 发包
    [[self activeStream] sendPacket:iq];
}

- (void)downloadAttachmentWithId:(NSString *)attachId dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if (!self.enable) {
        return;
    }
    
    // 文件
    YYFile *file = [[YYIMPanDBHelper sharedInstance] getFileWithId:attachId dirId:dirId fileSet:fileSet group:groupId];
    if (!file) {
        return;
    }
    
    // 目标路径
    NSString *relaPath = [YYIMResourceUtility resourceAttachRelaPathWithId:attachId ext:[[file fileName] pathExtension]];
    
    [[YYIMChat sharedInstance].chatManager downloadAttach:attachId targetPath:relaPath imageType:kYYIMImageTypeNormal thumbnail:NO  fileSize:[file fileSize] progress:nil complete:nil];
}

- (void)downloadAttachmentsWithId:(NSArray *)attachIdArray dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if (!self.enable) {
        return;
    }
    
    for (NSString *attachId in attachIdArray) {
        [self downloadAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId];
    }
}

#pragma mark JUMPStreamDelegate

- (BOOL)jumpStream:(JUMPStream *)sender didReceiveIQ:(JUMPIQ *)iq {
    return [[self tracker] invokeForID:[iq packetID] withObject:iq];
}

- (void)jumpStream:(JUMPStream *)sender didFailToSendIQ:(JUMPIQ *)iq error:(NSError *)error {
    if ([iq packetID]) {
        [[self tracker] invokeForID:[iq packetID] withObject:nil];
    }
}

- (void)jumpStream:(JUMPStream *)sender didReceiveError:(JUMPError *)error {
    [[self tracker] invokeForID:[error packetID] withObject:error];
}

#pragma mark private

- (void)handleGetFileResponse:(JUMPPacket *)jumpPacket withInfo:(id <JUMPTrackingInfo>)info {
    YYIMLogInfo(@"handleGetFileResponse:%@", [jumpPacket jsonString]);
    JUMPIQ *trackIQ = (JUMPIQ *)[info packet];
    NSString *owner = [jumpPacket objectForKey:@"owner"];
    
    YYIMFileSet fileSet;
    NSString *groupId;
    if ([owner isEqualToString:[YYIMJUMPHelper getAppId]]) {
        fileSet = kYYIMFileSetPublic;
        
        NSInteger isAdmin = [[jumpPacket objectForKey:@"admin"] integerValue];
        [[YYIMConfig sharedInstance] setPanAdmin:isAdmin == 1];
    } else if (![YYIMStringUtility isEmpty:owner]) {
        fileSet = kYYIMFileSetGroup;
        groupId = [YYIMJUMPHelper parseUser:owner];
    } else {
        fileSet = kYYIMFileSetPerson;
    }
    
    NSString *dirId = [trackIQ objectForKey:@"dirId"];
    if (!jumpPacket || ![jumpPacket checkOpData:JUMP_OPDATA(JUMPAttachmentResultPacketOpCode)]) {
        YYIMError *error;
        if (!jumpPacket) {
            error = [YYIMError errorWithCode:YMERROR_CODE_RESPONSE_NOT_RECEIVED errorMessage:@"response not received"];
        } else if ([jumpPacket isErrorPacket]) {
            error = [YYIMError errorWithCode:[[jumpPacket objectForKey:@"code"] integerValue] errorMessage:[jumpPacket objectForKey:@"message"]];
        } else {
            error = [YYIMError errorWithCode:YMERROR_CODE_UNKNOWN_ERROR errorMessage:@"unknown error"];
        }
        
        [[self activeDelegate] didNotLoadFileWithDirId:dirId fileSet:fileSet group:groupId error:error];
        return;
    }
    
    JUMPIQ *jumpIQ = (JUMPIQ *)jumpPacket;
    NSInteger code = [[jumpIQ objectForKey:@"code"] integerValue];
    
    NSArray *dirs = [jumpIQ objectForKey:@"dirs"];
    NSArray *attachs = [jumpIQ objectForKey:@"attachs"];
    
    if (code == 200) {
        NSTimeInterval ts = [[jumpIQ objectForKey:@"ts"] longLongValue];
        
        NSMutableArray *fileArray = [NSMutableArray array];
        for (NSDictionary *dirItem in dirs) {
            YYFile *file = [[YYFile alloc] init];
            [file setParentDirId:dirId];
            [file setFileId:[dirItem objectForKey:@"dirId"]];
            [file setFileName:[dirItem objectForKey:@"name"]];
            [file setCreateDate:[[dirItem objectForKey:@"createDate"] longLongValue]];
            [file setIsDir:YES];
            [fileArray addObject:file];
        }
        
        for (NSDictionary *attachItem in attachs) {
            YYFile *file = [[YYFile alloc] init];
            [file setParentDirId:dirId];
            [file setFileId:[attachItem objectForKey:@"attachId"]];
            [file setFileName:[attachItem objectForKey:@"name"]];
            [file setFileSize:[[attachItem objectForKey:@"size"] longLongValue]];
            [file setFileCreator:[YYIMJUMPHelper parseUser:[attachItem objectForKey:@"creator"]]];
            [file setDownloadCount:[[attachItem objectForKey:@"downloadCounts"] integerValue]];
            [file setCreateDate:[[attachItem objectForKey:@"creationDate"] longLongValue]];
            [file setIsDir:NO];
            [fileArray addObject:file];
        }
        [[YYIMPanDBHelper sharedInstance] batchUpdateFileWithDirId:dirId fileSet:fileSet group:groupId files:fileArray ts:ts];
        
        [[self activeDelegate] didLoadFileWithDirId:dirId fileSet:fileSet group:groupId files:[self getFilesWithDirId:dirId fileSet:fileSet group:groupId]];
    } else if (code == 304) {
        [[self activeDelegate] didLoadFileWithDirId:dirId fileSet:fileSet group:groupId files:[self getFilesWithDirId:dirId fileSet:fileSet group:groupId]];
    }
}

- (void)handleSearchFileResponse:(JUMPPacket *)jumpIQ withInfo:(id <JUMPTrackingInfo>)info {
    if (!jumpIQ) {
        YYIMLogError(@"didNotReceiveFileSearchResult");
        [[self activeDelegate] didNotReceiveFileSearchResult:nil];
        return;
    }
    if (![jumpIQ checkOpData:JUMP_OPDATA(JUMPAttachmentSearchResultPacketOpCode)]) {
        YYIMLogError(@"didNotReceiveFileSearchResult:%@-%@", [jumpIQ headerData], [jumpIQ jsonString]);
        [[self activeDelegate] didNotReceiveFileSearchResult:nil];
        return;
    }
    
    NSArray *attachs = [jumpIQ objectForKey:@"attachs"];
    
    NSMutableArray *fileArray = [NSMutableArray array];
    
    for (NSDictionary *attachItem in attachs) {
        YYFile *file = [[YYFile alloc] init];
        [file setFileId:[attachItem objectForKey:@"attachId"]];
        [file setFileName:[attachItem objectForKey:@"name"]];
        [file setFileSize:[[attachItem objectForKey:@"size"] longLongValue]];
        [file setFileCreator:[attachItem objectForKey:@"creator"]];
        [file setDownloadCount:[[attachItem objectForKey:@"downloadCounts"] integerValue]];
        [file setCreateDate:[[attachItem objectForKey:@"creatorDate"] longLongValue]];
        [file setIsDir:NO];
        [fileArray addObject:file];
    }
    
    [[self activeDelegate] didReceiveFileSearchResultWithFiles:fileArray];
}

#pragma mark attach

- (void)handleAttachCreateResponse:(JUMPPacket *)jumpPacket withInfo:(id <JUMPTrackingInfo>)info {
    JUMPIQ *trackIQ = (JUMPIQ *)[info packet];
    NSString *owner = [trackIQ objectForKey:@"owner"];
    
    YYIMFileSet fileSet;
    NSString *groupId;
    if ([owner isEqualToString:[YYIMJUMPHelper getAppId]]) {
        fileSet = kYYIMFileSetPublic;
    } else if (![YYIMStringUtility isEmpty:owner]) {
        fileSet = kYYIMFileSetGroup;
        groupId = [YYIMJUMPHelper parseUser:owner];
    } else {
        fileSet = kYYIMFileSetPerson;
    }
    
    NSString *dirId = [trackIQ objectForKey:@"newDirId"];
    
    if (!jumpPacket || ![jumpPacket checkOpData:JUMP_OPDATA(JUMPOperationResultPacketOpCode)]) {
        YYIMError *error;
        if (!jumpPacket) {
            error = [YYIMError errorWithCode:YMERROR_CODE_RESPONSE_NOT_RECEIVED errorMessage:@"response not received"];
        } else if ([jumpPacket isErrorPacket]) {
            error = [YYIMError errorWithCode:[[jumpPacket objectForKey:@"code"] integerValue] errorMessage:[jumpPacket objectForKey:@"message"]];
        } else {
            error = [YYIMError errorWithCode:YMERROR_CODE_UNKNOWN_ERROR errorMessage:@"unknown error"];
        }
        
        [[self activeDelegate] didNotCreateAttachmentWithDirId:dirId fileSet:fileSet group:groupId error:error];
        return;
    }
    
    [[self activeDelegate] didCreateAttachmentWithDirId:dirId fileSet:fileSet group:groupId];
    [self loadFileWithDirId:dirId fileSet:fileSet group:groupId];
}

- (void)handleAttachRenameResponse:(JUMPPacket *)jumpPacket withInfo:(id <JUMPTrackingInfo>)info {
    JUMPIQ *trackIQ = (JUMPIQ *)[info packet];
    NSString *owner = [trackIQ objectForKey:@"owner"];
    
    YYIMFileSet fileSet;
    NSString *groupId;
    if ([owner isEqualToString:[YYIMJUMPHelper getAppId]]) {
        fileSet = kYYIMFileSetPublic;
    } else if (![YYIMStringUtility isEmpty:owner]) {
        fileSet = kYYIMFileSetGroup;
        groupId = [YYIMJUMPHelper parseUser:owner];
    } else {
        fileSet = kYYIMFileSetPerson;
    }
    
    NSString *dirId = [trackIQ objectForKey:@"dirId"];
    NSString *attachId = [trackIQ objectForKey:@"attachId"];
    
    if (!jumpPacket || ![jumpPacket checkOpData:JUMP_OPDATA(JUMPOperationResultPacketOpCode)]) {
        YYIMError *error;
        if (!jumpPacket) {
            error = [YYIMError errorWithCode:YMERROR_CODE_RESPONSE_NOT_RECEIVED errorMessage:@"response not received"];
        } else if ([jumpPacket isErrorPacket]) {
            error = [YYIMError errorWithCode:[[jumpPacket objectForKey:@"code"] integerValue] errorMessage:[jumpPacket objectForKey:@"message"]];
        } else {
            error = [YYIMError errorWithCode:YMERROR_CODE_UNKNOWN_ERROR errorMessage:@"unknown error"];
        }
        
        [[self activeDelegate] didNotRenameAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId error:error];
        return;
    }
    
    [[self activeDelegate] didRenameAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId];
    [self loadFileWithDirId:dirId fileSet:fileSet group:groupId];
}

- (void)handleAttachMoveResponse:(JUMPPacket *)jumpPacket withInfo:(id <JUMPTrackingInfo>)info {
    JUMPIQ *trackIQ = (JUMPIQ *)[info packet];
    NSString *owner = [trackIQ objectForKey:@"owner"];
    
    YYIMFileSet fileSet;
    NSString *groupId;
    if ([owner isEqualToString:[YYIMJUMPHelper getAppId]]) {
        fileSet = kYYIMFileSetPublic;
    } else if (![YYIMStringUtility isEmpty:owner]) {
        fileSet = kYYIMFileSetGroup;
        groupId = [YYIMJUMPHelper parseUser:owner];
    } else {
        fileSet = kYYIMFileSetPerson;
    }
    
    NSString *dirId = [trackIQ objectForKey:@"dirId"];
    NSString *attachId = [trackIQ objectForKey:@"attachId"];
    
    if (!jumpPacket || ![jumpPacket checkOpData:JUMP_OPDATA(JUMPOperationResultPacketOpCode)]) {
        YYIMError *error;
        if (!jumpPacket) {
            error = [YYIMError errorWithCode:YMERROR_CODE_RESPONSE_NOT_RECEIVED errorMessage:@"response not received"];
        } else if ([jumpPacket isErrorPacket]) {
            error = [YYIMError errorWithCode:[[jumpPacket objectForKey:@"code"] integerValue] errorMessage:[jumpPacket objectForKey:@"message"]];
        } else {
            error = [YYIMError errorWithCode:YMERROR_CODE_UNKNOWN_ERROR errorMessage:@"unknown error"];
        }
        
        [[self activeDelegate] didNotMoveAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId error:error];
        return;
    }
    
    [[self activeDelegate] didMoveAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId];
    [self loadFileWithDirId:dirId fileSet:fileSet group:groupId];
}

- (void)handleAttachDeleteResponse:(JUMPPacket *)jumpPacket withInfo:(id <JUMPTrackingInfo>)info {
    JUMPIQ *trackIQ = (JUMPIQ *)[info packet];
    NSString *owner = [trackIQ objectForKey:@"owner"];
    
    YYIMFileSet fileSet;
    NSString *groupId;
    if ([owner isEqualToString:[YYIMJUMPHelper getAppId]]) {
        fileSet = kYYIMFileSetPublic;
    } else if (![YYIMStringUtility isEmpty:owner]) {
        fileSet = kYYIMFileSetGroup;
        groupId = [YYIMJUMPHelper parseUser:owner];
    } else {
        fileSet = kYYIMFileSetPerson;
    }
    
    NSString *dirId = [trackIQ objectForKey:@"dirId"];
    NSString *attachId = [trackIQ objectForKey:@"attachId"];
    
    if (!jumpPacket || ![jumpPacket checkOpData:JUMP_OPDATA(JUMPOperationResultPacketOpCode)]) {
        YYIMError *error;
        if (!jumpPacket) {
            error = [YYIMError errorWithCode:YMERROR_CODE_RESPONSE_NOT_RECEIVED errorMessage:@"response not received"];
        } else if ([jumpPacket isErrorPacket]) {
            error = [YYIMError errorWithCode:[[jumpPacket objectForKey:@"code"] integerValue] errorMessage:[jumpPacket objectForKey:@"message"]];
        } else {
            error = [YYIMError errorWithCode:YMERROR_CODE_UNKNOWN_ERROR errorMessage:@"unknown error"];
        }
        
        [[self activeDelegate] didNotDeleteAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId error:error];
        return;
    }
    
    [[self activeDelegate] didDeleteAttachmentWithId:attachId dirId:dirId fileSet:fileSet group:groupId];
    [self loadFileWithDirId:dirId fileSet:fileSet group:groupId];
}

- (void)handleDirCreateResponse:(JUMPPacket *)jumpPacket withInfo:(id <JUMPTrackingInfo>)info {
    JUMPIQ *trackIQ = (JUMPIQ *)[info packet];
    NSString *owner = [trackIQ objectForKey:@"owner"];
    
    YYIMFileSet fileSet;
    NSString *groupId;
    if ([owner isEqualToString:[YYIMJUMPHelper getAppId]]) {
        fileSet = kYYIMFileSetPublic;
    } else if (![YYIMStringUtility isEmpty:owner]) {
        fileSet = kYYIMFileSetGroup;
        groupId = [YYIMJUMPHelper parseUser:owner];
    } else {
        fileSet = kYYIMFileSetPerson;
    }
    
    NSString *dirId = [trackIQ objectForKey:@"newDirId"];
    NSString *name = [trackIQ objectForKey:@"name"];
    
    if (!jumpPacket || ![jumpPacket checkOpData:JUMP_OPDATA(JUMPOperationResultPacketOpCode)]) {
        YYIMError *error;
        if (!jumpPacket) {
            error = [YYIMError errorWithCode:YMERROR_CODE_RESPONSE_NOT_RECEIVED errorMessage:@"response not received"];
        } else if ([jumpPacket isErrorPacket]) {
            error = [YYIMError errorWithCode:[[jumpPacket objectForKey:@"code"] integerValue] errorMessage:[jumpPacket objectForKey:@"message"]];
        } else {
            error = [YYIMError errorWithCode:YMERROR_CODE_UNKNOWN_ERROR errorMessage:@"unknown error"];
        }
        
        [[self activeDelegate] didNotCreateDirWithName:name parentDirId:dirId fileSet:fileSet group:groupId error:error];
        return;
    }
    
    [[self activeDelegate] didCreateDirWithName:name parentDirId:dirId fileSet:fileSet group:groupId];
    [self loadFileWithDirId:dirId fileSet:fileSet group:groupId];
}

- (void)handleDirRenameResponse:(JUMPPacket *)jumpPacket withInfo:(id <JUMPTrackingInfo>)info {
    JUMPIQ *trackIQ = (JUMPIQ *)[info packet];
    NSString *owner = [trackIQ objectForKey:@"owner"];
    
    YYIMFileSet fileSet;
    NSString *groupId;
    if ([owner isEqualToString:[YYIMJUMPHelper getAppId]]) {
        fileSet = kYYIMFileSetPublic;
    } else if (![YYIMStringUtility isEmpty:owner]) {
        fileSet = kYYIMFileSetGroup;
        groupId = [YYIMJUMPHelper parseUser:owner];
    } else {
        fileSet = kYYIMFileSetPerson;
    }
    
    NSString *dirId = [trackIQ objectForKey:@"dirId"];
    
    if (!jumpPacket || ![jumpPacket checkOpData:JUMP_OPDATA(JUMPOperationResultPacketOpCode)]) {
        YYIMError *error;
        if (!jumpPacket) {
            error = [YYIMError errorWithCode:YMERROR_CODE_RESPONSE_NOT_RECEIVED errorMessage:@"response not received"];
        } else if ([jumpPacket isErrorPacket]) {
            error = [YYIMError errorWithCode:[[jumpPacket objectForKey:@"code"] integerValue] errorMessage:[jumpPacket objectForKey:@"message"]];
        } else {
            error = [YYIMError errorWithCode:YMERROR_CODE_UNKNOWN_ERROR errorMessage:@"unknown error"];
        }
        
        [[self activeDelegate] didNotRenameDirWithId:dirId fileSet:fileSet group:groupId error:error];
        return;
    }
    
    [[self activeDelegate] didRenameDirWithId:dirId fileSet:fileSet group:groupId];
    YYFile *file = [[YYIMPanDBHelper sharedInstance] getDirWithId:dirId fileSet:fileSet group:groupId];
    [self loadFileWithDirId:[file parentDirId] fileSet:fileSet group:groupId];
}

- (void)handleDirMoveResponse:(JUMPPacket *)jumpPacket withInfo:(id <JUMPTrackingInfo>)info {
    JUMPIQ *trackIQ = (JUMPIQ *)[info packet];
    NSString *owner = [trackIQ objectForKey:@"owner"];
    
    YYIMFileSet fileSet;
    NSString *groupId;
    if ([owner isEqualToString:[YYIMJUMPHelper getAppId]]) {
        fileSet = kYYIMFileSetPublic;
    } else if (![YYIMStringUtility isEmpty:owner]) {
        fileSet = kYYIMFileSetGroup;
        groupId = [YYIMJUMPHelper parseUser:owner];
    } else {
        fileSet = kYYIMFileSetPerson;
    }
    
    NSString *dirId = [trackIQ objectForKey:@"dirId"];
    
    if (!jumpPacket || ![jumpPacket checkOpData:JUMP_OPDATA(JUMPOperationResultPacketOpCode)]) {
        YYIMError *error;
        if (!jumpPacket) {
            error = [YYIMError errorWithCode:YMERROR_CODE_RESPONSE_NOT_RECEIVED errorMessage:@"response not received"];
        } else if ([jumpPacket isErrorPacket]) {
            error = [YYIMError errorWithCode:[[jumpPacket objectForKey:@"code"] integerValue] errorMessage:[jumpPacket objectForKey:@"message"]];
        } else {
            error = [YYIMError errorWithCode:YMERROR_CODE_UNKNOWN_ERROR errorMessage:@"unknown error"];
        }
        
        [[self activeDelegate] didNotMoveDirWithId:dirId fileSet:fileSet group:groupId error:error];
        return;
    }
    
    [[self activeDelegate] didMoveDirWithId:dirId fileSet:fileSet group:groupId];
    
    YYFile *file = [[YYIMPanDBHelper sharedInstance] getDirWithId:dirId fileSet:fileSet group:groupId];
    [self loadFileWithDirId:[file parentDirId] fileSet:fileSet group:groupId];
}

- (void)handleDirDeleteResponse:(JUMPPacket *)jumpPacket withInfo:(id <JUMPTrackingInfo>)info {
    JUMPIQ *trackIQ = (JUMPIQ *)[info packet];
    NSString *owner = [trackIQ objectForKey:@"owner"];
    
    YYIMFileSet fileSet;
    NSString *groupId;
    if ([owner isEqualToString:[YYIMJUMPHelper getAppId]]) {
        fileSet = kYYIMFileSetPublic;
    } else if (![YYIMStringUtility isEmpty:owner]) {
        fileSet = kYYIMFileSetGroup;
        groupId = [YYIMJUMPHelper parseUser:owner];
    } else {
        fileSet = kYYIMFileSetPerson;
    }
    
    NSString *dirId = [trackIQ objectForKey:@"dirId"];
    
    if (!jumpPacket || ![jumpPacket checkOpData:JUMP_OPDATA(JUMPOperationResultPacketOpCode)]) {
        YYIMError *error;
        if (!jumpPacket) {
            error = [YYIMError errorWithCode:YMERROR_CODE_RESPONSE_NOT_RECEIVED errorMessage:@"response not received"];
        } else if ([jumpPacket isErrorPacket]) {
            error = [YYIMError errorWithCode:[[jumpPacket objectForKey:@"code"] integerValue] errorMessage:[jumpPacket objectForKey:@"message"]];
        } else {
            error = [YYIMError errorWithCode:YMERROR_CODE_UNKNOWN_ERROR errorMessage:@"unknown error"];
        }
        
        [[self activeDelegate] didNotDeleteDirWithId:dirId fileSet:fileSet group:groupId error:error];
        return;
    }
    
    [[self activeDelegate] didDeleteDirWithId:dirId fileSet:fileSet group:groupId];
    YYFile *file = [[YYIMPanDBHelper sharedInstance] getDirWithId:dirId fileSet:fileSet group:groupId];
    [self loadFileWithDirId:[file parentDirId] fileSet:fileSet group:groupId];
}

@end
