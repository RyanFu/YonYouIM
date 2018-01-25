//
//  YYIMWallspaceDelegate.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YYWSSpaceDelegate.h"
#import "YYWSSpaceUserRelationDelegate.h"
#import "YYWSSpaceUserAuthDelegate.h"
#import "YYWSPostDelegate.h"
#import "YYWSReplyDelegate.h"
#import "YYWSUserDelegate.h"
#import "YYWSDynamicDelegate.h"
#import "YYWSNotifyDelegate.h"

@protocol YYIMWallspaceDelegate <YYWSSpaceDelegate, YYWSSpaceUserRelationDelegate, YYWSPostDelegate, YYWSReplyDelegate, YYWSUserDelegate, YYWSSpaceUserAuthDelegate, YYWSDynamicDelegate, YYWSNotifyDelegate>

@end
