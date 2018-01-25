//
//  PanViewController.m
//  YonyouIM
//
//  Created by litfb on 15/7/6.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "PanViewController.h"
#import "PanTableViewCell.h"
#import "PanTableViewCell1.h"
#import "SingleLineCell.h"
#import "YYIMUtility.h"
#import "YYIMColorHelper.h"
#import "UIButton+YYIMCatagory.h"
#import "PanToolView.h"
#import "YMToolButton.h"
#import "YYIMColorHelper.h"
#import "JZSwipeCell.h"
#import "AssetsGroupViewController.h"
#import "FolderViewController.h"
#import "FolderNavController.h"
#import "ChatSelViewController.h"
#import "ChatSelNavController.h"
#import "AttachViewController.h"
#import "UIViewController+HUDCategory.h"
#import "PreviewViewController.h"

@interface PanViewController ()<UIActionSheetDelegate, UIAlertViewDelegate, JZSwipeCellDelegate, YYIMAssetDelegate, YMDirDelegate, YMChatSelDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

#pragma mark data

@property (retain, nonatomic) YYChatGroup *group;

@property (retain, nonatomic) YYFile *dir;

@property (retain, nonatomic) NSArray *fileArray;

#pragma mark right item

@property (retain, nonatomic) UIBarButtonItem *menuItem;

@property (retain, nonatomic) UIBarButtonItem *cancelItem;

#pragma mark toolbar item

@property (retain, nonatomic) UIBarButtonItem *downloadItem;
@property (retain, nonatomic) UIBarButtonItem *forwardItem;
@property (retain, nonatomic) UIBarButtonItem *deleteItem;
@property (retain, nonatomic) UIBarButtonItem *moveItem;

#pragma mark action sheet option indexpath

@property (retain, nonatomic) YYFile *optFile;

@property (retain, nonatomic) NSArray *optFileArray;

@end

@implementation PanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTitle];
    
    [self initNavigationItem];
    
    [self initTableView];
    
    [self initToolBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    
    if (![self.tableView isEditing]) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(closeAction:)]];
    [self.navigationItem setLeftItemsSupplementBackButton:YES];
    [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem];
}

- (void)initTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"PanTableViewCell" bundle:nil] forCellReuseIdentifier:@"PanTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PanTableViewCell1" bundle:nil] forCellReuseIdentifier:@"PanTableViewCell1"];
    
    [YYIMUtility setExtraCellLineHidden:self.tableView];
}

- (void)initToolBar {
    self.toolbarItems = self.panToolbarItems;
}

- (void)loadData {
    if (self.fileSet == kYYIMFileSetGroup && [self.dirId isEqualToString:YM_FILE_ROOT_ID] && !self.groupId) {
        self.fileArray = [[YYIMChat sharedInstance].chatManager getAllChatGroups];
        [self.tableView reloadData];
    } else {
        self.fileArray = [[YYIMChat sharedInstance].chatManager getFilesWithDirId:self.dirId fileSet:self.fileSet group:self.groupId];
        [self.tableView reloadData];
        
        [[YYIMChat sharedInstance].chatManager loadFileWithDirId:self.dirId fileSet:self.fileSet group:self.groupId];
    }
}

- (void)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)menuAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"上传文件", @"新建文件夹", @"选择", nil];
    actionSheet.tag = 1;
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
}

- (void)cancelAction:(id)sender {
    if ([self.tableView isEditing]) {
        
        [self.tableView setEditing:NO animated:YES];
        
        [self.navigationController setToolbarHidden:YES animated:YES];
        
        self.rightBarButtonItem = self.menuItem;
        [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem];
        if (self.tabBarController) {
            [self.tabBarController.navigationItem setRightBarButtonItem:self.rightBarButtonItem];
        }
    }
}

- (void)downloadAction:(id)sender {
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    if (indexPaths.count > 0) {
        NSMutableArray *attachIdArray = [NSMutableArray array];
        for (NSIndexPath *indexPath in indexPaths) {
            YYFile *file = [self.fileArray objectAtIndex:indexPath.row];
            if (![file isDir]) {
                [attachIdArray addObject:[file fileId]];
            }
        }
        [[YYIMChat sharedInstance].chatManager downloadAttachmentsWithId:attachIdArray dirId:self.dirId fileSet:self.fileSet group:self.groupId];
        [self cancelAction:nil];
    }
}

