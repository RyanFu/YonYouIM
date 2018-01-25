//
//  YYIMPanDBHelper.m
//  YonyouIMSdk
//
//  Created by litfb on 15/7/7.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYIMPanDBHelper.h"
#import "YYIMDBHeader.h"
#import "YYIMConfig.h"
#import "YYIMStringUtility.h"

#define YM_CHAT_PAN_DB @"ym_pan.sqlite"

@implementation YYIMPanDBHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (NSString *)defaultDBName {
    return YM_CHAT_PAN_DB;
}

- (void) updateDatabase {
    NSInteger dbVersion = [self getDbVersion];
    
    switch (dbVersion) {
        case YYIM_DB_VERSION_EMPTY:
            [[self getDBQueue] inTransaction:^(YYFMDatabase *db, BOOL *rollback) {
                [db executeUpdate:YYIM_DBINFO_CREATE];
                [db executeUpdate:YYIM_FILE_CREATE];
                [db executeUpdate:YYIM_ATTACH_STATE_CREATE];
                [db executeUpdate:YYIM_DBINFO_INIT];
            }];
        case YYIM_DB_VERSION_INITIAL:
            [[self getDBQueue] inTransaction:^(YYFMDatabase *db, BOOL *rollback) {
                [db executeUpdate:YYIM_ATTACH_STATE_ADD_PATH];
                [db executeUpdate:YYIM_DBINFO_UPDATE, [NSNumber numberWithInteger:YYIM_DB_VERSION_1]];
            }];
        case YYIM_DB_VERSION_1:
            [[self getDBQueue] inTransaction:^(YYFMDatabase *db, BOOL *rollback) {
                [db executeUpdate:YYIM_ATTACH_STATE_ADD_UPLOAD_STATE];
                [db executeUpdate:YYIM_ATTACH_STATE_ADD_MD5];
                [db executeUpdate:YYIM_ATTACH_STATE_ADD_UPLOAD_KEY];
                [db executeUpdate:YYIM_ATTACH_STATE_ADD_FILESIZE];
                [db executeUpdate:YYIM_ATTACH_STATE_ADD_FILE_EXT];
                [db executeUpdate:YYIM_DBINFO_UPDATE, [NSNumber numberWithInteger:YYIM_DB_VERSION_2]];
            }];
        default:
            break;
    }
}

#pragma mark file

- (YYFile *)getFileWithId:(NSString *)attachId dirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    __block YYFile *file = nil;
    [[self getDBQueue] inDatabase:^(YYFMDatabase *db) {
        NSString *sql = @"SELECT * FROM yyim_file WHERE user_id=? and file_set=? and file_id=? and parent_dir_id=? and is_dir=? ";
        NSMutableArray *paramArray = [NSMutableArray array];
        [paramArray addObject:[[YYIMConfig sharedInstance] getFullUserAnonymousSpecialy]];
        [paramArray addObject:[NSNumber numberWithInt:fileSet]];
        [paramArray addObject:[YYIMStringUtility notNilString:attachId]];
        [paramArray addObject:[YYIMStringUtility notNilString:dirId]];
        [paramArray addObject:[NSNumber numberWithInt:0]];
        
        if (fileSet == kYYIMFileSetGroup) {
            sql = [sql stringByAppendingString:@"and group_id=? "];
            [paramArray addObject:groupId];
        }
        
        YYFMResultSet *rs = [db executeQuery:sql withArgumentsInArray:paramArray];
        @try {
            if ([rs next]) {
                file = [[YYFile alloc] init];
                [self fillFileWithRs:file resultset:rs];
            }
        }
        @finally {
            [rs close];
        }
    }];
    return file;
}

- (YYFile *)getDirWithId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    __block YYFile *file = nil;
    [[self getDBQueue] inDatabase:^(YYFMDatabase *db) {
        file = [self innerQueryDirWithId:dirId fileSet:fileSet group:groupId db:db];
        
        if ([dirId isEqualToString:YM_FILE_ROOT_ID] && !file) {
            file = [self innerCreateDirWithId:dirId fileSet:fileSet group:groupId db:db];
        }
    }];
    return file;
}

