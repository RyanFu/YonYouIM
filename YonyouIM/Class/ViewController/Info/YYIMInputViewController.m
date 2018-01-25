//
//  YYIMInputViewController.m
//  YonyouIM
//
//  Created by hb on 2017/9/8.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "YYIMInputViewController.h"
#import "UIViewController+HUDCategory.h"

@interface YYIMInputViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *iTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iTextViewBottom;

@end

@implementation YYIMInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}
#pragma mark 界面初始化
- (void)initView {
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishItem:)]];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backItem:)]];
    [self.iTextView becomeFirstResponder];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.iTextView.text = self.iText;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //注册通知,监听键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification {
    NSDictionary *info = [paramNotification userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.iTextViewBottom.constant = CGRectGetHeight(keyboardRect);
    }];
}
- (void)handleKeyboardDidHidden {
    [UIView animateWithDuration:0.2 animations:^{
        self.iTextViewBottom.constant = 0;
    }];
}
#pragma mark 按钮方法
- (void)finishItem:(UIBarButtonItem *)item {
    NSString *text = [self.iTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        alertController.message = @"确定清空群公告";
        UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [self postedBack:text];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:clearAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self postedBack:text];
    }
}
- (void)backItem:(UIBarButtonItem *)item {
    NSString *text = [self.iTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (![text isEqualToString:self.iText]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        alertController.message = @"退出本次编辑?";
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"继续编辑" style:UIAlertActionStyleDefault handler:nil];

        [alertController addAction:backAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark 上传 并返回
- (void)postedBack:(NSString *)text {
    YYIMInputViewController *__weak weakSelf = self;
    [[YYIMChat sharedInstance].chatManager setGroupAnnouncementWithGroup:self.iGroupId content:text complete:^(BOOL result, YYChatGroup *groupInfo, YYIMError *error) {
        [weakSelf showHint:@"发布成功"];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%@",textView.text);
    if ([textView.text isEqualToString:self.iText]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
