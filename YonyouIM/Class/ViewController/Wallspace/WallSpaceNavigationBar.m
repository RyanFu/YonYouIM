//
//  WallSpaceNavigationBar.m
//  YonyouIM
//
//  Created by litfb on 15/8/19.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "WallSpaceNavigationBar.h"

@implementation WallSpaceNavigationBar

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fitSize = [super sizeThatFits:size];
    fitSize.height = 0;
    return fitSize;
}

@end
