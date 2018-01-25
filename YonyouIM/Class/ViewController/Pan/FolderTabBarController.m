//
//  FolderTabBarController.m
//  YonyouIM
//
//  Created by litfb on 15/8/6.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "FolderTabBarController.h"
#import "YYIMChatHeader.h"
#import "YYIMUtility.h"
#import "YYIMUIDefs.h"
#import "YYIMColorHelper.h"

static const BOOL isAllowGroup = NO;

@interface FolderTabBarController ()<YYIMChatDelegate>

@end

@implementation FolderTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YYIMUtility clearBackButtonText:self];
    
    self.title = @"云盘";
    [self.navigationItem setPrompt:@"请选择目标目录"];
    
    [self setupSubviews];
    
    if ([[YYIMConfig sharedInstance] isPanAdmin]) {
        self.navigationItem.rightBarButtonItem = [self.publicFolderViewController rightBarButtonItem];
        self.toolbarItems = [self.publicFolderViewController folderToolbarItems];
    } else if (isAllowGroup) {
        self.navigationItem.rightBarButtonItem = [self.groupFolderViewController rightBarButtonItem];
        self.toolbarItems = [self.groupFolderViewController folderToolbarItems];
    } else {
        self.navigationItem.rightBarButtonItem = [self.personFolderViewController rightBarButtonItem];
        self.toolbarItems = [self.personFolderViewController folderToolbarItems];
    }
    
    // ios7+适配
    [YYIMUtility adapterIOS7ViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    if (![[YYIMConfig sharedInstance] isPanAdmin] && !isAllowGroup) {
        UIView * transitionView = [[self.view subviews] objectAtIndex:0];
        transitionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        transitionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.tabBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0);
        self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    } else {
        UIView * transitionView = [[self.view subviews] objectAtIndex:0];
        transitionView.frame = CGRectMake(0, 49, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        transitionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.tabBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 49);
        self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
}

- (void)setupSubviews {
    if ([[YYIMConfig sharedInstance] isPanAdmin]) {
        [self addChildViewController:self.publicFolderViewController];
    }
    if (isAllowGroup) {
        [self addChildViewController:self.groupFolderViewController];
    }
    [self addChildViewController:self.personFolderViewController];
    if (YYIM_iOS7) {
        [self.tabBar setBarTintColor:UIColorFromRGB(0xf7f7f7)];
    }
    [self.tabBar setTintColor:UIColorFromRGB(0xf7f7f7)];
    [self.tabBar setShadowImage:[YYIMUtility imageWithColor:[UIColor clearColor]]];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    switch (item.tag) {
        case 1:
            self.navigationItem.rightBarButtonItem = [self.publicFolderViewController rightBarButtonItem];
            self.toolbarItems = [self.publicFolderViewController folderToolbarItems];
            break;
        case 2:
            self.navigationItem.rightBarButtonItem = [self.groupFolderViewController rightBarButtonItem];
            self.toolbarItems = [self.groupFolderViewController folderToolbarItems];
            break;
        case 3:
            self.navigationItem.rightBarButtonItem = [self.personFolderViewController rightBarButtonItem];
            self.toolbarItems = [self.personFolderViewController folderToolbarItems];
            break;
        default:
            break;
    }
}

#pragma mark private func

- (FolderViewController *)publicFolderViewController {
    if (!_publicFolderViewController) {
        FolderViewController *folderViewController = [[FolderViewController alloc] initWithNibName:@"FolderViewController" bundle:nil];
        
        folderViewController.fileSet = kYYIMFileSetPublic;
        folderViewController.dirId = YM_FILE_ROOT_ID;
        
        UITabBarItem *item = [YYIMUtility tabBarItemWithTitle:@"公共" tag:1];
        [folderViewController setTabBarItem:item];
        
        _publicFolderViewController = folderViewController;
    }
    return _publicFolderViewController;
}

- (FolderViewController *)groupFolderViewController {
    if (!_groupFolderViewController) {
        FolderViewController *folderViewController = [[FolderViewController alloc] initWithNibName:@"FolderViewController" bundle:nil];
        
        folderViewController.fileSet = kYYIMFileSetGroup;
        folderViewController.dirId = YM_FILE_ROOT_ID;
        
        UITabBarItem *item = [YYIMUtility tabBarItemWithTitle:@"群组" tag:2];
        [folderViewController setTabBarItem:item];
        
        _groupFolderViewController = folderViewController;
    }
    return _groupFolderViewController;
}

- (FolderViewController *)personFolderViewController {
    if (!_personFolderViewController) {
        FolderViewController *folderViewController = [[FolderViewController alloc] initWithNibName:@"FolderViewController" bundle:nil];
        
        folderViewController.fileSet = kYYIMFileSetPerson;
        folderViewController.dirId = YM_FILE_ROOT_ID;
        
        UITabBarItem *item = [YYIMUtility tabBarItemWithTitle:@"个人" tag:3];
        [folderViewController setTabBarItem:item];
        
        _personFolderViewController = folderViewController;
    }
    return _personFolderViewController;
}

@end
