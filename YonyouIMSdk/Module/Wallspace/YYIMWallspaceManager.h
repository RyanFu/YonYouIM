//
//  YYIMWallspaceManager.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/19.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYIMWallspaceProtocol.h"

@interface YYIMWallspaceManager : NSObject<YYIMWallspaceProtocol>

+ (instancetype)sharedInstance;

@end
