//
//  IMManager.h
//  CloudHR
//
//  Created by Chenly on 16/8/5.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYIMChatHeader.h"

@class UIApplication;

@interface IMManager : NSObject

@property (nonatomic, strong) YYToken *token;

+ (instancetype)sharedInstance;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)getCompleteRecentMessages:(void(^)(NSArray<YYRecentMessage *> *recentMessages))block;

- (void)loginWithUserid:(NSString *)userid
               nickname:(NSString *)nickname
                  token:(YYToken *)token
             completion:(YYIMLoginCompleteBlock)completion;

- (void)createGroupWithName:(NSString *)groupName
                      users:(NSArray *)users
                 completion:(void (^)(NSString *groupId))completion;

- (void)registerObserverForReceiveMessage:(void (^)(YYMessage *))block;
- (void)sendReceiveMessageEventForChatId:(NSString *)chatId;
- (void)setConnectState:(void (^)(NSInteger connectState))block;
- (void)setUpdatetRecent:(void (^)(BOOL isUpdate))block;

@end
