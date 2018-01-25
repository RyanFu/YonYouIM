//
//  WallSpaceViewController.m
//  YonyouIM
//
//  Created by litfb on 15/8/18.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "WallSpaceViewController.h"
#import "YYIMChatHeader.h"
#import "AssetsGroupViewController.h"
#import "WallSpaceUIWebView.h"
#import "YYIMUtility.h"
#import "YYIMWallspaceHeader.h"
#import "YYImageCropperViewController.h"

@interface WallSpaceViewController ()<UIWebViewDelegate, YYIMWallspaceDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, YYIMAssetDelegate, YYImageCropperDelegate>

// webView
@property (weak, nonatomic) UIWebView *webView;

@end

@implementation WallSpaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // delegate
    [[YYIMChat sharedInstance].wallspaceManager addDelegate:self];
    
    // 设置打开页面
    if (!self.page) {
        self.page = @"index";
    }
    // 初始化webView
    [self initWebView];
}

/**
 *  初始化webView
 */
- (void)initWebView {
    WallSpaceUIWebView *webView = [[WallSpaceUIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.delegate = self;
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"wallspace" ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:self.page ofType:@"html" inDirectory:@"assets/page"];
        
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 请求URL
    NSURL *mainDocumentURL = [request mainDocumentURL];
    // scheme
    NSString *scheme = [mainDocumentURL scheme];
    // 判断
    if (![@"wallspace" isEqualToString:scheme]) {
        return YES;
    }
    // 圈子命令
    NSString *cmd = [mainDocumentURL host];
    // 圈子命令参数
    NSString *param = [mainDocumentURL query];
    NSLog(@"receive wallspace cmd:%@ param:%@", cmd, param);
    
    if ([@"pageGoBack" isEqualToString:cmd]) {
        // 回退
        if ([self.webView canGoBack]) {// webView goBack
            [self.webView goBack];
        } else {// dismiss controller
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else if ([cmd isEqualToString:@"getJID"]) {
        // 获取JID
        NSString *jidstr =  [[YYIMConfig sharedInstance] getFullUser];
        NSLog(@"jid:%@", jidstr);
        NSString *str = [NSString stringWithFormat:@"\"%@\"",jidstr];
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.getJIDCallback(%@);", str]];
    } else if ([cmd isEqualToString:@"localPic"]) {
        // 添加相册图片
        AssetsGroupViewController *agvc = [[AssetsGroupViewController alloc] init];
        agvc.delegate = self;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:agvc];
        [self presentViewController:navi animated:YES completion:nil];
    } else if ([cmd isEqualToString:@"takePhoto"]) {
        // 添加拍照图片
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else if ([cmd isEqualToString:@"selectFavicon"]) {
        // 选择相册图片
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setDelegate:self];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        imagePicker.mediaTypes = mediaTypes;
        
        [imagePicker setAllowsEditing:NO];
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else if ([cmd isEqualToString:@"getPostList"]) {
        // 取得动态列表(根据页码查询)
        [[YYIMChat sharedInstance].wallspaceManager getPostListWithParam:param];
    } else if([cmd isEqualToString:@"createWallSpace"]) {
        // 创建圈子
        [[YYIMChat sharedInstance].wallspaceManager createWallSpaceWithParam:param];
    } else if ([cmd isEqualToString:@"getWallSpaceList"]) {
        // 获取所有圈子列表
        [[YYIMChat sharedInstance].wallspaceManager getWallSpaceListWithParam:param];
    } else if ([cmd isEqualToString:@"searchWallSpaceByKey"]) {
        // 搜索圈子
        [[YYIMChat sharedInstance].wallspaceManager searchWallSpaceByKeyWithParam:param];
    } else if ([cmd isEqualToString:@"joinWallSpace"]) {
        // 加入圈子
        [[YYIMChat sharedInstance].wallspaceManager joinWallSpaceWithParam:param];
    } else if ([cmd isEqualToString:@"getJoinedSpaces"]) {
        // 获取已经加入的圈子列表
        [[YYIMChat sharedInstance].wallspaceManager getJoinedSpacesWithParam:param];
    } else if ([cmd isEqualToString:@"quitWallSpace"]) {
        // 退出圈子
        [[YYIMChat sharedInstance].wallspaceManager quitWallSpaceWithParam:param];
    } else if ([cmd isEqualToString:@"addTextReply"]) {
        // 添加回复
        [[YYIMChat sharedInstance].wallspaceManager addTextReplyWithParam:param];
    } else if ([cmd isEqualToString:@"getTextReplyCount"]) {
        // 获取回复数
        [[YYIMChat sharedInstance].wallspaceManager getTextReplyCountWithParam:param];
    } else if ([cmd isEqualToString:@"addPraiseReply"]) {
        // 点赞
        [[YYIMChat sharedInstance].wallspaceManager addPraiseReplyWithParam:param];
    } else if ([cmd isEqualToString:@"publishPost"]) {
        // 发布圈子消息
        [[YYIMChat sharedInstance].wallspaceManager publishPostWithParam:param];
    } else if ([cmd isEqualToString:@"deleteWallSpace"]) {
        // 删除圈子
        [[YYIMChat sharedInstance].wallspaceManager deleteWallSpaceWithParam:param];
    } else if ([cmd isEqualToString:@"cancelPraiseReply"]) {
        // 取消点赞
        [[YYIMChat sharedInstance].wallspaceManager cancelPraiseReplyWithParam:param];
    } else if([cmd isEqualToString:@"modifyWallSpace"]) {
        // 修改圈子
        [[YYIMChat sharedInstance].wallspaceManager modifyWallSpaceWithParam:param];
    } else if([cmd isEqualToString:@"applyInWallSpace"]) {
        // 申请加入封闭圈子
        [[YYIMChat sharedInstance].wallspaceManager applyInWallSpaceWithParam:param];
    } else if([cmd isEqualToString:@"searchUser"]) {
        // 搜索用户
        [[YYIMChat sharedInstance].wallspaceManager searchUserWithParam:param];
    } else if([cmd isEqualToString:@"batchPullInSpace"]) {
        // 批量加入用户
        [[YYIMChat sharedInstance].wallspaceManager batchPullInSpaceWithParam:param];
    } else if ([cmd isEqualToString:@"getSpaceMembers"]) {
        // 圈子用户列表
        [[YYIMChat sharedInstance].wallspaceManager getSpaceMembersWithParam:param];
    } else if ([cmd isEqualToString:@"getNotifyList"]) {
        // 获取通知列表
        [[YYIMChat sharedInstance].wallspaceManager getNotifyListWithParam:param];
    } else if ([cmd isEqualToString:@"getSingleDynamic"]) {
        // 根据通知消息获取一条动态
        [[YYIMChat sharedInstance].wallspaceManager getSingleDynamicWithParam:param];
    } else if ([cmd isEqualToString:@"batchAgreeApplies"]) {
        // 批量同意加入圈子申请
        [[YYIMChat sharedInstance].wallspaceManager batchAgreeAppliesWithParam:param];
    } else if ([cmd isEqualToString:@"batchDenyApplies"]) {
        // 批量拒绝加入圈子申请
        [[YYIMChat sharedInstance].wallspaceManager batchDenyAppliesWithParam:param];
    } else if ([cmd isEqualToString:@"checkApplyStatus"]) {
        // 检查申请审批状态
        [[YYIMChat sharedInstance].wallspaceManager checkApplyStatusWithParam:param];
    }
    return NO;
}

#pragma mark YYIMAssetDelegate

- (void)didSelectAssets:(NSArray *)assets isOriginal:(BOOL)isOriginal {
    // asset array
    NSArray *assetArray = [NSArray arrayWithArray:assets];
    // 图片路径array
    NSMutableArray *imagePathArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < assetArray.count; i++) {
        // asset
        ALAsset *asset = [assetArray objectAtIndex:i];
        // 取fullScreenImage
        CGImageRef imageRef = [[asset defaultRepresentation] fullScreenImage];
        // 缩略图
        UIImage *thumbImage = [YYIMResourceUtility thumbImage:[UIImage imageWithCGImage:imageRef] maxSide:1280.0f];
        // 保存image到Document
        NSString *imagePath = [YYIMResourceUtility saveImage:thumbImage];
        NSString *fullimagePath = [YYIMResourceUtility fullPathWithResourceRelaPath:imagePath];
        [imagePathArray addObject:fullimagePath];
    }
    // 转json
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:imagePathArray options:0 error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    // 回调JS方法
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.fileChooseCallback(%@);", jsonString]];
}

#pragma mark UIImagePickerControllerDelegate

// UIImagePicker回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // dismiss UIImagePickerController
    
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
        // 相机，来源于发图片
        [self dismissViewControllerAnimated:YES completion:^{
            // image
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            // 缩图
            UIImage *thumbImage = [YYIMResourceUtility thumbImage:image maxSide:1280.0f];
            // 保存image到Document
            NSString *imagePath = [YYIMResourceUtility saveImage:thumbImage];
            NSString *fullimagePath = [YYIMResourceUtility fullPathWithResourceRelaPath:imagePath];
            // 图片路径array
            NSMutableArray *imagePathArray = [NSMutableArray arrayWithObject:fullimagePath];
            // 转json
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:imagePathArray options:0 error:nil];
            NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            // 回调JS方法
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.fileChooseCallback(%@);", jsonString]];
        }];
    } else if ([picker sourceType] == UIImagePickerControllerSourceTypePhotoLibrary) {
        // 相册，来源于传头像
        [self dismissViewControllerAnimated:YES completion:^{
            // 得到图片
            UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            originalImage = [YYIMResourceUtility thumbImage:originalImage maxSide:640.0f];
            // 裁剪
            YYImageCropperViewController *cropperViewController = [[YYImageCropperViewController alloc] initWithImage:originalImage];
            cropperViewController.delegate = self;
            [self presentViewController:cropperViewController animated:YES completion:nil];
        }];
    }
}

