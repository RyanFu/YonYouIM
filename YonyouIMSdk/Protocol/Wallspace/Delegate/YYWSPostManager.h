//
//  YYWSPostManager.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWallspaceBaseDataManager.h"
#import "YYWSPostProtocol.h"

@interface YYWSPostManager : YYWallspaceBaseDataManager<YYWSPostProtocol>

+ (instancetype)sharedInstance;

@end
