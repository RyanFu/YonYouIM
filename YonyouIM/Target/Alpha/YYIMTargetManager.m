//
//  YYIMTargetManager.m
//  YonyouIM
//
//  Created by litfb on 15/8/28.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYIMTargetManager.h"
#import "YYIMUIDefs.h"
#import "YMAFNetworking.h"
#import "YYIMChatHeader.h"
#import "YYIMWallspaceConfig.h"
#import "YYIMUtility.h"

@implementation YYIMTargetManager

+ (instancetype)sharedManager {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (BOOL)allowMultiApp {
    return YES;
}

- (BOOL)allowTeleConference {
    return YES;
}

- (BOOL)allowNetMeeting {
    return YES;
}

- (BOOL)allowWallspace {
    return YES;
}

- (BOOL)allowCloudPan {
    return YES;
}

- (NSString *)getDefaultAppKey {
    return @"udn";
}

- (NSString *)getDefaultEtpKey {
    return @"yonyou";
}

@end
