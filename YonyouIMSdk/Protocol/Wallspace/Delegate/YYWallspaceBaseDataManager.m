//
//  YYWallspaceBaseDataManager.m
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYWallspaceBaseDataManager.h"

@interface YYWallspaceBaseDataManager ()

@property (retain, atomic) YMGCDMulticastDelegate<YYIMWallspaceDelegate> *multicastDelegate;

@end

@implementation YYWallspaceBaseDataManager

+ (instancetype)managerWithDelegate:(YMGCDMulticastDelegate<YYIMWallspaceDelegate> *)aDelegate {
    id manager = [[[self class] alloc] init];
    [manager activeWithDelegate:aDelegate];
    return manager;
}

- (void)activeWithDelegate:(YMGCDMulticastDelegate<YYIMWallspaceDelegate> *)aDelegate {
    self.multicastDelegate = aDelegate;
}

- (YMGCDMulticastDelegate<YYIMWallspaceDelegate> *)activeDelegate {
    return self.multicastDelegate;
}

@end
