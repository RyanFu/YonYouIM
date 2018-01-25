//
//  YYIMOrgDBHelper.m
//  YonyouIMSdk
//
//  Created by litfb on 15/6/24.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYIMOrgDBHelper.h"
#import "YYFMDB.h"
#import "YYIMDBHeader.h"
#import "YYIMStringUtility.h"
#import "YYIMConfig.h"
#import "YYIMJUMPHelper.h"
#import "YYOrgEntity.h"
#import "YYIMDefs.h"

#define YM_CHAT_ORG_DB @"ym_org.sqlite"

@implementation YYIMOrgDBHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (NSString *)defaultDBName {
    return YM_CHAT_ORG_DB;
}

- (void) updateDatabase {
    NSInteger dbVersion = [self getDbVersion];
    
    switch (dbVersion) {
        case YYIM_DB_VERSION_EMPTY:
            [[self getDBQueue] inTransaction:^(YYFMDatabase *db, BOOL *rollback) {
                [db executeUpdate:YYIM_DBINFO_CREATE];
                [db executeUpdate:YYIM_ORG_CREATE];
                [db executeUpdate:YYIM_ORG_IDX_UNIQUE];
                [db executeUpdate:YYIM_DBINFO_INIT];
            }];
        default:
            break;
    }
}

#pragma mark org

- (YYOrg *)getRootOrg {
    __block NSString *orgId;
    [[self getDBQueue] inTransaction:^(YYFMDatabase *db, BOOL *rollback) {
        NSString *sql = @"SELECT * FROM yyim_org WHERE app_id=? AND org_id=? AND is_user=? ";
        
        NSMutableArray *paramArray = [NSMutableArray array];
        [paramArray addObject:[YYIMJUMPHelper getAppId]];
        [paramArray addObject:YM_ORG_ROOT_ID];
        [paramArray addObject:[NSNumber numberWithInteger:0]];
        
        YYFMResultSet *rs = [db executeQuery:sql withArgumentsInArray:paramArray];
        @try {
            if ([rs next]) {
                orgId = [rs stringForColumn:@"org_id"];
            }
        }
        @finally {
            [rs close];
        }
    }];
    if (orgId) {
        return [self getOrgWithParentId:orgId];
    }
    return nil;
}

- (YYOrg *)getOrgWithParentId:(NSString *)parentId {
    if ([YYIMStringUtility isEmpty:parentId]) {
        return nil;
    }
    
    __block YYOrg *org;
    [[self getDBQueue] inDatabase:^(YYFMDatabase *db) {
        // self
        org = (YYOrg *)[self getOrgEntityWithDB:db orgId:parentId isEntity:NO];
        // org children
        [org setOrgChildren:[self getOrgArrayWithDB:db parentId:parentId isUser:NO]];
        // user children
        [org setUserChildren:[self getOrgArrayWithDB:db parentId:parentId isUser:YES]];
        // family
        [org setOrgFamily:[self getOrgFamilyWithDB:db orgId:parentId]];
    }];
    return org;
}

//- (YYOrg *)getOrgWithDB:(YYFMDatabase *)db orgId:(NSString *)orgId {
//    // org
//    YYOrg *org = [[YYOrg alloc] init];
//    [org setOrgId:orgId];
//    // root
//    if ([orgId isEqualToString:YM_ORG_ROOT_ID]) {
//        return org;
//    }
//
//    NSString *sql = @"SELECT * FROM yyim_org WHERE app_id=? AND org_id=? AND is_user=? ";
//
//    NSMutableArray *paramArray = [NSMutableArray array];
//    [paramArray addObject:[YYIMJUMPHelper getAppId]];
//    [paramArray addObject:orgId];
//    [paramArray addObject:[NSNumber numberWithInteger:0]];
//
//    YYFMResultSet *rs = [db executeQuery:sql withArgumentsInArray:paramArray];
//    @try {
//        if ([rs next]) {
//            [org setOrgId:[rs stringForColumn:@"org_id"]];
//            [org setParentId:[rs stringForColumn:@"parent_id"]];
//            [org setOrgName:[rs stringForColumn:@"org_name"]];
//            [org setIsLeaf:[rs intForColumn:@"is_leaf"] == 1];
//            [org setIsUser:[rs intForColumn:@"is_user"] == 1];
//        }
//    }
//    @finally {
//        [rs close];
//    }
//    return org;
//}

- (YYOrgEntity *)getOrgEntityWithDB:(YYFMDatabase *)db orgId:(NSString *)orgId isEntity:(BOOL)isEntity {
    // org
    YYOrgEntity *orgEntity;
    if (isEntity) {
        orgEntity = [[YYOrgEntity alloc] init];
    } else {
        orgEntity = [[YYOrg alloc] init];
    }
    [orgEntity setOrgId:orgId];
    
    NSString *sql = @"SELECT * FROM yyim_org WHERE app_id=? AND org_id=? AND is_user=? ";
    
    NSMutableArray *paramArray = [NSMutableArray array];
    [paramArray addObject:[YYIMJUMPHelper getAppId]];
    [paramArray addObject:orgId];
    [paramArray addObject:[NSNumber numberWithInteger:0]];
    
    YYFMResultSet *rs = [db executeQuery:sql withArgumentsInArray:paramArray];
    @try {
        if ([rs next]) {
            [orgEntity setOrgId:[rs stringForColumn:@"org_id"]];
            [orgEntity setParentId:[rs stringForColumn:@"parent_id"]];
            [orgEntity setOrgName:[rs stringForColumn:@"org_name"]];
            [orgEntity setIsLeaf:[rs intForColumn:@"is_leaf"] == 1];
            [orgEntity setIsUser:[rs intForColumn:@"is_user"] == 1];
        }
    }
    @finally {
        [rs close];
    }
    return orgEntity;
}

