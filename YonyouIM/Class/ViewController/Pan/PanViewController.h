//
//  PanViewController.h
//  YonyouIM
//
//  Created by litfb on 15/7/6.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYIMBaseViewController.h"

@interface PanViewController : YYIMBaseViewController<UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>

@property YYIMFileSet fileSet;

@property NSString *dirId;

@property NSString *groupId;

@property (retain, nonatomic) UIBarButtonItem *rightBarButtonItem;

@property (retain, nonatomic) NSArray *panToolbarItems;

@end

@interface UIToolbar (PanCategory)

@end
