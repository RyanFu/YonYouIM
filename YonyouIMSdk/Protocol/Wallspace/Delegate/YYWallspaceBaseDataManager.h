//
//  YYWallspaceBaseDataManager
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYIMWallspaceDelegate.h"

@class YMGCDMulticastDelegate;

@interface YYWallspaceBaseDataManager : NSObject

- (void)activeWithDelegate:(YMGCDMulticastDelegate<YYIMWallspaceDelegate> *)aDelegate;

- (YMGCDMulticastDelegate<YYIMWallspaceDelegate> *)activeDelegate;

@end