// UIImagePicker取消回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark YYImageCropperDelegate

- (void)imageCropper:(YYImageCropperViewController *)cropperViewController didFinished:(UIImage *)croppedImage {
    [self dismissViewControllerAnimated:NO completion:nil];
    NSString *imagePath = [YYIMResourceUtility saveImage:croppedImage];
    NSString *fullimagePath = [YYIMResourceUtility fullPathWithResourceRelaPath:imagePath];
    // 回调JS方法
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.selectFaviconCallback(\"%@\");", fullimagePath]];
}

- (void)imageCropperDidCancel:(YYImageCropperViewController *)cropperViewController {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError");
}

#pragma mark YYIMWallspaceDelegate

// 取得动态列表(根据页码查询)成功
- (void)didGetPostList:(NSString *)result {
    NSLog(@"didGetPostList");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.postRefreshCallback(%@);", result]];
}

// 取得动态列表(根据页码查询)失败
- (void)didNotGetPostListWithError:(NSError *)error {
    NSLog(@"didNotGetPostListWithError:%@", [error localizedDescription]);
}

// 创建圈子成功
- (void)didCreateWallSpace:(NSString *)result {
    NSLog(@"didCreateWallSpace");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.createSpaceCallback(%@);", result]];
}

// 创建圈子失败
- (void)didNotCreateWallSpaceWithError:(NSError *)error {
    NSLog(@"didNotCreateWallSpaceWithError:%@", [error localizedDescription]);
}

