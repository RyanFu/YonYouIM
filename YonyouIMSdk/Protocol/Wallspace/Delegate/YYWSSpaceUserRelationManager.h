//
//  YYWSSpaceUserRelationManager.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWallspaceBaseDataManager.h"
#import "YYWSSpaceUserRelationProtocol.h"

@interface YYWSSpaceUserRelationManager : YYWallspaceBaseDataManager<YYWSSpaceUserRelationProtocol>

+ (instancetype)sharedInstance;

@end
