//
//  GroupAnnouncementSetController.m
//  YonyouIM
//
//  Created by hb on 2017/9/8.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "GroupAnnouncementSetController.h"
#import "UIImageView+WebCache.h"
#import "YYIMUtility.h"
#import "YYIMInputViewController.h"

@interface GroupAnnouncementSetController ()
@property (weak, nonatomic) IBOutlet UIImageView *iImageView;
@property (weak, nonatomic) IBOutlet UILabel *iNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iLineHeight;
@property (weak, nonatomic) IBOutlet UITextView *iTextView;
/**
 群组model
 */
@property (retain, nonatomic) YYChatGroup *iGroup;
@end

@implementation GroupAnnouncementSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initView];
}
#pragma mark 界面初始化
- (void)initView {
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editItem:)]];

    if (self.groupId && self.groupId.length > 0) {
        self.iGroup = [[YYIMChat sharedInstance].chatManager getChatGroupWithGroupId:self.groupId];
    }
    
    self.iTextView.text = self.iGroup.announcementContent;
    self.iTimeLabel.text = [YYIMUtility genTimeString:self.iGroup.announcementTs];
    
    if (self.iGroup.announcementCreator) {
        NSRange range = [self.iGroup.announcementCreator rangeOfString:@"."];
        if (range.location > 0 && range.location < self.iGroup.announcementCreator.length) {
            NSString *userId = [self.iGroup.announcementCreator substringToIndex:range.location];
            YYUser *user = [[YYIMChat sharedInstance].chatManager getUserWithId:userId];
            UIImage *image = [UIImage imageNamed:@"icon_head"];
            [self.iImageView sd_setImageWithURL:[NSURL URLWithString:[user getUserPhoto]] placeholderImage:image];
            self.iNameLabel.text = user.userName;
        }
    }
    self.iTextView.editable = NO;
    self.iLineHeight.constant = 0.5f;
}
#pragma mark 按钮方法
- (void)editItem:(UIBarButtonItem *)item {
    YYIMInputViewController *vc = [[YYIMInputViewController alloc] initWithNibName:@"YYIMInputViewController" bundle:nil];
    vc.iGroupId = self.groupId;
    vc.iText = self.iGroup.announcementContent;
    [self.navigationController pushViewController:vc animated:YES];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [array removeObject:self];
    self.navigationController.viewControllers = array;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
