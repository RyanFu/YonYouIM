//
//  YYOrgEntity.h
//  YonyouIMSdk
//
//  Created by litfb on 15/6/24.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYOrgEntity : NSObject

@property NSString *orgId;

@property NSString *parentId;

@property NSString *orgName;

@property BOOL isLeaf;

@property BOOL isUser;

@property NSString *userEmail;

@property NSString *userPhoto;

- (NSString *)getUserPhoto;

@end