- (void)forwardAction:(id)sender {
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    if (indexPaths.count > 0) {
        NSMutableArray *dirIdArray = [NSMutableArray array];
        NSMutableArray *optFileArray = [NSMutableArray array];
        for (NSIndexPath *indexPath in indexPaths) {
            YYFile *file = [self.fileArray objectAtIndex:indexPath.row];
            if ([file isDir]) {
                [dirIdArray addObject:[file fileId]];
            }
            [optFileArray addObject:file];
        }
        self.optFileArray = optFileArray;
        
        ChatSelViewController *chatSelViewController = [[ChatSelViewController alloc] initWithNibName:@"ChatSelViewController" bundle:nil];
        ChatSelNavController *chatSelNavController = [[ChatSelNavController alloc] initWithRootViewController:chatSelViewController];
        [YYIMUtility genThemeNavController:chatSelNavController];
        chatSelNavController.chatSelDelegate = self;
        [self presentViewController:chatSelNavController animated:YES completion:nil];
    }
}

- (void)deleteAction:(id)sender {
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    if (indexPaths.count > 0) {
        for (NSIndexPath *indexPath in indexPaths) {
            YYFile *file = [self.fileArray objectAtIndex:indexPath.row];
            if ([file isDir]) {
                [[YYIMChat sharedInstance].chatManager deleteDirWithId:[file fileId] fileSet:self.fileSet group:self.groupId];
            } else {
                [[YYIMChat sharedInstance].chatManager deleteAttachmentWithId:[file fileId] dirId:self.dirId fileSet:self.fileSet group:self.groupId];
            }
        }
    }
    [self cancelAction:nil];
}

- (void)moveAction:(id)sender {
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    if (indexPaths.count > 0) {
        NSMutableArray *dirIdArray = [NSMutableArray array];
        NSMutableArray *optFileArray = [NSMutableArray array];
        for (NSIndexPath *indexPath in indexPaths) {
            YYFile *file = [self.fileArray objectAtIndex:indexPath.row];
            if ([file isDir]) {
                [dirIdArray addObject:[file fileId]];
            }
            [optFileArray addObject:file];
        }
        self.optFileArray = optFileArray;
        FolderViewController *folderViewController = [[FolderViewController alloc] initWithNibName:@"FolderViewController" bundle:nil];
        folderViewController.fileSet = self.fileSet;
        folderViewController.dirId = YM_FILE_ROOT_ID;
        folderViewController.groupId = self.groupId;
        
        FolderNavController *folderNavController = [[FolderNavController alloc] initWithRootViewController:folderViewController];
        [YYIMUtility genThemeNavController:folderNavController];
        folderNavController.dirIdArray = [NSArray arrayWithArray:dirIdArray];
        folderNavController.dirDelegate = self;
        [self presentViewController:folderNavController animated:YES completion:nil];
    }
}

