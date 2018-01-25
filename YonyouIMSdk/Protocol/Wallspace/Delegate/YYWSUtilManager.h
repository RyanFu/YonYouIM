//
//  YYWSUtilManager.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWallspaceBaseDataManager.h"
#import "YYWSUtilProtocol.h"

@interface YYWSUtilManager : YYWallspaceBaseDataManager<YYWSUtilProtocol>

+ (instancetype)sharedInstance;

@end
