//
//  OrgInviteViewController.h
//  YonyouIM
//
//  Created by yanghao on 15/11/13.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseOrgViewController.h"
#import "YMGlobalInviteDelegate.h"

@interface OrgInviteViewController : BaseOrgViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>

@property NSString *actionName;

// delegate
@property (nonatomic, weak) id<YMGlobalInviteDelegate> inviteDelegate;

@end