// 获取全部圈子列表成功
- (void)didGetWallSpaceList:(NSString *)result {
    NSLog(@"didGetWallSpaceList");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.listSpacesCallback(%@);", result]];
}

// 获取全部圈子列表失败
- (void)didNotGetWallSpaceListWithError:(NSError *)error {
    NSLog(@"didNotGetWallSpaceListWithError:%@", [error localizedDescription]);
}

// 搜索圈子成功
- (void)didSearchWallSpaceByKey:(NSString *)result {
    NSLog(@"didSearchWallSpaceByKey");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.spaceSearchCallback(%@);", result]];
}

// 搜索圈子失败
- (void)didNotSearchWallSpaceByKeyWithError:(NSError *)error {
    NSLog(@"didNotSearchWallSpaceByKeyWithError:%@", [error localizedDescription]);
}

// 加入圈子成功
- (void)didJoinWallSpace:(NSString *)result {
    NSLog(@"didJoinWallSpace");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.joinSpaceCallback(%@);", result]];
}

// 加入圈子失败
- (void)didNotJoinWallSpaceWithError:(NSError *)error {
    NSLog(@"didNotJoinWallSpaceWithError:%@", [error localizedDescription]);
}

// 获取已经加入的圈子成功
- (void)didGetJoinedSpaces:(NSString *)result {
    NSLog(@"didGetJoinedSpaces");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.mySpacesCallback(%@);", result]];
}

