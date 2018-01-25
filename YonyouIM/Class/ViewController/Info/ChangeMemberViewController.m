//
//  ChangeMemberViewController.m
//  YonyouIM
//
//  Created by hb on 2017/9/7.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "ChangeMemberViewController.h"
#import "YYIMUtility.h"
#import "UIViewController+HUDCategory.h"
#import "SingleLineSelCell.h"
#import "ChatViewController.h"
#import "UINavigationController+YMInvite.h"
#import "YYIMColorHelper.h"
#import "YYIMUIDefs.h"
#import "TableBackgroundView.h"
#import "AddRosterViewController.h"
#import "YYIMFirstLetterHelper.h"

@interface ChangeMemberViewController ()<YMInviteDelegate,UIGestureRecognizerDelegate, UISearchBarDelegate>
@property (retain, nonatomic) UIBarButtonItem *confirmBtn;

@property NSString *seriId;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *rosterTableView;

@property (retain, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (retain, nonatomic) NSArray *letterArray;

@property (retain, nonatomic) NSDictionary *dataDic;

@property (retain, nonatomic) NSString *keyword;

@property (retain, nonatomic) TableBackgroundView *emptyBgView;

@end

@implementation ChangeMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.actionName;
    
    self.confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmAction)];
    UIImage *image = [[UIImage imageNamed:@"bg_bluebtn"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
    [self.confirmBtn setBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.confirmBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.confirmBtn;
    
    // searchBar背景色
    [[self searchBar] setBackgroundImage:[YYIMUtility imageWithColor:UIColorFromRGB(0xefeff4)]];
    
    // 注册Cell nib
    UINib *singleCellNib = [UINib nibWithNibName:@"SingleLineSelCell" bundle:nil];
    [self.rosterTableView registerNib:singleCellNib forCellReuseIdentifier:@"SingleLineSelCell"];
    
    if (YYIM_iOS7) {
        [self.rosterTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    }
    [self.rosterTableView setSectionIndexColor:UIColorFromRGB(0xb6b6b6)];
    // 设置多余分割线隐藏
    [YYIMUtility setExtraCellLineHidden:self.rosterTableView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTap:)];
    tapGestureRecognizer.delegate = self;
    [tapGestureRecognizer setCancelsTouchesInView:YES];
    [self.rosterTableView addGestureRecognizer:tapGestureRecognizer];
    self.tapGestureRecognizer = tapGestureRecognizer;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    
    [[self navigationController] setInviteDelegate:self];
    
    NSInteger selectedCount = [self.navigationController selectedUserArray].count;
    [self refreshConfirmStatus:selectedCount];
    
    [self.navigationController generateToolbar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController clearData];
    [self.navigationController setToolbarHidden:YES];
}

- (void)confirmAction {
    if (self.addManager) {
        self.addManager([[self navigationController] selectedUserArray]);
    }
    if (self.removeMember) {
        self.removeMember([[self navigationController] selectedUserArray]);
    }
    if (self.removeManager) {
        self.removeManager([[self navigationController] selectedUserArray]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark table delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.letterArray count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.letterArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    NSString *key = [self.letterArray objectAtIndex:index];
    if (key == UITableViewIndexSearch) {
        [self.rosterTableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    return [self.letterArray objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 24;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 0, 320, 24);
    label.font = [UIFont systemFontOfSize:14];
    [label setTextColor:UIColorFromRGB(0x4e4e4e)];
    label.text = sectionTitle;
    
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0.5)];
    [sepView setBackgroundColor:UIColorFromRGB(0xe6e6e6)];
    UIView *sepView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 24, tableView.bounds.size.width, 0.5)];
    [sepView2 setBackgroundColor:UIColorFromRGB(0xe6e6e6)];
    
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 24)];
    [sectionView setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
    [sectionView addSubview:label];
    [sectionView addSubview:sepView];
    [sectionView addSubview:sepView2];
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)[self.dataDic objectForKey:[self.letterArray objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取cell
    SingleLineSelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SingleLineSelCell"];
    [cell reuse];
    [cell setImageRadius:16];
    // 取数据
    YYChatGroupMember *member = [self getDataWithIndexPath:indexPath];
    // 为cell设置数据
    [cell setHeadImageWithUrl:[member getMemberPhoto] placeholderName:member.memberName];
    [cell setName:member.memberName];
    
    UINavigationController *navController = [self navigationController];
    
    if ([navController isUserDisabled:[member memberId]]) {
        [cell setSelectEnable:NO];
    }
    
    if ([navController isUserSelected:[member memberId]]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取数据
    YYChatGroupMember *member = [self getDataWithIndexPath:indexPath];
    if ([self.navigationController isUserDisabled:[member memberId]]) {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YYChatGroupMember *member = [self getDataWithIndexPath:indexPath];
    [[self navigationController] setUserSelectState:[member memberId] info:member isSelect:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    YYChatGroupMember *member = [self getDataWithIndexPath:indexPath];
    [[self navigationController] setUserSelectState:[member memberId] info:member isSelect:NO];
}

#pragma mark yminvite delegate

- (void)didSelectChangeWithCount:(NSInteger)count {
    [self refreshConfirmStatus:count];
}

- (void)didUserUnSelect:(NSString *)userId withObject:(id)userObj {
    [self.rosterTableView reloadData];
}

#pragma mark private func

/**
 *  根据选择数量设置确认按钮的状态
 *
 *  @param count 选择数量
 */
- (void)refreshConfirmStatus:(NSInteger)count{
    if (count > 0) {
        [self.confirmBtn setTitle:[NSString stringWithFormat:@"确定(%ld)", (long)count]];
        [self.confirmBtn setEnabled:YES];
    } else {
        [self.confirmBtn setTitle:@"确定"];
        [self.confirmBtn setEnabled:NO];
    }
}

#pragma mark uitableview

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self tableTap:nil];
}

#pragma mark searchbar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.keyword = searchText;
    [self filterRosters];
}

#pragma mark yyimchat delegate

- (void)didRosterChange {
    [self loadData];
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([self.searchBar isFirstResponder]) {
        return YES;
    }
    return NO;
}
#pragma mark util

- (void)addRosterAction:(id)sender {
    AddRosterViewController *addRosterViewController = [[AddRosterViewController alloc] initWithNibName:@"AddRosterViewController" bundle:nil];
    [self.navigationController pushViewController:addRosterViewController animated:YES];
}

- (void)tableTap:(id)sender {
    [self.searchBar resignFirstResponder];
}

- (void)loadData {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.memberArray];
    for (YYChatGroupMember *member in array) {
        if ([[member memberId] isEqualToString:[[YYIMConfig sharedInstance] getUser]]) {
            [array removeObject:member];
            break;
        }
    }
    self.memberArray = array;
    [self filterRosters];
    if (self.memberArray.count > 0) {
        if (self.emptyBgView) {
            [self.emptyBgView removeFromSuperview];
        }
    } else {
        if (!self.emptyBgView) {
            TableBackgroundView *emptyBgView = [[TableBackgroundView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) title:@"还没有好友哦" type:kYYIMTableBackgroundTypeNormal];
            [self.view insertSubview:emptyBgView aboveSubview:self.rosterTableView];
            
            [emptyBgView addBtnTarget:self action:@selector(addRosterAction:) forControlEvents:UIControlEventTouchUpInside];
            self.emptyBgView = emptyBgView;
            [self.emptyBgView addGestureRecognizer:self.tapGestureRecognizer];
        }
    }
}

- (NSString *) firstLetter:(NSString *) name {
    return [[YYIMFirstLetterHelper firstLetter:name] uppercaseString];
}

- (NSString *)transform:(NSString *)name {
    NSMutableString *string = [name mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)string, NULL, kCFStringTransformMandarinLatin, NO);
    string = (NSMutableString *) [string stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)filterRosters {
    if ([YYIMUtility isEmptyString:self.keyword]) {
        [self generateDataDic:self.memberArray];
    } else {
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"memberName CONTAINS[cd] %@", self.keyword ,self.keyword];
        NSArray *array = [self.memberArray filteredArrayUsingPredicate:pre];
        [self generateDataDic:array];
    }
}

- (void)generateDataDic:(NSArray *)rosterArray {
    NSMutableArray *letterArray = [NSMutableArray array];
    [letterArray addObject:UITableViewIndexSearch];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    for (YYChatGroupMember *member in rosterArray) {
        if (![letterArray containsObject:[self firstLetter:member.memberName]]) {
            [letterArray addObject:[self firstLetter:member.memberName]];
        }
        NSMutableArray *array = [dataDic objectForKey:[self firstLetter:member.memberName]];
        if (!array) {
            array = [NSMutableArray array];
            [dataDic setObject:array forKey:[self firstLetter:member.memberName]];
        }
        [array addObject:member];
    }
    self.letterArray = letterArray;
    self.dataDic = dataDic;
    [self.rosterTableView reloadData];
}

- (YYChatGroupMember *)getDataWithIndexPath:(NSIndexPath *) indexPath {
    NSArray *array = [self.dataDic objectForKey:[self.letterArray objectAtIndex:indexPath.section]];
    YYChatGroupMember *member = [array objectAtIndex:indexPath.row];
    return member;
}

@end
