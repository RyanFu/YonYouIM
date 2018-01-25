//
//  YYWSDynamicManager.h
//  YonyouIMSdk
//
//  Created by litfb on 15/10/22.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWallspaceBaseDataManager.h"
#import "YYWSDynamicProtocol.h"

@interface YYWSDynamicManager : YYWallspaceBaseDataManager<YYWSDynamicProtocol>

+ (instancetype)sharedInstance;

@end
