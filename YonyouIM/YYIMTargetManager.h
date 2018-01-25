//
//  YYIMTargetManager.h
//  YonyouIM
//
//  Created by litfb on 15/8/28.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYIMTargetManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)allowMultiApp;

- (BOOL)allowTeleConference;

- (BOOL)allowNetMeeting;

- (BOOL)allowWallspace;

- (BOOL)allowCloudPan;

- (NSString *)getDefaultAppKey;

- (NSString *)getDefaultEtpKey;

@end
