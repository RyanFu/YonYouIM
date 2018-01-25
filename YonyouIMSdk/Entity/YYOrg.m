//
//  YYOrg.m
//  YonyouIMSdk
//
//  Created by litfb on 15/6/25.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYOrg.h"

@implementation YYOrg

- (BOOL)hasOrgChildren {
    return self.orgChildren && self.orgChildren.count > 0;
}

- (BOOL)hasUserChildren {
    return self.userChildren && self.userChildren.count > 0;
}

@end
