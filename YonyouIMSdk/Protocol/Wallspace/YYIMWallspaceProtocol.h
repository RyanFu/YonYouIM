//
//  YYIMWallspaceProtocol.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YYIMWallspaceDelegate.h"
#import "YYWSDynamicProtocol.h"
#import "YYWSNotifyProtocol.h"
#import "YYWSPostProtocol.h"
#import "YYWSReplyProtocol.h"
#import "YYWSSpaceProtocol.h"
#import "YYWSSpaceUserAuthProtocol.h"
#import "YYWSSpaceUserRelationProtocol.h"
#import "YYWSUtilProtocol.h"

@protocol YYIMWallspaceProtocol <YYWSSpaceProtocol, YYWSSpaceUserRelationProtocol, YYWSPostProtocol, YYWSReplyProtocol, YYWSUtilProtocol, YYWSSpaceUserAuthProtocol, YYWSDynamicProtocol, YYWSNotifyProtocol>

@required

- (void)addDelegate:(id<YYIMWallspaceDelegate>)delegate;

- (void)removeDelegate:(id<YYIMWallspaceDelegate>)delegate;

@end