- (YYFile *)innerQueryDirWithId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId db:(YYFMDatabase *)db {
    NSString *sql = @"SELECT * FROM yyim_file WHERE user_id=? and file_set=? and file_id=? and is_dir=? ";
    NSMutableArray *paramArray = [NSMutableArray array];
    [paramArray addObject:[[YYIMConfig sharedInstance] getFullUserAnonymousSpecialy]];
    [paramArray addObject:[NSNumber numberWithInt:fileSet]];
    [paramArray addObject:dirId];
    [paramArray addObject:[NSNumber numberWithInt:1]];
    
    if (fileSet == kYYIMFileSetGroup) {
        sql = [sql stringByAppendingString:@"and group_id=? "];
        [paramArray addObject:groupId];
    }
    
    YYFile *file;
    YYFMResultSet *rs = [db executeQuery:sql withArgumentsInArray:paramArray];
    @try {
        if ([rs next]) {
            file = [[YYFile alloc] init];
            [self fillFileWithRs:file resultset:rs];
        }
    }
    @finally {
        [rs close];
    }
    return file;
}

- (YYFile *)innerCreateDirWithId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId db:(YYFMDatabase *)db {
    NSString *sql = @"INSERT INTO yyim_file(user_id,file_set,group_id,file_id,file_name,is_dir,ts) VALUES (?,?,?,?,?,?,?)";
    NSMutableArray *paramArray = [NSMutableArray array];
    [paramArray addObject:[[YYIMConfig sharedInstance] getFullUserAnonymousSpecialy]];
    [paramArray addObject:[NSNumber numberWithInt:fileSet]];
    [paramArray addObject:groupId ? groupId : @""];
    [paramArray addObject:dirId];
    [paramArray addObject:dirId];
    [paramArray addObject:[NSNumber numberWithInt:1]];
    [paramArray addObject:[NSNumber numberWithLongLong:0]];
    [db executeUpdate:sql withArgumentsInArray:paramArray];
    
    return [self innerQueryDirWithId:dirId fileSet:fileSet group:groupId db:db];
}

- (NSArray *)getFilesWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    __block NSMutableArray *array = [NSMutableArray array];
    [[self getDBQueue] inDatabase:^(YYFMDatabase *db) {
        NSString *sql = @"SELECT * FROM yyim_file WHERE user_id=? and file_set=? and parent_dir_id=? ";
        NSMutableArray *paramArray = [NSMutableArray array];
        [paramArray addObject:[[YYIMConfig sharedInstance] getFullUserAnonymousSpecialy]];
        [paramArray addObject:[NSNumber numberWithInt:fileSet]];
        [paramArray addObject:dirId];
        
        if (fileSet == kYYIMFileSetGroup) {
            sql = [sql stringByAppendingString:@"and group_id=? "];
            [paramArray addObject:groupId];
        }
        
        sql = [sql stringByAppendingString:@" ORDER BY is_dir DESC,file_name ASC"];
        
        YYFMResultSet *rs = [db executeQuery:sql withArgumentsInArray:paramArray];
        @try {
            while ([rs next]) {
                YYFile *file = [[YYFile alloc] init];
                [self fillFileWithRs:file resultset:rs];
                [array addObject:file];
            }
        }
        @finally {
            [rs close];
        }
    }];
    return array;
}