#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fileArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *obj = [self.fileArray objectAtIndex:indexPath.row];
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
        static NSString *CellIndentifier = @"PanTableViewCell";
        PanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        YYFile *file = (YYFile *)obj;
        [cell setActiveFile:file];
        if ([file isDir]) {
            if (self.fileSet == kYYIMFileSetPublic && ![[YYIMConfig sharedInstance] isPanAdmin]) {
                [cell setEnableSwipe:NO];
            }
            [cell setIconImageName:@"icon_folder"];
            [cell setDetail:[YYIMUtility genTimeString:[file createDate]]];
        } else {
            [cell setIconImageName:[YYIMUtility fileIconWithExt:[[file fileName] pathExtension]]];
            [cell setProp:[YYIMUtility fileSize:[file fileSize]]];
            if ([file user]) {
                [cell setDetail:[NSString stringWithFormat:@"%@,%@", [[file user] userName], [YYIMUtility genTimeString:[file createDate]]]];
            } else {
                [cell setDetail:[YYIMUtility genTimeString:[file createDate]]];
            }
        }
        [cell setName:[file fileName]];
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![tableView isEditing]) {
        NSObject *obj = [self.fileArray objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[YYChatGroup class]]) {
            YYChatGroup *group = (YYChatGroup *)obj;
            
            PanViewController *panViewController = [[PanViewController alloc] initWithNibName:@"PanViewController" bundle:nil];
            panViewController.fileSet = self.fileSet;
            panViewController.dirId = YM_FILE_ROOT_ID;
            panViewController.groupId = [group groupId];
            
            [self.navigationController pushViewController:panViewController animated:YES];
        } else {
            YYFile *file = (YYFile *)obj;
            
            if ([file isDir]) {
                PanViewController *panViewController = [[PanViewController alloc] initWithNibName:@"PanViewController" bundle:nil];
                panViewController.fileSet = self.fileSet;
                panViewController.dirId = [file fileId];
                panViewController.groupId = self.groupId;
                [self.navigationController pushViewController:panViewController animated:YES];
            } else {
                YYAttach *attach = [[YYIMChat sharedInstance].chatManager getAttachState:[file fileId]];
                switch ([attach downloadState]) {
                    case kYYIMAttachDownloadNo:
                    case kYYIMAttachDownloadFaild:
                        [[YYIMChat sharedInstance].chatManager downloadAttachmentWithId:[file fileId] dirId:self.dirId fileSet:self.fileSet group:self.groupId];
                    case kYYIMAttachDownloadIng: {
                        AttachViewController *attachViewController = [[AttachViewController alloc] initWithNibName:@"AttachViewController" bundle:nil];
                        attachViewController.file = file;
                        
                        UINavigationController *attachNavController = [YYIMUtility themeNavController:attachViewController];
                        [self presentViewController:attachNavController animated:YES completion:nil];
                        //                        [self.navigationController pushViewController:attachViewController animated:YES];
                        break;
                    }
                    case kYYIMAttachDownloadSuccess: {
                        PreviewViewController *previewController = [[PreviewViewController alloc] initWithNibName:nil bundle:nil];
                        previewController.file = file;
                        
                        UINavigationController *previewNavController = [YYIMUtility themeNavController:previewController];
                        [self presentViewController:previewNavController animated:YES completion:nil];
                        //                        [self.navigationController pushViewController:previewController animated:YES];
                        break;
                    }
                }
            }
        }
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else {
        [self changeToolItemState];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEditing]) {
        [self changeToolItemState];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
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
        self.fileArray = fileArray;
        [self.tableView reloadData];
    }
}

