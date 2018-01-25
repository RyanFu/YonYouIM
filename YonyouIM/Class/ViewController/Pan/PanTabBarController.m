//
//  PanTabBarController.m
//  YonyouIM
//
//  Created by litfb on 15/7/9.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "PanTabBarController.h"
#import "YYIMUtility.h"
#import "YYIMColorHelper.h"
#import "YYIMUIDefs.h"

@interface PanTabBarController ()<YYIMChatDelegate>

@end

@implementation PanTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YYIMUtility clearBackButtonText:self];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)]];
    [self.navigationItem setLeftItemsSupplementBackButton:YES];
    
    self.title = @"云盘";
    
    [self setupSubviews];
    
    self.navigationItem.rightBarButtonItem = [self.publicPanViewController rightBarButtonItem];
    self.toolbarItems = [self.publicPanViewController panToolbarItems];
    
    // ios7+适配
    [YYIMUtility adapterIOS7ViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    UIView * transitionView = [[self.view subviews] objectAtIndex:0];
    transitionView.frame = CGRectMake(0, 49, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    transitionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.tabBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 49);
    self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setupSubviews {
    [self addChildViewController:self.publicPanViewController];
    [self addChildViewController:self.groupPanViewController];
    [self addChildViewController:self.personPanViewController];
    if (YYIM_iOS7) {
        [self.tabBar setBarTintColor:UIColorFromRGB(0xf7f7f7)];
    }
    [self.tabBar setTintColor:UIColorFromRGB(0xf7f7f7)];
    [self.tabBar setShadowImage:[YYIMUtility imageWithColor:[UIColor clearColor]]];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    switch (item.tag) {
        case 1:
            self.navigationItem.rightBarButtonItem = [self.publicPanViewController rightBarButtonItem];
            self.toolbarItems = [self.publicPanViewController panToolbarItems];
            break;
        case 2:
            self.navigationItem.rightBarButtonItem = [self.groupPanViewController rightBarButtonItem];
            self.toolbarItems = [self.groupPanViewController panToolbarItems];
            break;
        case 3:
            self.navigationItem.rightBarButtonItem = [self.personPanViewController rightBarButtonItem];
            self.toolbarItems = [self.personPanViewController panToolbarItems];
            break;
        default:
            break;
    }
}

#pragma mark private func

- (PanViewController *)publicPanViewController {
    if (!_publicPanViewController) {
        PanViewController *panViewController = [[PanViewController alloc] initWithNibName:@"PanViewController" bundle:nil];
        
        panViewController.fileSet = kYYIMFileSetPublic;
        panViewController.dirId = YM_FILE_ROOT_ID;
        
        UITabBarItem *item = [YYIMUtility tabBarItemWithTitle:@"公共" tag:1];
        [panViewController setTabBarItem:item];
        
        _publicPanViewController = panViewController;
    }
    return _publicPanViewController;
}

- (PanViewController *)groupPanViewController {
    if (!_groupPanViewController) {
        PanViewController *panViewController = [[PanViewController alloc] initWithNibName:@"PanViewController" bundle:nil];
        
        panViewController.fileSet = kYYIMFileSetGroup;
        panViewController.dirId = YM_FILE_ROOT_ID;
        
        UITabBarItem *item = [YYIMUtility tabBarItemWithTitle:@"群组" tag:2];
        [panViewController setTabBarItem:item];
        
        _groupPanViewController = panViewController;
    }
    return _groupPanViewController;
}

- (PanViewController *)personPanViewController {
    if (!_personPanViewController) {
        PanViewController *panViewController = [[PanViewController alloc] initWithNibName:@"PanViewController" bundle:nil];
        
        panViewController.fileSet = kYYIMFileSetPerson;
        panViewController.dirId = YM_FILE_ROOT_ID;
        
        UITabBarItem *item = [YYIMUtility tabBarItemWithTitle:@"个人" tag:3];
        [panViewController setTabBarItem:item];
        
        _personPanViewController = panViewController;
    }
    return _personPanViewController;
}

@end
