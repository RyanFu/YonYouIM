//
//  OrgInviteViewController.m
//  YonyouIM
//
//  Created by yanghao on 15/11/13.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "OrgInviteViewController.h"
#import "YYIMColorHelper.h"
#import "YYIMUtility.h"
#import "OrgCollectionViewCell.h"
#import "YYIMUIDefs.h"
#import "SingleLineSelCell.h"
#import "SingleLineCell2.h"
#import "UINavigationController+YMInvite.h"
#import "UIViewController+HUDCategory.h"


@interface OrgInviteViewController ()<YYIMChatDelegate, YMInviteDelegate>

@property (retain, nonatomic) UIBarButtonItem *confirmBtn;

@end

@implementation OrgInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isOrgCustomTitle = YES;
    
    [self initTableHeaderView];
    [self initNavigationItem];
    
    self.title = self.actionName;
    
    self.confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmAction)];
    UIImage *image = [[UIImage imageNamed:@"bg_bluebtn"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
    [self.confirmBtn setBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.confirmBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.confirmBtn;

    // 注册Cell nib
    [self.tableView registerNib:[UINib nibWithNibName:@"SingleLineSelCell" bundle:nil] forCellReuseIdentifier:@"SingleLineSelCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SingleLineCell2" bundle:nil] forCellReuseIdentifier:@"SingleLineCell2"];
    
    // 设置多余分割线隐藏
    [YYIMUtility setExtraCellLineHidden:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setInviteDelegate:self];
    
    // 注册委托
    [[YYIMChat sharedInstance].chatManager addDelegate:self];
    
    NSInteger selectedCount = [self.navigationController selectedUserArray].count;
    [self refreshConfirmStatus:selectedCount];
    
    [self.navigationController generateToolbar];
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
    
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 53, width, 1)];
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

#pragma mark UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.org orgFamily].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // cell
    OrgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OrgCollectionViewCell" forIndexPath:indexPath];
    
    YYOrg *entity = [[self.org orgFamily] objectAtIndex:indexPath.row];
    cell.nameLabel.text = [entity orgName];
    if ([[entity orgId] isEqualToString:self.orgId]) {
        [cell setIsCurrentOrg:YES];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YYOrg *entity = [[self.org orgFamily] objectAtIndex:indexPath.row];
    
    if (![[entity orgId] isEqualToString:self.orgId]) {
        NSArray *controllerArray = self.navigationController.childViewControllers;
        
        for (OrgInviteViewController *viewController in controllerArray) {
            if ([viewController isKindOfClass:[OrgInviteViewController class]] && [[entity orgId] isEqualToString:viewController.orgId]) {
                [self.navigationController popToViewController:viewController animated:YES];
                break;
            }
        }
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYOrg *entity = [[self.org orgFamily] objectAtIndex:indexPath.row];
    
    CGSize textSize = YM_MULTILINE_TEXTSIZE([entity orgName], [UIFont systemFontOfSize:16.0f], CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX))
    
    return CGSizeMake(textSize.width + 36, 52);
}

#pragma mark UITableViewDataSource, UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.org.hasOrgChildren && self.org.hasUserChildren) {
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
    if (self.org.hasOrgChildren && self.org.hasUserChildren) {
        if (section == 0) {
            return self.org.orgChildren.count;
        } else {
            return self.org.userChildren.count;
        }
    } else if (self.org.hasOrgChildren) {
        return self.org.orgChildren.count;
    } else if (self.org.hasUserChildren) {
        return self.org.userChildren.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取数据
    YYOrg *orgEntity = [self getDataWithIndexPath:indexPath];
    
    if (orgEntity.isUser) {
        // 取cell
        SingleLineSelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SingleLineSelCell"];
        [cell reuse];
        [cell setImageRadius:16];
        // 为cell设置数据
        [cell setHeadImageWithUrl:[orgEntity getUserPhoto] placeholderName:[orgEntity orgName]];
        [cell setName:[orgEntity orgName]];
        
        if ([self.navigationController isUserDisabled:[orgEntity orgId]]) {
            [cell setSelectEnable:NO];
        }
        
        UINavigationController *navController = [self navigationController];
        
        if ([navController isUserSelected:[orgEntity orgId]]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取数据
    YYOrg *orgEntity = [self getDataWithIndexPath:indexPath];
    
    //如果是用户，并且是不可选状态的不响应
    if (orgEntity.isUser && [self.navigationController isUserDisabled:orgEntity.orgId]) {
        return nil;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取数据
    YYOrg *orgEntity = [self getDataWithIndexPath:indexPath];
    
    if (orgEntity.isUser) {
        [[self navigationController] setUserSelectState:orgEntity.orgId info:orgEntity isSelect:YES];
    } else {
        OrgInviteViewController *orgViewController = [[OrgInviteViewController alloc] initWithNibName:@"OrgInviteViewController" bundle:nil];
        [orgViewController setOrgId:[orgEntity orgId]];
        orgViewController.inviteDelegate = self.inviteDelegate;
        [self.navigationController pushViewController:orgViewController animated:YES];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取数据
    YYOrg *orgEntity = [self getDataWithIndexPath:indexPath];
    
    [[self navigationController] setUserSelectState:orgEntity.orgId info:orgEntity isSelect:NO];
}

#pragma mark yminvite delegate

- (void)didSelectChangeWithCount:(NSInteger)count {
    [self refreshConfirmStatus:count];
}

- (void)didUserUnSelect:(NSString *)userId withObject:(id)userObj {
    [self.tableView reloadData];
}

#pragma mark private

/**
 *  点击确认按钮
 */
- (void)confirmAction {
    if (self.inviteDelegate && [self.inviteDelegate respondsToSelector:@selector(didConfirmInviteActionViewController:)]) {
        [self.inviteDelegate didConfirmInviteActionViewController:self];
    }
}

/**
 *  根据选择数量设置确认按钮的状态
 *
 *  @param count 选择数量
 */
- (void)refreshConfirmStatus:(NSInteger)count{
    if (self.inviteDelegate && [self.inviteDelegate respondsToSelector:@selector(getDefaultCount)]) {
        NSInteger defaultCount = [self.inviteDelegate getDefaultCount];
        
        if (defaultCount > 0) {
            count = count + defaultCount;
        }
    }
    
    if (count > 0) {
        [self.confirmBtn setTitle:[NSString stringWithFormat:@"确定(%ld)", (long)count]];
        [self.confirmBtn setEnabled:YES];
    } else {
        [self.confirmBtn setTitle:@"确定"];
        [self.confirmBtn setEnabled:NO];
    }
}

@end
