//
//  YYOrg.h
//  YonyouIMSdk
//
//  Created by litfb on 15/6/25.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYOrgEntity.h"

@interface YYOrg : YYOrgEntity

@property NSArray *orgFamily;

@property NSArray *orgChildren;

@property NSArray *userChildren;

- (BOOL)hasOrgChildren;

- (BOOL)hasUserChildren;

@end