- (void)batchUpdateFileWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId files:(NSArray *)fileArray ts:(NSTimeInterval)ts {
    [[self getDBQueue] inTransaction:^(YYFMDatabase *db, BOOL *rollback) {
        // update parant dir ts
        NSString *sql = @"UPDATE yyim_file SET ts=? WHERE user_id=? and file_set=? and file_id=? and is_dir=? ";
        NSMutableArray *paramArray = [NSMutableArray array];
        [paramArray addObject:[NSNumber numberWithLongLong:ts]];
        [paramArray addObject:[[YYIMConfig sharedInstance] getFullUserAnonymousSpecialy]];
        [paramArray addObject:[NSNumber numberWithInt:fileSet]];
        [paramArray addObject:dirId];
        [paramArray addObject:[NSNumber numberWithInt:1]];
        
        if (fileSet == kYYIMFileSetGroup) {
            sql = [sql stringByAppendingString:@"and group_id=? "];
            [paramArray addObject:groupId];
        }
        [db executeUpdate:sql withArgumentsInArray:paramArray];
        
        // delete old data
        sql = @"DELETE FROM yyim_file WHERE user_id=? and file_set=? and parent_dir_id=? ";
        paramArray = [NSMutableArray array];
        [paramArray addObject:[[YYIMConfig sharedInstance] getFullUserAnonymousSpecialy]];
        [paramArray addObject:[NSNumber numberWithInt:fileSet]];
        [paramArray addObject:dirId];
        
        if (fileSet == kYYIMFileSetGroup) {
            sql = [sql stringByAppendingString:@"and group_id=? "];
            [paramArray addObject:groupId];
        }
        [db executeUpdate:sql withArgumentsInArray:paramArray];
        
        sql = @"INSERT INTO yyim_file(user_id,file_set,group_id,file_id,file_name,parent_dir_id,is_dir,ts,file_size,file_creator,download_count,create_date) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        
        
        for (YYFile *file in fileArray) {
            paramArray = [NSMutableArray array];
            [paramArray addObject:[[YYIMConfig sharedInstance] getFullUserAnonymousSpecialy]];
            [paramArray addObject:[NSNumber numberWithInt:fileSet]];
            [paramArray addObject:groupId ? groupId : @""];
            [paramArray addObject:[YYIMStringUtility notNilString:[file fileId]]];
            [paramArray addObject:[YYIMStringUtility notNilString:[file fileName]]];
            [paramArray addObject:[YYIMStringUtility notNilString:[file parentDirId]]];
            [paramArray addObject:[NSNumber numberWithInt:[file isDir] ? 1 : 0]];
            [paramArray addObject:[NSNumber numberWithLongLong:[file ts]]];
            [paramArray addObject:[NSNumber numberWithLongLong:[file fileSize]]];
            [paramArray addObject:[YYIMStringUtility notNilString:[file fileCreator]]];
            [paramArray addObject:[NSNumber numberWithInteger:[file downloadCount]]];
            [paramArray addObject:[NSNumber numberWithLongLong:[file createDate]]];
            [db executeUpdate:sql withArgumentsInArray:paramArray];
        }
    }];
}

- (YYAttach *)getAttachWithId:(NSString *)attachId {
    __block YYAttach *attach;
    [[self getDBQueue] inDatabase:^(YYFMDatabase *db) {
        attach = [self innerQueryAttachWithId:attachId db:db];
        if (!attach) {
            attach = [self innerCreateAttachWithId:attachId db:db];
        }
    }];
    return attach;
}

- (YYAttach *)innerQueryAttachWithId:(NSString *)attachId db:(YYFMDatabase *)db {
    NSString *sql = @"SELECT * FROM yyim_attach_state WHERE attach_id=? ";
    NSMutableArray *paramArray = [NSMutableArray array];
    [paramArray addObject:attachId];
    
    YYFMResultSet *rs = [db executeQuery:sql withArgumentsInArray:paramArray];
    @try {
        if ([rs next]) {
            return [self fillAttachWithRS:rs];
        }
    }
    @finally {
        [rs close];
    }
    return nil;
}

- (YYAttach *)innerQueryAttachWithUploadKey:(NSString *)uploadKey db:(YYFMDatabase *)db {
    NSString *sql = @"SELECT * FROM yyim_attach_state WHERE upload_key=? ";
    NSMutableArray *paramArray = [NSMutableArray array];
    [paramArray addObject:uploadKey];
    
    YYFMResultSet *rs = [db executeQuery:sql withArgumentsInArray:paramArray];
    @try {
        if ([rs next]) {
            return [self fillAttachWithRS:rs];
        }
    }
    @finally {
        [rs close];
    }
    return nil;
}

