//
//  PanTabBarController.h
//  YonyouIM
//
//  Created by litfb on 15/7/9.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanViewController.h"

@interface PanTabBarController : UITabBarController

@property (retain, nonatomic) PanViewController *publicPanViewController;

@property (retain, nonatomic) PanViewController *groupPanViewController;

@property (retain, nonatomic) PanViewController *personPanViewController;

@end
