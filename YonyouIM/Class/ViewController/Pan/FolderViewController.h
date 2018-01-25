//
//  FolderViewController.h
//  YonyouIM
//
//  Created by litfb on 15/7/13.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYIMBaseViewController.h"
#import "YYIMChatHeader.h"

@interface FolderViewController : YYIMBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property YYIMFileSet fileSet;

@property NSString *dirId;

@property NSString *groupId;

@property (retain, nonatomic) UIBarButtonItem *rightBarButtonItem;

@property (retain, nonatomic) NSArray *folderToolbarItems;

@end