- (void)didNotUploadFileWithDirId:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId error:(YYIMError *)error {
    if ([dirId isEqualToString:self.dirId] && fileSet == self.fileSet) {
        if (self.fileSet == kYYIMFileSetGroup) {
            if ([groupId isEqualToString:self.groupId]) {
                return;
            }
        }
        
        if ([[[error srcError] domain] isEqualToString:@"NSURLErrorDomain"]) {
            [self showHint:@"上传文件失败，请检查网络状态后重试"];
        } else {
            [self showHint:@"上传文件失败"];
        }
    }
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (actionSheet.tag) {
        case 1:
            switch (buttonIndex) {
                case 0: {// 上传文件
                    AssetsGroupViewController *assetsGroupViewController = [[AssetsGroupViewController alloc] initWithNibName:@"AssetsGroupViewController" bundle:nil];
                    [assetsGroupViewController setDelegate:self];
                    
                    UINavigationController *assetsGroupNavController = [YYIMUtility themeNavController:assetsGroupViewController];
                    [self presentViewController:assetsGroupNavController animated:YES completion:nil];
                    break;
                }
                case 1: {// 新建文件夹
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新建文件夹" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                    alertView.tag = 12;
                    [alertView show];
                    break;
                }
                case 2:// 选择
                    if (![self.tableView isEditing]) {
                        [self.tableView setEditing:YES animated:YES];
                        
                        [self.navigationController setToolbarHidden:NO animated:YES];
                        
                        self.rightBarButtonItem = self.cancelItem;
                        [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem];
                        if (self.tabBarController) {
                            [self.tabBarController.navigationItem setRightBarButtonItem:self.rightBarButtonItem];
                        }
                    }
                    break;
            }
            break;
        case 2:// dir
            switch (buttonIndex) {
                case 0:// 删除
                    [[YYIMChat sharedInstance].chatManager deleteDirWithId:[self.optFile fileId] fileSet:self.fileSet group:self.groupId];
                    self.optFile = nil;
                    break;
                case 1: {// 重命名
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重命名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                    UITextField *textField = [alertView textFieldAtIndex:0];
                    [textField setText:[self.optFile fileName]];
                    alertView.tag = 21;
                    [alertView show];
                    break;
                }
                case 2: {// 移动
                    FolderViewController *folderViewController = [[FolderViewController alloc] initWithNibName:@"FolderViewController" bundle:nil];
                    folderViewController.fileSet = self.fileSet;
                    folderViewController.dirId = YM_FILE_ROOT_ID;
                    folderViewController.groupId = self.groupId;
                    
                    FolderNavController *folderNavController = [[FolderNavController alloc] initWithRootViewController:folderViewController];
                    [YYIMUtility genThemeNavController:folderNavController];
                    folderNavController.dirIdArray = [NSArray arrayWithObject:[self.optFile fileId]];
                    folderNavController.dirDelegate = self;
                    [self presentViewController:folderNavController animated:YES completion:nil];
                    break;
                }
            }
            break;
        case 3:// attachment
            switch (buttonIndex) {
                case 0:// 删除
                    [[YYIMChat sharedInstance].chatManager deleteAttachmentWithId:[self.optFile fileId] dirId:self.dirId fileSet:self.fileSet group:self.groupId];
                    self.optFile = nil;
                    break;
                case 1: {// 分享
                    ChatSelViewController *chatSelViewController = [[ChatSelViewController alloc] initWithNibName:@"ChatSelViewController" bundle:nil];
                    ChatSelNavController *chatSelNavController = [[ChatSelNavController alloc] initWithRootViewController:chatSelViewController];
                    [YYIMUtility genThemeNavController:chatSelNavController];
                    chatSelNavController.chatSelDelegate = self;
                    [self presentViewController:chatSelNavController animated:YES completion:nil];
                    break;
                }
                case 2: {// 重命名
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重命名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                    UITextField *textField = [alertView textFieldAtIndex:0];
                    [textField setText:[[self.optFile fileName] stringByDeletingPathExtension]];
                    alertView.tag = 32;
                    [alertView show];
                    break;
                }
                case 3: {// 移动
                    FolderViewController *folderViewController = [[FolderViewController alloc] initWithNibName:@"FolderViewController" bundle:nil];
                    folderViewController.fileSet = self.fileSet;
                    folderViewController.dirId = YM_FILE_ROOT_ID;
                    folderViewController.groupId = self.groupId;
                    
                    FolderNavController *folderNavController = [[FolderNavController alloc] initWithRootViewController:folderViewController];
                    [YYIMUtility genThemeNavController:folderNavController];
                    folderNavController.dirIdArray = [NSArray arrayWithObject:[self.optFile fileId]];
                    folderNavController.dirDelegate = self;
                    [self presentViewController:folderNavController animated:YES completion:nil];
                    break;
                }
            }
            break;
        case 4:
            switch (buttonIndex) {
                case 0: {// 分享
                    ChatSelViewController *chatSelViewController = [[ChatSelViewController alloc] initWithNibName:@"ChatSelViewController" bundle:nil];
                    ChatSelNavController *chatSelNavController = [[ChatSelNavController alloc] initWithRootViewController:chatSelViewController];
                    [YYIMUtility genThemeNavController:chatSelNavController];
                    chatSelNavController.chatSelDelegate = self;
                    [self presentViewController:chatSelNavController animated:YES completion:nil];
                    break;
                }
            }
            break;
    }
}

#pragma mark UIAlertViewDelegate

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
            case 21: {
                UITextField *textField = [alertView textFieldAtIndex:0];
                NSString *dirName = textField.text;
                if (![YYIMUtility isEmptyString:dirName]) {
                    [[YYIMChat sharedInstance].chatManager renameDirWithId:[self.optFile fileId] newName:dirName fileSet:self.fileSet group:self.groupId];
                    self.optFile = nil;
                } else {
                    [self showHint:@"文件夹名称不能为空"];
                }
                break;
            }
            case 32: {
                UITextField *textField = [alertView textFieldAtIndex:0];
                NSString *attachName = textField.text;
                if (![YYIMUtility isEmptyString:attachName]) {
                    attachName = [attachName stringByAppendingPathExtension:[[self.optFile fileName] pathExtension]];
                    [[YYIMChat sharedInstance].chatManager renameAttachmentWithId:[self.optFile fileId] dirId:self.dirId newName:attachName fileSet:self.fileSet group:self.groupId];
                    self.optFile = nil;
                } else {
                    [self showHint:@"文件名称不能为空"];
                }
                break;
            }
        }
    }
}

