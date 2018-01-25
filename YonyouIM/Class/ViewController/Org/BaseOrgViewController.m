//
//  BaseOrgViewController.m
//  YonyouIM
//
//  Created by yanghaoc on 15/11/30.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "BaseOrgViewController.h"

@interface BaseOrgViewController ()

@end

@implementation BaseOrgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 加载数据
    [self loadData];
}

#pragma mark YYIMChatDelegate

- (void)didReceiveOrgWithParentId:(NSString *)parentId org:(YYOrg *)org {
    if ([parentId isEqual:self.orgId]) {
        self.org = org;
    }
    [[self tableView] reloadData];
}

#pragma mark private func

- (void)loadData {
    if (!self.orgId) {
        self.orgId = YM_ORG_ROOT_ID;
    }
    self.org = [[YYIMChat sharedInstance].chatManager getOrgWithParentId:self.orgId];
    
    [[YYIMChat sharedInstance].chatManager loadOrgWithParentId:[self.org orgId]];
    
    if (!self.isOrgCustomTitle && self.org.orgName) {
        if ([self.org orgName]) {
            self.title = [self.org orgName];
        } else {
            self.title = @"组织架构";
        }
    }
}

#pragma mark public func

- (YYOrgEntity *)getDataWithIndexPath:(NSIndexPath *)indexPath {
    if ([self.org hasOrgChildren] && [self.org hasUserChildren]) {
        if ([indexPath section] == 0) {
            return [[self.org orgChildren] objectAtIndex:indexPath.row];
        } else {
            return [[self.org userChildren] objectAtIndex:indexPath.row];
        }
    } else if ([self.org hasOrgChildren]) {
        return [[self.org orgChildren] objectAtIndex:indexPath.row];
    } else if ([self.org hasUserChildren]) {
        return [[self.org userChildren] objectAtIndex:indexPath.row];
    }
    return nil;
}

@end
