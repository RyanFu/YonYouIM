//
//  YYIMPanManager.h
//  YonyouIMSdk
//
//  Created by litfb on 15/7/6.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYIMBaseDataManager.h"
#import "YYIMPanProtocol.h"

@interface YYIMPanManager : YYIMBaseDataManager<YYIMPanProtocol>

+ (instancetype)sharedInstance;

@end
