//
//  AttachViewController.m
//  YonyouIM
//
//  Created by litfb on 15/7/14.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "AttachViewController.h"
#import "YYIMUtility.h"
#import "YMNormalProgressView.h"
#import "UIColor+YYIMTheme.h"
#import "PreviewViewController.h"
#import "YYIMUIDefs.h"

@interface AttachViewController ()<YYIMAttachProgressDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet UIView *progressContainer;

@property (weak, nonatomic) YMNormalProgressView *progressView;

@end

@implementation AttachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"文件预览";
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(closeAction:)]];
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initData {
    [self.iconImage setImage:[UIImage imageNamed:[YYIMUtility fileIconWithExt:[[self.file fileName] pathExtension]]]];
    [self.nameLabel setText:[self.file fileName]];
    [self.sizeLabel setText:[YYIMUtility fileSize:[self.file fileSize]]];
    // name label size
    CGSize size = YM_MULTILINE_TEXTSIZE([self.file fileName], [self.nameLabel font], CGSizeMake(300.0f, CGFLOAT_MAX));
    [self.nameLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:(size.height + 10.0f)]];
    
    YMNormalProgressView *progressView = [[YMNormalProgressView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.progressContainer.frame), CGRectGetHeight(self.progressContainer.frame))];
    [progressView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    progressView.progressBackColor = [UIColor whiteColor];
    progressView.progressTintColor = [UIColor themeBlueColor];
    [self.progressContainer addSubview:progressView];
    self.progressView = progressView;
    
    [[YYIMChat sharedInstance].chatManager addAttachProgressDelegate:self];
    
    YYAttach *attach = [[YYIMChat sharedInstance].chatManager getAttachState:[self.file fileId]];
    switch ([attach downloadState]) {
        case kYYIMAttachDownloadIng:
            [self.downloadLabel setText:@"下载中"];
            break;
        case kYYIMAttachDownloadSuccess: {
            [self.downloadLabel setText:@"下载完成"];
            [self.progressView setProgress:1.0f];
            [self previewFile];
            break;
        }
        default:
            break;
    }
}

- (void)previewFile {
    PreviewViewController *preViewController = [[PreviewViewController alloc] initWithNibName:nil bundle:nil];
    preViewController.file = self.file;
    [self.navigationController pushViewController:preViewController animated:YES];
}

#pragma mark YYIMAttachProgressDelegate

- (void)attachDownloadProgress:(float)progress totalSize:(long long)totalSize readedSize:(long long)readedSize withAttachKey:(NSString *)attachKey {
    if ([attachKey isEqualToString:[self.file fileId]]) {
        if (totalSize < 0) {
            totalSize = [self.file fileSize];
            progress = (float)readedSize/totalSize;
        }
        [self.progressView setProgress:progress];
    }
}

- (void)attachDownloadComplete:(BOOL)result withAttachKey:(NSString *)attachKey error:(YYIMError *)error {
    if ([attachKey isEqualToString:[self.file fileId]]) {
        if (result && !error) {
            [self.downloadLabel setText:@"下载完成"];
            //        [self openPreviewController];
            [self previewFile];
        } else {
            [self.downloadLabel setText:@"下载失败"];
        }
    }
}

@end
