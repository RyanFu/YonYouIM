//
//  YYIMOrgDBHelper.h
//  YonyouIMSdk
//
//  Created by litfb on 15/6/24.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYIMBaseDBHelper.h"
#import "YYOrg.h"

@interface YYIMOrgDBHelper : YYIMBaseDBHelper

+ (instancetype) sharedInstance;

#pragma mark org

- (YYOrg *)getRootOrg;

- (YYOrg *)getOrgWithParentId:(NSString *)parentId;

- (void)batchUpdateOrgWithParentId:(NSString *)parentId orgItems:(NSArray *)orgArray;

@end
