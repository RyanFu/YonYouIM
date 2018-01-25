//
//  OrgViewController.m
//  YonyouIM
//
//  Created by litfb on 15/6/25.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "OrgViewController.h"
#import "YYIMChatHeader.h"
#import "YYIMUtility.h"
#import "YYIMColorHelper.h"
#import "SingleLineCell.h"
#import "SingleLineCell2.h"
#import "ChatViewController.h"
#import "OrgCollectionViewCell.h"
#import "YYIMUIDefs.h"
#import "UIViewController+HUDCategory.h"
#import "UserViewController.h"

@interface OrgViewController ()

@end

@implementation OrgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableHeaderView];
    
    [self initNavigationItem];
    
    // 注册Cell nib
    [self.tableView registerNib:[UINib nibWithNibName:@"SingleLineCell" bundle:nil] forCellReuseIdentifier:@"SingleLineCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SingleLineCell2" bundle:nil] forCellReuseIdentifier:@"SingleLineCell2"];
    
    // 设置多余分割线隐藏
    [YYIMUtility setExtraCellLineHidden:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initTableHeaderView {
    CGFloat width = CGRectGetWidth(self.tableView.frame);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 53)];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 8, 0, 8)];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, 52) collectionViewLayout:flowLayout];
    [collectionView setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
    [collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    [collectionView registerNib:[UINib nibWithNibName:@"OrgCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"OrgCollectionViewCell"];
    [collectionView setShowsHorizontalScrollIndicator:YES];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [view addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 52, width, 1)];
    [sepView setBackgroundColor:UIColorFromRGB(0xe6e6e6)];
    [view addSubview:sepView];
    [self.tableView setTableHeaderView:view];
}

- (void)initNavigationItem {
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(closeAction:)]];
    [self.navigationItem setLeftItemsSupplementBackButton:YES];
}

- (void)closeAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //    self.keyword = searchText;
    //    [self filterRosters];
}

#pragma mark UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.org orgFamily].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // cell
    OrgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OrgCollectionViewCell" forIndexPath:indexPath];
    
    YYOrgEntity *entity = [[self.org orgFamily] objectAtIndex:indexPath.row];
    cell.nameLabel.text = [entity orgName];
    if ([[entity orgId] isEqualToString:self.orgId]) {
        [cell setIsCurrentOrg:YES];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YYOrgEntity *entity = [[self.org orgFamily] objectAtIndex:indexPath.row];
    
    if (![[entity orgId] isEqualToString:self.orgId]) {
        NSArray *controllerArray = self.navigationController.childViewControllers;
        
        for (OrgViewController *viewController in controllerArray) {
            if ([viewController isKindOfClass:[OrgViewController class]] && [[entity orgId] isEqualToString:viewController.orgId]) {
                [self.navigationController popToViewController:viewController animated:YES];
                break;
            }
        }
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYOrgEntity *entity = [[self.org orgFamily] objectAtIndex:indexPath.row];
    
    CGSize textSize = YM_MULTILINE_TEXTSIZE([entity orgName], [UIFont systemFontOfSize:16.0f], CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX))
    return CGSizeMake(textSize.width + 36, 52);
}

#pragma mark UITableViewDataSource, UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.org hasOrgChildren] && [self.org hasUserChildren]) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 24;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0.5)];
    [sepView setBackgroundColor:UIColorFromRGB(0xe6e6e6)];
    UIView *sepView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 24, tableView.bounds.size.width, 0.5)];
    [sepView2 setBackgroundColor:UIColorFromRGB(0xe6e6e6)];
    
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 24)];
    [sectionView setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
    [sectionView addSubview:sepView];
    [sectionView addSubview:sepView2];
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.org hasOrgChildren] && [self.org hasUserChildren]) {
        if (section == 0) {
            return [self.org orgChildren].count;
        } else {
            return [self.org userChildren].count;
        }
    } else if ([self.org hasOrgChildren]) {
        return [self.org orgChildren].count;
    } else if ([self.org hasUserChildren]) {
        return [self.org userChildren].count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取数据
    YYOrgEntity *orgEntity = [self getDataWithIndexPath:indexPath];
    if ([orgEntity isUser]) {
        // 取cell
        SingleLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SingleLineCell"];
        [cell reuse];
        [cell setImageRadius:16];
        // 为cell设置数据
        [cell setHeadImageWithUrl:[orgEntity getUserPhoto] placeholderName:[orgEntity orgName]];
        [cell setName:[orgEntity orgName]];
        return cell;
    } else {
        // 取cell
        SingleLineCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"SingleLineCell2"];
        [cell reuse];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setName:[orgEntity orgName]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YYOrgEntity *orgEntity = [self getDataWithIndexPath:indexPath];
    if ([orgEntity isUser]) {
        UserViewController *userViewController = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
        userViewController.userId = [orgEntity orgId];
        [self.navigationController pushViewController:userViewController animated:YES];
    } else if (![orgEntity isLeaf]) {
        OrgViewController *orgViewController = [[OrgViewController alloc] initWithNibName:@"OrgViewController" bundle:nil];
        [orgViewController setOrgId:[orgEntity orgId]];
        [self.navigationController pushViewController:orgViewController animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
