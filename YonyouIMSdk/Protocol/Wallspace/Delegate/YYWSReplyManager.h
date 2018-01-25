//
//  YYWSReplyManager.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWallspaceBaseDataManager.h"
#import "YYWSReplyProtocol.h"

@interface YYWSReplyManager : YYWallspaceBaseDataManager<YYWSReplyProtocol>

+ (instancetype)sharedInstance;

@end
