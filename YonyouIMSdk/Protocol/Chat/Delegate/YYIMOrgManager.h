//
//  YYIMOrgManager.h
//  YonyouIMSdk
//
//  Created by litfb on 15/6/24.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYIMBaseDataManager.h"
#import "YYIMOrgProtocol.h"

@interface YYIMOrgManager : YYIMBaseDataManager<YYIMOrgProtocol>

+ (instancetype)sharedInstance;

@end
