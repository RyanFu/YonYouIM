//
//  YYWSSpaceManager.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWallspaceBaseDataManager.h"
#import "YYWSSpaceProtocol.h"

@interface YYWSSpaceManager : YYWallspaceBaseDataManager<YYWSSpaceProtocol>

+ (instancetype)sharedInstance;

@end
