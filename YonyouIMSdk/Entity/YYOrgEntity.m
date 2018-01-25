//
//  YYOrgEntity.m
//  YonyouIMSdk
//
//  Created by litfb on 15/6/24.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYOrgEntity.h"
#import "YYIMStringUtility.h"

@implementation YYOrgEntity

- (NSString *)getUserPhoto {
    return [YYIMStringUtility genFullPathRes:[self userPhoto]];
}

@end