// 获取已经加入的圈子失败
- (void)didNotGetJoinedSpacesWithError:(NSError *)error {
    NSLog(@"didNotGetJoinedSpacesWithError:%@", [error localizedDescription]);
}

// 退出圈子成功
- (void)didQuitWallSpace:(NSString *)result {
    NSLog(@"didQuitWallSpace");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.quitSpaceCallback(%@);", result]];
}

// 退出圈子失败
- (void)didNotQuitWallSpaceWithError:(NSError *)error {
    NSLog(@"didNotQuitWallSpaceWithError:%@", [error localizedDescription]);
}

// 回复成功
- (void)didAddTextReply:(NSString *)result {
    NSLog(@"didAddTextReply");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.replyCallback(%@);", result]];
}

// 回复失败
- (void)didNotAddTextReplyWithError:(NSError *)error {
    NSLog(@"didNotAddTextReplyWithError:%@", [error localizedDescription]);
}

// 获取回复数成功
- (void)didGetTextReplyCount:(NSString *)result {
    NSLog(@"didGetTextReplyCount");
}

// 获取回复数失败
- (void)didNotGetTextReplyCountWithError:(NSError *)error {
    NSLog(@"didNotGetTextReplyCountWithError:%@", [error localizedDescription]);
}

// 点赞成功
- (void)didAddPraiseReply:(NSString *)result {
    NSLog(@"didAddPraiseReply");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.praiseCallback(%@);", result]];
}

// 点赞失败
- (void)didNotAddPraiseReplyWithError:(NSError *)error {
    NSLog(@"didNotAddPraiseReplyWithError:%@", [error localizedDescription]);
}

// 发动态成功
- (void)didPublishPost:(NSString *)result {
    NSLog(@"didPublishPost");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.publishPostCallback(%@);", result]];
}

// 发动态失败
- (void)didNotPublishPostWithError:(NSError *)error {
    NSLog(@"didNotPublishPostWithError:%@", [error localizedDescription]);
}

// 删除圈子成功
- (void)didDeleteWallSpace:(NSString *)result {
    NSLog(@"didDeleteWallSpace");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.deleteSpaceCallback(%@);", result]];
}

// 删除圈子失败
- (void)didNotDeleteWallSpaceWithError:(NSError *)error {
    NSLog(@"didNotDeleteWallSpaceWithError:%@", [error localizedDescription]);
}

// 取消点赞成功
- (void)didCancelPraiseReply:(NSString *)result {
    NSLog(@"didCancelPraiseReply");
}

// 获取点赞数量成功
- (void)didGetPraiseReplyCount:(NSString *)result {
    NSLog(@"didGetPraiseReplyCount");
}

// 获取点赞数量失败
- (void)didNotGetPraiseReplyCountWithError:(NSError *)error {
    NSLog(@"didNotGetPraiseReplyCountWithError:%@", [error localizedDescription]);
}

// 取消点赞失败
- (void)didNotCancelPraiseReplyWithError:(NSError *)error {
    NSLog(@"didNotCancelPraiseReplyWithError:%@", [error localizedDescription]);
}