- (YYAttach *)fillAttachWithRS:(YYFMResultSet *)rs {
    YYAttach *attach = [[YYAttach alloc] init];
    [attach setAttachId:[rs stringForColumn:@"attach_id"]];
    [attach setUploadState:[rs intForColumn:@"upload_state"]];
    [attach setUploadKey:[rs stringForColumn:@"upload_key"]];
    [attach setDownloadState:[rs intForColumn:@"download_state"]];
    [attach setAttachMD5:[rs stringForColumn:@"mdfive"]];
    [attach setAttachPath:[rs stringForColumn:@"path"]];
    [attach setAttachSize:[rs longLongIntForColumn:@"file_size"]];
    [attach setAttachExt:[rs stringForColumn:@"file_ext"]];
    return attach;
}

- (YYAttach *)innerCreateAttachWithId:(NSString *)attachId db:(YYFMDatabase *)db {
    NSString *sql = @"INSERT INTO yyim_attach_state(attach_id,upload_state,upload_key,download_state,mdfive,path,file_size,file_ext) VALUES (?,?,?,?,?,?,?,?)";
    NSMutableArray *paramArray = [NSMutableArray array];
    [paramArray addObject:attachId];
    [paramArray addObject:[NSNumber numberWithInt:kYYIMAttachUploadNo]];
    [paramArray addObject:@""];
    [paramArray addObject:[NSNumber numberWithInt:kYYIMAttachDownloadNo]];
    [paramArray addObject:@""];
    [paramArray addObject:@""];
    [paramArray addObject:@""];
    [paramArray addObject:@""];
    [db executeUpdate:sql withArgumentsInArray:paramArray];
    return [self innerQueryAttachWithId:attachId db:db];
}

- (YYAttach *)innerCreateAttachWithUploadKey:(NSString *)uploadKey db:(YYFMDatabase *)db {
    NSString *sql = @"INSERT INTO yyim_attach_state(attach_id,upload_state,upload_key,download_state,mdfive,path,file_size,file_ext) VALUES (?,?,?,?,?,?,?,?)";
    NSMutableArray *paramArray = [NSMutableArray array];
    [paramArray addObject:@""];
    [paramArray addObject:[NSNumber numberWithInt:kYYIMAttachUploadNo]];
    [paramArray addObject:uploadKey];
    [paramArray addObject:[NSNumber numberWithInt:kYYIMAttachDownloadNo]];
    [paramArray addObject:@""];
    [paramArray addObject:@""];
    [paramArray addObject:@""];
    [paramArray addObject:@""];
    [paramArray addObject:@""];
    [paramArray addObject:@""];
    [db executeUpdate:sql withArgumentsInArray:paramArray];
    return [self innerQueryAttachWithUploadKey:uploadKey db:db];
}

- (YYAttach *)getAttachWithUploadKey:(NSString *)uploadKey {
    __block YYAttach *attach;
    [[self getDBQueue] inDatabase:^(YYFMDatabase *db) {
        attach = [self innerQueryAttachWithUploadKey:uploadKey db:db];
        if (!attach) {
            attach = [self innerCreateAttachWithUploadKey:uploadKey db:db];
        }
    }];
    return attach;
}

- (void)createAttach:(YYAttach *)attach {
    [[self getDBQueue] inDatabase:^(YYFMDatabase *db) {
        NSString *sql = @"INSERT INTO yyim_attach_state(attach_id,upload_state,upload_key,download_state,mdfive,path,file_size,file_ext) VALUES (?,?,?,?,?,?,?,?)";
        NSMutableArray *paramArray = [NSMutableArray array];
        [paramArray addObject:[YYIMStringUtility notNilString:[attach attachId]]];
        [paramArray addObject:[NSNumber numberWithInt:kYYIMAttachUploadNo]];
        [paramArray addObject:[YYIMStringUtility notNilString:[attach uploadKey]]];
        [paramArray addObject:[NSNumber numberWithInt:kYYIMAttachDownloadNo]];
        [paramArray addObject:[YYIMStringUtility notNilString:[attach attachMD5]]];
        [paramArray addObject:[YYIMStringUtility notNilString:[attach attachPath]]];
        [paramArray addObject:[NSNumber numberWithLongLong:[attach attachSize]]];
        [paramArray addObject:[YYIMStringUtility notNilString:[attach attachExt]]];
        [db executeUpdate:sql withArgumentsInArray:paramArray];
    }];
}

