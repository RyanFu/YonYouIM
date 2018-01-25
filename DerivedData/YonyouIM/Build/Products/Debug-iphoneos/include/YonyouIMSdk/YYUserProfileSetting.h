//
//  YYUserProfileSetting.h
//  YonyouIMSdk
//
//  Created by hb on 2017/9/22.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYUserProfileSetting : NSObject
@property (nonatomic, assign) BOOL isRemind;
// 是否展示详情
@property (nonatomic, assign) BOOL isPreview;
// 声音
@property (nonatomic, assign) BOOL isVoiceInApp;
// 震动
@property (nonatomic, assign) BOOL isVibrateInApp;
// 勿扰模式
@property (nonatomic, assign) BOOL noDisturbSwitch;
//勿扰时间
@property (nonatomic, assign) NSInteger noDisturbBeginTimeHour;

@property (nonatomic, assign) NSInteger noDisturbBeginTimeMinute;

@property (nonatomic, assign) NSInteger noDisturbEndTimeHour;

@property (nonatomic, assign) NSInteger noDisturbEndTimeMinute;
// 沉浸模式
@property (nonatomic, assign) BOOL silenceSwitch;

- (NSInteger)getValidBeginHour;

- (NSInteger)getValidBeginMinute;

- (NSInteger)getValidEndHour;

- (NSInteger)getValidEndMinute;

+ (instancetype)sharedInstance;
@end
