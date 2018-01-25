//
//  YYIMWallspaceManager.m
//  YonyouIMSdk
//
//  Created by litfb on 15/8/19.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYIMWallspaceManager.h"
#import "YMGCDMulticastDelegate.h"
#import "YYIMWallspaceDelegate.h"
#import "YYWSSpaceManager.h"
#import "YYWSSpaceUserRelationManager.h"
#import "YYWSSpaceUserAuthManager.h"
#import "YYWSPostManager.h"
#import "YYWSReplyManager.h"
#import "YYWSUtilManager.h"
#import "YYWSDynamicManager.h"
#import "YYWSNotifyManager.h"

@interface YYIMWallspaceManager ()

@property (retain, atomic) YMGCDMulticastDelegate<YYIMWallspaceDelegate> *multicastDelegate;

@property (retain, nonatomic) YYWSSpaceManager *spaceManager;
@property (retain, nonatomic) YYWSSpaceUserRelationManager *spaceUserRelationManager;
@property (retain, nonatomic) YYWSPostManager *postManager;
@property (retain, nonatomic) YYWSReplyManager *replyManager;
@property (retain, nonatomic) YYWSUtilManager *utilManager;
@property (retain, nonatomic) YYWSSpaceUserAuthManager *spaceUserAuthManager;
@property (retain, nonatomic) YYWSDynamicManager *dynamicManager;
@property (retain, nonatomic) YYWSNotifyManager *notifyManager;

@end

@implementation YYIMWallspaceManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    if (self = [super init]) {
        // delegate
        YMGCDMulticastDelegate<YYIMWallspaceDelegate> *multicastDelegate = (YMGCDMulticastDelegate<YYIMWallspaceDelegate> *)[[YMGCDMulticastDelegate alloc] init];
        self.multicastDelegate = multicastDelegate;
        
        // spaceManager
        self.spaceManager = [YYWSSpaceManager sharedInstance];
        [self.spaceManager activeWithDelegate:multicastDelegate];
        // spaceUserRelationManager
        self.spaceUserRelationManager = [YYWSSpaceUserRelationManager sharedInstance];
        [self.spaceUserRelationManager activeWithDelegate:multicastDelegate];
        // spaceUserAuthManager
        self.spaceUserAuthManager = [YYWSSpaceUserAuthManager sharedInstance];
        [self.spaceUserAuthManager activeWithDelegate:multicastDelegate];
        // postManager
        self.postManager = [YYWSPostManager sharedInstance];
        [self.postManager activeWithDelegate:multicastDelegate];
        // replyManager
        self.replyManager = [YYWSReplyManager sharedInstance];
        [self.replyManager activeWithDelegate:multicastDelegate];
        // utilManager
        self.utilManager = [YYWSUtilManager sharedInstance];
        [self.utilManager activeWithDelegate:multicastDelegate];
        // dynamicManager
        self.dynamicManager = [YYWSDynamicManager sharedInstance];
        [self.dynamicManager activeWithDelegate:multicastDelegate];
        // notifyManager
        self.notifyManager = [YYWSNotifyManager sharedInstance];
        [self.notifyManager activeWithDelegate:multicastDelegate];
    }
    return self;
}

- (void)addDelegate:(id<YYIMWallspaceDelegate>)delegate {
    [self.multicastDelegate removeDelegate:delegate];
    [self.multicastDelegate addDelegate:delegate delegateQueue:dispatch_get_main_queue()];
}

- (void)removeDelegate:(id<YYIMWallspaceDelegate>)delegate {
    [self.multicastDelegate removeDelegate:delegate];
}

#pragma mark YYWSDynamicManager

- (void)getPostListWithParam:(NSString *)param {
    [self.dynamicManager getPostListWithParam:param];
}

- (void)getPostListByTSWithParam:(NSString *)param {
    [self.dynamicManager getPostListByTSWithParam:param];
}

- (void)getRelateToMeWithParam:(NSString *)param {
    [self.dynamicManager getRelateToMeWithParam:param];
}

- (void)getSingleDynamicWithParam:(NSString *)param {
    [self.dynamicManager getSingleDynamicWithParam:param];
}