// 修改圈子成功
- (void)didModifyWallSpace:(NSString *)result {
    NSLog(@"didModifyWallSpace");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.modifyWallSpaceCallback(%@);", result]];
}

// 修改圈子失败
- (void)didNotModifyWallSpaceWithError:(NSError *)error {
    NSLog(@"didNotModifyWallSpaceWithError:%@", [error localizedDescription]);
}

// 申请加入封闭圈子成功
- (void)didApplyInWallSpace:(NSString *)result {
    NSLog(@"didApplyInWallSpace");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.applyInSpaceCallback(%@);", result]];
}

// 申请加入封闭圈子失败
- (void)didNotApplyInWallSpaceWithError:(NSError *)error {
    NSLog(@"didNotApplyInWallSpaceWithError:%@", [error localizedDescription]);
}

// 批量将用户加入圈子成功
- (void)didBatchPullInSpace:(NSString *)result {
    NSLog(@"didBatchPullInSpace");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.batchPullInSpaceCallback(%@);", result]];
}

// 批量将用户加入圈子失败
- (void)didNotBatchPullInSpaceWithError:(NSError *)error {
    NSLog(@"didNotBatchPullInSpaceWithError:%@", [error localizedDescription]);
}

// 搜索用户成功
- (void)didSearchUser:(NSString *)result {
    NSLog(@"didSearchUser");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.searchUserCallback(%@);", result]];
}

// 搜索用户失败
- (void)didNotSearchUserWithError:(NSError *)error {
    NSLog(@"didNotSearchUserWithError:%@", [error localizedDescription]);
}

// 获取圈子用户列表成功
- (void)didGetSpaceMembers:(NSString *)result {
    NSLog(@"didGetSpaceMembers");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.getSpaceMembersCallback(%@);", result]];
}

// 获取圈子用户列表失败
- (void)didNotGetSpaceMembersWithError:(NSError *)error {
    NSLog(@"didNotGetSpaceMembersWithError:%@", [error localizedDescription]);
}

// 获取通知列表成功
- (void)didGetNotifyList:(NSString *)result {
    NSLog(@"didGetNotifyList");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.getNotifyListCallback(%@);", result]];
}

// 获取通知列表失败
- (void)didNotGetNotifyListWithError:(NSError *)error {
    NSLog(@"didNotGetNotifyListWithError:%@", [error localizedDescription]);
}

// 根据通知消息获取一条动态成功
- (void)didGetSingleDynamic:(NSString *)result {
    NSLog(@"didGetSingleDynamic");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.getSingleDynamicCallback(%@);", result]];
}

// 根据通知消息获取一条动态失败
- (void)didNotGetSingleDynamicWithError:(NSError *)error {
    NSLog(@"didNotGetSingleDynamicWithError:%@", [error localizedDescription]);
}

// 批量同意加入圈子申请成功
- (void)didBatchAgreeApplies:(NSString *)result {
    NSLog(@"didBatchAgreeApplies");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.batchAgreeAppliesCallback(%@);", result]];
}

// 批量同意加入圈子申请失败
- (void)didNotBatchAgreeAppliesWithError:(NSError *)error {
    NSLog(@"didNotBatchAgreeAppliesWithError:%@", [error localizedDescription]);
}

// 批量拒绝加入圈子申请成功
- (void)didBatchDenyApplies:(NSString *)result {
    NSLog(@"didBatchDenyApplies");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.batchDenyAppliesCallback(%@);", result]];
}

// 批量拒绝加入圈子申请失败
- (void)didNotBatchDenyAppliesWithError:(NSError *)error {
    NSLog(@"didNotBatchDenyAppliesWithError:%@", [error localizedDescription]);
}

// 检查申请审批状态成功
- (void)didCheckApplyStatus:(NSString *)result {
    NSLog(@"didCheckApplyStatus");
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.JSFN.checkApplyStatusCallback(%@);", result]];
}

// 检查申请审批状态失败
- (void)didNotCheckApplyStatusWithError:(NSError *)error {
    NSLog(@"didNotCheckApplyStatusWithError:%@", [error localizedDescription]);
}

@end