- (NSArray *)getOrgArrayWithDB:(YYFMDatabase *)db parentId:(NSString *)parentId isUser:(BOOL)isUser {
    NSString *sql = @"SELECT * FROM yyim_org WHERE app_id=? AND parent_id=? AND is_user=? ORDER BY org_name ";
    
    NSMutableArray *paramArray = [NSMutableArray array];
    [paramArray addObject:[YYIMJUMPHelper getAppId]];
    [paramArray addObject:parentId];
    [paramArray addObject:[NSNumber numberWithInteger:isUser ? 1 : 0]];
    
    NSMutableArray *orgArray = [NSMutableArray array];
    YYFMResultSet *rs = [db executeQuery:sql withArgumentsInArray:paramArray];
    @try {
        while ([rs next]) {
            YYOrgEntity *orgEntity = [[YYOrgEntity alloc] init];
            [orgEntity setOrgId:[rs stringForColumn:@"org_id"]];
            [orgEntity setParentId:[rs stringForColumn:@"parent_id"]];
            [orgEntity setOrgName:[rs stringForColumn:@"org_name"]];
            [orgEntity setIsLeaf:[rs intForColumn:@"is_leaf"] == 1];
            [orgEntity setIsUser:[rs intForColumn:@"is_user"] == 1];
            [orgEntity setUserEmail:[rs stringForColumn:@"user_email"]];
            [orgEntity setUserPhoto:[rs stringForColumn:@"user_photo"]];
            [orgArray addObject:orgEntity];
        }
    }
    @finally {
        [rs close];
    }
    return orgArray;
}

- (NSArray *)getOrgFamilyWithDB:(YYFMDatabase *)db orgId:(NSString *)orgId {
    NSMutableArray *familyArray = [NSMutableArray array];
    // sql
    YYOrgEntity *org = [self getOrgEntityWithDB:db orgId:orgId isEntity:YES];
    [familyArray addObject:org];
    while ([org parentId] && ![[org parentId] isEqualToString:@"root"]) {
        org = [self getOrgEntityWithDB:db orgId:[org parentId] isEntity:YES];
        [familyArray addObject:org];
    }
    familyArray = (NSMutableArray *)[[familyArray reverseObjectEnumerator] allObjects];
    return familyArray;
}

- (void)batchUpdateOrgWithParentId:(NSString *)parentId orgItems:(NSArray *)orgArray {
    [[self getDBQueue] inTransaction:^(YYFMDatabase *db, BOOL *rollback) {
        // sql
        NSString *sql = @"SELECT org_id FROM yyim_org WHERE app_id=? AND parent_id=?";
        // parem
        NSMutableArray *paramArray = [NSMutableArray array];
        [paramArray addObject:[YYIMJUMPHelper getAppId]];
        [paramArray addObject:parentId];
        // query org id
        YYFMResultSet *rs = [db executeQuery:sql withArgumentsInArray:paramArray];
        
        NSMutableArray *orgIdArray = [NSMutableArray array];
        @try {
            while ([rs next]) {
                [orgIdArray addObject:[rs stringForColumn:@"org_id"]];
            }
        }
        @finally {
            [rs close];
        }
        
        for (YYOrgEntity *orgEntity in orgArray) {
            if ([YYIMStringUtility isEmpty:[orgEntity orgId]]) {
                continue;
            }
            NSMutableArray *array = [NSMutableArray array];
            if ([orgIdArray containsObject:[orgEntity orgId]]) {
                [array addObject:[YYIMStringUtility notNilString:[orgEntity orgName]]];
                [array addObject:[NSNumber numberWithInt:[orgEntity isLeaf] ? 1 : 0]];
                [array addObject:[NSNumber numberWithInt:[orgEntity isUser] ? 1 : 0]];
                [array addObject:[YYIMStringUtility notNilString:[orgEntity userEmail]]];
                [array addObject:[YYIMStringUtility notNilString:[orgEntity userPhoto]]];
                [array addObject:[YYIMJUMPHelper getAppId]];
                [array addObject:[YYIMStringUtility notNilString:[orgEntity parentId]]];
                [array addObject:[YYIMStringUtility notNilString:[orgEntity orgId]]];
                [db executeUpdate:YYIM_ORG_UPDATE withArgumentsInArray:array];
                [orgIdArray removeObject:[orgEntity orgId]];
            } else {
                [array addObject:[YYIMJUMPHelper getAppId]];
                [array addObject:[YYIMStringUtility notNilString:[orgEntity orgId]]];
                [array addObject:[YYIMStringUtility notNilString:[orgEntity parentId]]];
                [array addObject:[YYIMStringUtility notNilString:[orgEntity orgName]]];
                [array addObject:[NSNumber numberWithInt:[orgEntity isLeaf] ? 1 : 0]];
                [array addObject:[NSNumber numberWithInt:[orgEntity isUser] ? 1 : 0]];
                [array addObject:[YYIMStringUtility notNilString:[orgEntity userEmail]]];
                [array addObject:[YYIMStringUtility notNilString:[orgEntity userPhoto]]];
                [db executeUpdate:YYIM_ORG_INSERT withArgumentsInArray:array];
            }
        }
        
        if ([orgIdArray count] > 0) {
            for (NSString *orgId in orgIdArray) {
                [db executeUpdate:YYIM_ORG_DELETE, [YYIMJUMPHelper getAppId], parentId, orgId];
            }
        }
    }];
}

@end