#pragma mark JZSwipeCellDelegate

- (void)swipeCell:(JZSwipeCell*)cell triggeredSwipeWithType:(JZSwipeType)swipeType {
    PanTableViewCell *panCell = (PanTableViewCell *)cell;
    YYFile *file = [panCell activeFile];
    self.optFile = file;
    switch (swipeType) {
        case JZSwipeTypeLongLeft: {
            UIActionSheet *actionSheet;
            if ([file isDir]) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"重命名", @"移动", nil];
                actionSheet.tag = 2;
            } else {
                if (self.fileSet == kYYIMFileSetPublic && ![[YYIMConfig sharedInstance] isPanAdmin]) {
                    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享", nil];
                    actionSheet.tag = 4;
                } else {
                    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"分享", @"重命名", @"移动", nil];
                    actionSheet.tag = 3;
                }
            }
            actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
            [actionSheet showInView:self.view];
            break;
        }
        default:
            break;
    }
}

#pragma mark YYIMAssetDelegate

- (void)didSelectAssets:(NSArray *)assets isOriginal:(BOOL)isOriginal {
    if (assets && [assets count] > 0) {
        [[YYIMChat sharedInstance].chatManager uploadFileWithDirId:self.dirId fileSet:self.fileSet group:self.groupId assets:assets isOriginal:isOriginal];
    }
}

#pragma mark YMDirDelegate

- (void)didSelectDir:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId {
    if ([dirId isEqualToString:[self.optFile parentDirId]]) {
        [self showHint:@"您要移动的文件已经在目标文件夹中"];
        return;
    }
    if ([self.tableView isEditing] && self.optFileArray.count > 0) {
        for (YYFile *file in self.optFileArray) {
            if ([file isDir]) {
                [[YYIMChat sharedInstance].chatManager moveDirWithId:[file fileId] newParentDirId:dirId fileSet:self.fileSet group:self.groupId];
            } else {
                [[YYIMChat sharedInstance].chatManager moveAttachmentWithId:[file fileId] dirId:self.dirId newDirId:dirId fileSet:self.fileSet group:self.groupId];
            }
        }
        self.optFileArray = nil;
        [self cancelAction:nil];
    } else if (self.optFile) {
        if ([self.optFile isDir]) {
            [[YYIMChat sharedInstance].chatManager moveDirWithId:[self.optFile fileId] newParentDirId:dirId fileSet:self.fileSet group:self.groupId];
        } else {
            [[YYIMChat sharedInstance].chatManager moveAttachmentWithId:[self.optFile fileId] dirId:self.dirId newDirId:dirId fileSet:self.fileSet group:self.groupId];
        }
        self.optFile = nil;
    }
}

#pragma mark YMChatSelDelegate

- (void)didSelectChatId:(NSString *)chatId chatType:(NSString *)chatType {
    if ([self.tableView isEditing] && self.optFileArray.count > 0) {
        [[YYIMChat sharedInstance].chatManager sendFileMessage:chatId files:self.optFileArray chatType:chatType];
        self.optFileArray = nil;
        [self cancelAction:nil];
    } else if (self.optFile) {
        [[YYIMChat sharedInstance].chatManager sendFileMessage:chatId files:[NSArray arrayWithObject:self.optFile] chatType:chatType];
        self.optFile = nil;
    }
}

#pragma mark private func

- (UIBarButtonItem *)rightBarButtonItem {
    BOOL showRightItem;
    switch (self.fileSet) {
        case kYYIMFileSetPublic:
            if ([[YYIMConfig sharedInstance] isPanAdmin]) {
                showRightItem = YES;
            } else {
                showRightItem = NO;
            }
            break;
        case kYYIMFileSetGroup:
            if (!self.groupId) {
                showRightItem = NO;
            } else {
                showRightItem = YES;
            }
            break;
        case kYYIMFileSetPerson:
            showRightItem = YES;
            break;
        default:
            showRightItem = NO;
            break;
    }
    if (showRightItem) {
        if (!_rightBarButtonItem) {
            self.menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(menuAction:)];
            self.cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAction:)];
            
            _rightBarButtonItem = self.menuItem;
        }
        return _rightBarButtonItem;
    } else {
        return nil;
    }
}

