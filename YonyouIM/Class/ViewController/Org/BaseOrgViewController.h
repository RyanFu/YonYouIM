//
//  BaseOrgViewController.h
//  YonyouIM
//
//  Created by yanghaoc on 15/11/30.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYIMBaseViewController.h"

@interface BaseOrgViewController : YYIMBaseViewController

@property NSString *orgId;

@property BOOL isOrgCustomTitle;

@property (weak, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property YYOrg *org;

- (YYOrg *)getDataWithIndexPath:(NSIndexPath *)indexPath;

@end
