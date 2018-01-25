//
//  YYIMSystemUtility.h
//  YonyouIMSdk
//
//  Created by hb on 2017/9/22.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define YYIM_SDK_iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@interface YYIMSystemUtility : NSObject

+ (BOOL)getUserSystemNoticeState;

+ (NSString *)getDeviceType;
@end
