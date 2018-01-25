//
//  FolderViewController.m
//  YonyouIM
//
//  Created by litfb on 15/7/13.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "FolderViewController.h"
#import "PanTableViewCell1.h"
#import "YYIMUtility.h"
#import "FolderNavController.h"
#import "UIViewController+HUDCategory.h"

@interface FolderViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) YYChatGroup *group;

@property (retain, nonatomic) YYFile *dir;

@property (retain, nonatomic) NSArray *dirArray;

#pragma mark right item

@property (retain, nonatomic) UIBarButtonItem *cancelItem;

#pragma mark toolbar item

@property (retain, nonatomic) UIBarButtonItem *createItem;
@property (retain, nonatomic) UIBarButtonItem *moveItem;

@end

@implementation FolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTitle];
    
    [self initNavigationItem];
    
    [self initTableView];
    
    [self initToolBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    
    if (self.fileSet == kYYIMFileSetGroup && [self.dirId isEqualToString:YM_FILE_ROOT_ID] && !self.groupId) {
        [self.navigationController setToolbarHidden:YES];
    } else {
        [self.navigationController setToolbarHidden:NO];
    }
}

- (void)initTitle {
    // title
    if ([YYIMUtility isEmptyString:self.dirId] || [self.dirId isEqualToString:YM_FILE_ROOT_ID]) {
        if ([YYIMUtility isEmptyString:self.groupId]) {
            self.navigationItem.title = @"云盘";
        } else {
            self.group = [[YYIMChat sharedInstance].chatManager getChatGroupWithGroupId:self.groupId];
            self.navigationItem.title = [self.group groupName];
        }
    } else {
        self.dir = [[YYIMChat sharedInstance].chatManager getDirWithId:self.dirId fileSet:self.fileSet group:self.groupId];
        self.navigationItem.title = [self.dir fileName];
    }
}

- (void)initNavigationItem {
    [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem];
    [self.navigationItem setPrompt:@"请选择目标目录"];
}

- (void)initTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"PanTableViewCell1" bundle:nil] forCellReuseIdentifier:@"PanTableViewCell1"];
    
    [YYIMUtility setExtraCellLineHidden:self.tableView];
}

- (void)initToolBar {
    self.toolbarItems = [self folderToolbarItems];
}

- (void)loadData {
    if (self.fileSet == kYYIMFileSetGroup && [self.dirId isEqualToString:YM_FILE_ROOT_ID] && !self.groupId) {
        self.dirArray = [[YYIMChat sharedInstance].chatManager getAllChatGroups];
        [self.tableView reloadData];
    } else {
        NSArray *fileArray = [[YYIMChat sharedInstance].chatManager getFilesWithDirId:self.dirId fileSet:self.fileSet group:self.groupId];
        self.dirArray = [self filterDirArray:fileArray];
        [self.tableView reloadData];
        
        [[YYIMChat sharedInstance].chatManager loadFileWithDirId:self.dirId fileSet:self.fileSet group:self.groupId];
    }
}

- (void)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createAction:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新建文件夹" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 12;
    [alertView show];
}

- (void)moveAction:(id)sender {
    [[(FolderNavController *)[self navigationController] dirDelegate] didSelectDir:self.dirId fileSet:self.fileSet group:self.groupId];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dirArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *obj = [self.dirArray objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[YYChatGroup class]]) {
        // 取cell
        static NSString *CellIndentifier = @"PanTableViewCell1";
        PanTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        YYChatGroup *group = (YYChatGroup *)obj;
        [cell setIconImageName:@"icon_folder1"];
        [cell setName:[group groupName]];
        return cell;
    } else {
        // 取cell
        static NSString *CellIndentifier = @"PanTableViewCell1";
        PanTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        YYFile *file = (YYFile *)obj;
        [cell setIconImageName:@"icon_folder"];
        [cell setName:[file fileName]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *obj = [self.dirArray objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[YYChatGroup class]]) {
        YYChatGroup *group = (YYChatGroup *)obj;
        
        FolderViewController *folderViewController = [[FolderViewController alloc] initWithNibName:@"FolderViewController" bundle:nil];
        folderViewController.fileSet = self.fileSet;
        folderViewController.dirId = YM_FILE_ROOT_ID;
        folderViewController.groupId = [group groupId];
        [self.navigationController pushViewController:folderViewController animated:YES];
    } else {
        YYFile *file = (YYFile *)obj;
        
        if ([file isDir]) {
            FolderViewController *folderViewController = [[FolderViewController alloc] initWithNibName:@"PanViewController" bundle:nil];
            folderViewController.fileSet = self.fileSet;
            folderViewController.dirId = [file fileId];
            folderViewController.groupId = self.groupId;
            
            [self.navigationController pushViewController:folderViewController animated:YES];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark YYIMChatDelegate

- (void)didLoadFileWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId files:(NSArray *)fileArray {
    BOOL shouldUpdate = NO;
    if ([dirId isEqualToString:self.dirId] && fileSet == self.fileSet) {
        if (self.fileSet == kYYIMFileSetGroup) {
            if ([groupId isEqualToString:self.groupId]) {
                shouldUpdate = YES;
            }
        } else {
            shouldUpdate = YES;
        }
    }
    if (shouldUpdate) {
        self.dirArray = [self filterDirArray:fileArray];
        [self.tableView reloadData];
    }
}

- (NSArray *)filterDirArray:(NSArray *)fileArray {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"isDir == TRUE AND NOT (fileId IN %@)", [(FolderNavController *)self.navigationController dirIdArray]];
    return [fileArray filteredArrayUsingPredicate:pre];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        switch (alertView.tag) {
            case 12: {// 新建文件夹
                UITextField *textField = [alertView textFieldAtIndex:0];
                NSString *dirName = textField.text;
                if (![YYIMUtility isEmptyString:dirName]) {
                    [[YYIMChat sharedInstance].chatManager createDirWithName:dirName parentDirId:self.dirId fileSet:self.fileSet group:self.groupId];
                } else {
                    [self showHint:@"文件夹名称不能为空"];
                }
                break;
            }
        }
    }
}

#pragma mark private func

- (NSArray *)folderToolbarItems {
    if (!_folderToolbarItems) {
        if (self.fileSet == kYYIMFileSetGroup && [self.dirId isEqualToString:YM_FILE_ROOT_ID] && !self.groupId) {
            return [NSArray array];
        } else {
            UIBarButtonItem *createItem = [[UIBarButtonItem alloc] initWithTitle:@"新建文件夹" style:UIBarButtonItemStyleBordered target:self action:@selector(createAction:)];
            self.createItem = createItem;
            
            UIBarButtonItem *moveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(moveAction:)];
            self.moveItem = moveItem;
            
            UIBarButtonItem *flexibleItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:  UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            _folderToolbarItems = [NSArray arrayWithObjects:createItem, flexibleItem, moveItem, nil];
        }
    }
    return _folderToolbarItems;
}

- (UIBarButtonItem *)rightBarButtonItem {
    if (!_rightBarButtonItem) {
        self.cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(closeAction:)];
        
        _rightBarButtonItem = self.cancelItem;
    }
    return _rightBarButtonItem;
}

@end