- (NSArray *)panToolbarItems {
    if (!_panToolbarItems) {
        YMToolButton *downloadButton = [[YMToolButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        [downloadButton.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [downloadButton setImage:[UIImage imageNamed:@"icon_pan_download_hl"] title:@"下载" titleColor:UIColorFromRGB(0x67c5f8) forState:UIControlStateNormal];
        [downloadButton setImage:[UIImage imageNamed:@"icon_pan_download"] title:@"下载" titleColor:UIColorFromRGB(0x808184) forState:UIControlStateDisabled];
        [downloadButton addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *downloadItem = [[UIBarButtonItem alloc] initWithCustomView:downloadButton];
        [downloadItem setEnabled:NO];
        self.downloadItem = downloadItem;
        
        YMToolButton *forwardButton = [[YMToolButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        [forwardButton.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [forwardButton setImage:[UIImage imageNamed:@"icon_pan_forward_hl"] title:@"分享" titleColor:UIColorFromRGB(0x67c5f8) forState:UIControlStateNormal];
        [forwardButton setImage:[UIImage imageNamed:@"icon_pan_forward"] title:@"分享" titleColor:UIColorFromRGB(0x808184) forState:UIControlStateDisabled];
        [forwardButton addTarget:self action:@selector(forwardAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
        [forwardItem setEnabled:NO];
        self.forwardItem = forwardItem;
        
        YMToolButton *deleteButton = [[YMToolButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        [deleteButton.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [deleteButton setImage:[UIImage imageNamed:@"icon_pan_delete_hl"] title:@"删除" titleColor:UIColorFromRGB(0x67c5f8) forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"icon_pan_delete"] title:@"删除" titleColor:UIColorFromRGB(0x808184) forState:UIControlStateDisabled];
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
        [deleteItem setEnabled:NO];
        self.deleteItem = deleteItem;
        
        YMToolButton *moveButton = [[YMToolButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        [moveButton.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [moveButton setImage:[UIImage imageNamed:@"icon_pan_move_hl"] title:@"移动" titleColor:UIColorFromRGB(0x67c5f8) forState:UIControlStateNormal];
        [moveButton setImage:[UIImage imageNamed:@"icon_pan_move"] title:@"移动" titleColor:UIColorFromRGB(0x808184) forState:UIControlStateDisabled];
        [moveButton addTarget:self action:@selector(moveAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *moveItem = [[UIBarButtonItem alloc] initWithCustomView:moveButton];
        [moveItem setEnabled:NO];
        self.moveItem = moveItem;
        
        UIBarButtonItem *flexibleItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:  UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        _panToolbarItems = [NSArray arrayWithObjects:downloadItem, flexibleItem, forwardItem, flexibleItem, deleteItem, flexibleItem, moveItem, nil];
    }
    return _panToolbarItems;
}

- (void)changeToolItemState {
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    
    BOOL isDownloadEnable = YES;
    BOOL isForwardEnable = YES;
    BOOL isDeleteEnable = YES;
    BOOL isMoveEnable = YES;
    
    if (indexPaths.count <= 0) {
        isDownloadEnable = NO;
        isForwardEnable = NO;
        isDeleteEnable = NO;
        isMoveEnable = NO;
    } else {
        if (self.fileSet == kYYIMFileSetPublic && ![[YYIMConfig sharedInstance] isPanAdmin]) {
            isDeleteEnable = NO;
            isMoveEnable = NO;
        }
        
        for (NSIndexPath *indexPath in indexPaths) {
            NSObject *obj = [self.fileArray objectAtIndex:indexPath.row];
            if (![obj isKindOfClass:[YYFile class]]) {
                break;
            }
            YYFile *file = (YYFile *)obj;
            if ([file isDir]) {
                isDownloadEnable = NO;
                isForwardEnable = NO;
                break;
            }
        }
    }
    
    [self.downloadItem setEnabled:isDownloadEnable];
    [self.forwardItem setEnabled:isForwardEnable];
    [self.deleteItem setEnabled:isDeleteEnable];
    [self.moveItem setEnabled:isMoveEnable];
}

@end

@implementation UIToolbar (PanCategory)

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize result = [super sizeThatFits:size];
    result.height = 49.0f;
    return result;
}

@end