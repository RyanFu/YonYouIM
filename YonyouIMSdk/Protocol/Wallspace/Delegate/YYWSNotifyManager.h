//
//  YYWSNotifyManager.h
//  YonyouIMSdk
//
//  Created by litfb on 15/10/26.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWallspaceBaseDataManager.h"
#import "YYWSNotifyProtocol.h"

@interface YYWSNotifyManager : YYWallspaceBaseDataManager<YYWSNotifyProtocol>

+ (instancetype)sharedInstance;

@end
