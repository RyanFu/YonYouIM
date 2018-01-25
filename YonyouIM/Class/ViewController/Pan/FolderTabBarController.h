//
//  FolderTabBarController.h
//  YonyouIM
//
//  Created by litfb on 15/8/6.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FolderViewController.h"

@interface FolderTabBarController : UITabBarController

@property (retain, nonatomic) FolderViewController *publicFolderViewController;

@property (retain, nonatomic) FolderViewController *groupFolderViewController;

@property (retain, nonatomic) FolderViewController *personFolderViewController;

@end