- (void)updateAttachDownloadState:(NSString *)attachId downloadState:(YYIMAttachDownloadState)downloadState path:(NSString *)path {
    [[self getDBQueue] inTransaction:^(YYFMDatabase *db, BOOL *rollback) {
        NSString *sql = @"UPDATE yyim_attach_state SET download_state=?,path=? WHERE attach_id=? ";
        NSMutableArray *paramArray = [NSMutableArray array];
        [paramArray addObject:[NSNumber numberWithInt:downloadState]];
        [paramArray addObject:[YYIMStringUtility notNilString:path]];
        [paramArray addObject:attachId];
        
        [db executeUpdate:sql withArgumentsInArray:paramArray];
    }];
}

- (void)updateAttachUploadState:(NSString *)uploadKey attachId:(NSString *)attachId uploadState:(YYIMAttachUploadState)uploadState {
    [[self getDBQueue] inTransaction:^(YYFMDatabase *db, BOOL *rollback) {
        NSString *sql = @"UPDATE yyim_attach_state SET upload_state=?,attach_id=?,download_state=? WHERE upload_key=? ";
        YYIMAttachDownloadState downloadState = uploadState == kYYIMAttachUploadSuccess ? kYYIMAttachDownloadSuccess : kYYIMAttachDownloadNo;
        NSMutableArray *paramArray = [NSMutableArray array];
        [paramArray addObject:[NSNumber numberWithInt:uploadState]];
        [paramArray addObject:[YYIMStringUtility notNilString:attachId]];
        [paramArray addObject:[NSNumber numberWithInt:downloadState]];
        [paramArray addObject:uploadKey];
        
        [db executeUpdate:sql withArgumentsInArray:paramArray];
    }];
}

- (void)updateFaildAttach {
    [[self getDBQueue] inTransaction:^(YYFMDatabase *db, BOOL *rollback) {
        NSString *sql = @"update yyim_attach_state set download_state=? where download_state=?";
        NSMutableArray *argsArray = [NSMutableArray array];
        [argsArray addObject:[NSNumber numberWithInteger:kYYIMAttachDownloadFaild]];
        [argsArray addObject:[NSNumber numberWithInteger:kYYIMAttachDownloadIng]];
        [db executeUpdate:sql withArgumentsInArray:argsArray];
        
        sql = @"update yyim_attach_state set upload_state=? where upload_state=?";
        argsArray = [NSMutableArray array];
        [argsArray addObject:[NSNumber numberWithInteger:kYYIMAttachUploadFaild]];
        [argsArray addObject:[NSNumber numberWithInteger:kYYIMAttachUploadIng]];
        [db executeUpdate:sql withArgumentsInArray:argsArray];
    }];
}

#pragma mark private

- (void)fillFileWithRs:(YYFile *)file resultset:(YYFMResultSet *)rs {
    [file setFileId:[rs stringForColumn:@"file_id"]];
    [file setFileName:[rs stringForColumn:@"file_name"]];
    [file setParentDirId:[rs stringForColumn:@"parent_dir_id"]];
    [file setIsDir:[rs intForColumn:@"is_dir"] == 1];
    [file setTs:[rs longLongIntForColumn:@"ts"]];
    [file setFileSize:[rs longLongIntForColumn:@"file_size"]];
    [file setFileCreator:[rs stringForColumn:@"file_creator"]];
    [file setDownloadCount:[rs intForColumn:@"download_count"]];
    [file setCreateDate:[rs longLongIntForColumn:@"create_date"]];
}

@end
