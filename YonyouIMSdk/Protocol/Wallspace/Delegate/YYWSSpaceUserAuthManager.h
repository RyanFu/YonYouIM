//
//  YYWSSpaceUserAuthManager.h
//  YonyouIMSdk
//
//  Created by litfb on 15/10/22.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWallspaceBaseDataManager.h"
#import "YYWSSpaceUserAuthProtocol.h"

@interface YYWSSpaceUserAuthManager : YYWallspaceBaseDataManager<YYWSSpaceUserAuthProtocol>

+ (instancetype)sharedInstance;

@end
