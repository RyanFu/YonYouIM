//
//  YYUserProfileSetting.m
//  YonyouIMSdk
//
//  Created by hb on 2017/9/22.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "YYUserProfileSetting.h"

#define YYIM_USER_SETTING_DEFAULT_BEGIN_HOUR    23

#define YYIM_USER_SETTING_DEFAULT_BEGIN_MINUTE  0

#define YYIM_USER_SETTING_DEFAULT_END_HOUR      7

#define YYIM_USER_SETTING_DEFAULT_END_MINUTE    0

@implementation YYUserProfileSetting
+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (NSInteger)getValidBeginHour {
    NSInteger beginHour = YYIM_USER_SETTING_DEFAULT_BEGIN_HOUR;
    if (self.noDisturbBeginTimeHour >= 0) {
        beginHour = self.noDisturbBeginTimeHour;
    }
    
    return beginHour;
}

- (NSInteger)getValidBeginMinute {
    NSInteger beginMinute = YYIM_USER_SETTING_DEFAULT_BEGIN_MINUTE;
    if (self.noDisturbBeginTimeMinute >= 0) {
        beginMinute = self.noDisturbBeginTimeMinute;
    }
    
    return beginMinute;
}

- (NSInteger)getValidEndHour {
    NSInteger endHour = YYIM_USER_SETTING_DEFAULT_END_HOUR;
    if (self.noDisturbEndTimeHour >= 0) {
        endHour = self.noDisturbEndTimeHour;
    }
    
    return endHour;
}

- (NSInteger)getValidEndMinute {
    NSInteger endMinute = YYIM_USER_SETTING_DEFAULT_END_MINUTE;
    if (self.noDisturbEndTimeMinute >= 0) {
        endMinute = self.noDisturbEndTimeMinute;
    }
    
    return endMinute;
}
@end