- (void)getIfUpdatedWithParam:(NSString *)param {
    [self.dynamicManager getIfUpdatedWithParam:param];
}

#pragma mark YYWSPostManager

- (void)publishPostWithParam:(NSString *)param {
    [self.postManager publishPostWithParam:param];
}

- (void)deletePostWithParam:(NSString *)param {
    [self.postManager deletePostWithParam:param];
}

- (void)updatePostWithParam:(NSString *)param {
    [self.postManager updatePostWithParam:param];
}

#pragma mark YYWSReplyManager

- (void)addTextReplyWithParam:(NSString *)param {
    [self.replyManager addTextReplyWithParam:param];
}

- (void)addPraiseReplyWithParam:(NSString *)param {
    [self.replyManager addPraiseReplyWithParam:param];
}

- (void)cancelPraiseReplyWithParam:(NSString *)param {
    [self.replyManager cancelPraiseReplyWithParam:param];
}

- (void)getTextReplyCountWithParam:(NSString *)param {
    [self.replyManager getTextReplyCountWithParam:param];
}

- (void)getPraiseReplyCountWithParam:(NSString *)param {
    [self.replyManager getPraiseReplyCountWithParam:param];
}

- (void)removeReplyWithParam:(NSString *)param {
    [self.replyManager removeReplyWithParam:param];
}

#pragma mark YYWSSpaceManager

- (void)searchWallSpaceByKeyWithParam:(NSString *)param {
    [self.spaceManager searchWallSpaceByKeyWithParam:param];
}

- (void)getWallSpaceListWithParam:(NSString *)param {
    [self.spaceManager getWallSpaceListWithParam:param];
}

- (void)createWallSpaceWithParam:(NSString *)param {
    [self.spaceManager createWallSpaceWithParam:param];
}

- (void)modifyWallSpaceWithParam:(NSString *)param {
    [self.spaceManager modifyWallSpaceWithParam:param];
}

- (void)deleteWallSpaceWithParam:(NSString *)param {
    [self.spaceManager deleteWallSpaceWithParam:param];
}

#pragma mark YYWSSpaceUserAuthManager

- (void)batchAgreeAppliesWithParam:(NSString *)param {
    [self.spaceUserAuthManager batchAgreeAppliesWithParam:param];
}

- (void)batchDenyAppliesWithParam:(NSString *)param {
    [self.spaceUserAuthManager batchDenyAppliesWithParam:param];
}

- (void)getApplyListBySidWithParam:(NSString *)param {
    [self.spaceUserAuthManager getApplyListBySidWithParam:param];
}

- (void)getApplyListByMangerWithParam:(NSString *)param {
    [self.spaceUserAuthManager getApplyListByMangerWithParam:param];
}

#pragma mark YYWSSpaceUserRelationManager

- (void)getJoinedSpacesWithParam:(NSString *)param {
    [self.spaceUserRelationManager getJoinedSpacesWithParam:param];
}

- (void)joinWallSpaceWithParam:(NSString *)param {
    [self.spaceUserRelationManager joinWallSpaceWithParam:param];
}

- (void)applyInWallSpaceWithParam:(NSString *)param {
    [self.spaceUserRelationManager applyInWallSpaceWithParam:param];
}

- (void)batchPullInSpaceWithParam:(NSString *)param {
    [self.spaceUserRelationManager batchPullInSpaceWithParam:param];
}

- (void)checkApplyStatusWithParam:(NSString *)param {
    [self.spaceUserRelationManager checkApplyStatusWithParam:param];
}

- (void)getSpaceMembersWithParam:(NSString *)param {
    [self.spaceUserRelationManager getSpaceMembersWithParam:param];
}

- (void)quitWallSpaceWithParam:(NSString *)param {
    [self.spaceUserRelationManager quitWallSpaceWithParam:param];
}

#pragma mark YYWSUtilManager

- (void)searchUserWithParam:(NSString *)param {
    [self.utilManager searchUserWithParam:param];
}

#pragma mark YYWSNotifyManager

- (void)getNotifyListWithParam:(NSString *)param {
    [self.notifyManager getNotifyListWithParam:param];
}

@end
