//
//  IMManager.m
//  CloudHR
//
//  Created by Chenly on 16/8/5.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

//typedef NS_ENUM(NSInteger, IMConnectState) {
//    IMConnectStateDisconnect = 0,
//    IMConnectStateConnected,   // =1
//    IMConnectStateConnecting, // =2
//    IMConnectStateConflict, // =3
//};

#import "IMManager.h"
#import "YYIMChat.h"
#import "YYMessage+Extend.h"
#import "MessageService.h"
#import "YYIMUIDefs.h"
#import <AFNetworking/AFNetworking.h>

typedef void(^connectStateBlock)(NSInteger connectState);
typedef void(^updateRecentBlock)(BOOL isUpdate);

@interface IMManager () <YYIMTokenDelegate, YYIMChatDelegate>

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *etpKey;
@property (nonatomic, copy) NSString *cerName;
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *clientSecret;

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSArray<YYRecentMessage *> *lastRecentMessages;

@property (nonatomic, copy) NSString *seriId;
@property (nonatomic, copy) void (^createGroupCompletion)(NSString *groupId);

@property (nonatomic, readonly) NSOperationQueue *recentMessagesQueue;

@property (nonatomic, strong) NSMutableArray<void(^)(YYMessage *)> *receiveMsgBlocks;
@property (nonatomic, copy) connectStateBlock stateBlock;
@property (nonatomic, copy) updateRecentBlock updateRecentBlock;

@end

@implementation IMManager

@synthesize recentMessagesQueue = _recentMessagesQueue;

//static NSString * const kYYIMTokenKey = @"yyim_token";
//static NSString * const kYYIMExpirationKey = @"yyim_token_expiration";

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static IMManager *sSharedInstance;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[IMManager alloc] init];
    });
    return sSharedInstance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"YYIMConfig" ofType:@"plist"];
        NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:filePath];
        _appKey  = config[@"AppKey"];
        _etpKey  = config[@"EtpKey"];
        _cerName = config[@"CerName"];
        _clientId = config[@"ClientId"];
        _clientSecret = config[@"ClientSecret"];
        
        NSString *token = [[YYIMConfig sharedInstance] getToken];
        NSNumber *expiration = [NSNumber numberWithDouble:[[YYIMConfig sharedInstance] getTokenExpiration]];
        _token = [YYToken tokenWithExpiration:token expiration:expiration.stringValue];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *imServer = [userDefaults stringForKey:@"IM_SERVER_IP"];
        NSString *imShortServer = [userDefaults stringForKey:@"IM_SHORT_SERVER"];
        NSString *uploadServer = [userDefaults stringForKey:@"UPLOAD_FILE_SERVER"];
        NSString *downloadServer = [userDefaults stringForKey:@"DOWNLOAD_FILE_SERVER"];
        NSString *imServerPort = [userDefaults stringForKey:@"IM_SERVER_PORT"];
        NSString *imSSLServer = [userDefaults stringForKey:@"IM_SSL_SERVER_PORT"];
        NSString *imserverEnablSSL = [userDefaults stringForKey:@"IM_SERVER_ENABLESSL"];
        NSString *resetServerHttps = [userDefaults stringForKey:@"IM_RESET_SERVER_HTTPS"];
        
        if (imServer == nil) imServer = config[@"IM_SERVER_IP"];
        if (imShortServer == nil) imShortServer = config[@"IM_SHORT_SERVER"];
        if (uploadServer == nil) uploadServer = config[@"UPLOAD_FILE_SERVER"];
        if (downloadServer == nil) downloadServer = config[@"DOWNLOAD_FILE_SERVER"];
        if (imserverEnablSSL == nil) imserverEnablSSL = config[@"IM_SERVER_ENABLESSL"];
        if (imServerPort == nil) imServerPort = config[@"IM_SERVER_PORT"];
        if (imSSLServer == nil) imSSLServer = config[@"IM_SSL_SERVER_PORT"];
        if (resetServerHttps == nil) resetServerHttps = config[@"IM_RESET_SERVER_HTTPS"];
        
        if (imServer && imServer.length > 0 && ![imServer isEqualToString:@"none"]) {
            [[YYIMConfig sharedInstance] setIMServer:imServer];
        }
        if (imShortServer && imShortServer.length > 0 && ![imShortServer isEqualToString:@"none"]) {
            [[YYIMConfig sharedInstance] setIMRestServer:imShortServer];
        }
        if (uploadServer && uploadServer.length > 0 && ![uploadServer isEqualToString:@"none"]) {
            [[YYIMConfig sharedInstance] setResourceUploadServer:uploadServer];
        }
        if (downloadServer && downloadServer.length > 0 && ![downloadServer isEqualToString:@"none"]) {
            [[YYIMConfig sharedInstance] setResourceDownloadServer:downloadServer];
        }
        if (imserverEnablSSL && imserverEnablSSL.length > 0 && ![imserverEnablSSL isEqualToString:@"none"]) {
            [[YYIMConfig sharedInstance] setIMServerEnableSSL:[imserverEnablSSL boolValue]];
        }
        if (imServerPort && imServerPort.length > 0 && ![imServerPort isEqualToString:@"none"]) {
            [[YYIMConfig sharedInstance] setIMServerPort:[imServerPort integerValue]];
        }
        if (imSSLServer && imSSLServer.length > 0 && ![imSSLServer isEqualToString:@"none"]) {
            [[YYIMConfig sharedInstance] setIMServerSSLPort:[imSSLServer integerValue]];
        }
        if (resetServerHttps && resetServerHttps.length > 0 && ![resetServerHttps isEqualToString:@"none"]) {
            [[YYIMConfig sharedInstance] setIMRestServerHTTPS:[resetServerHttps boolValue]];
        }
        NSString *isRevoke = config[@"IM_REVOKE_MESSAGE"];
        if (isRevoke && isRevoke.length > 0 && ![isRevoke isEqualToString:@"none"]) {
            [[YYIMConfig sharedInstance] setNotRevokeExtend:YES];
        }
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerYYIM];
    return [[YYIMChat sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)registerYYIM {
    // 注册app
    [[YYIMChat sharedInstance] registerApp:self.appKey etpKey:self.etpKey];
    // 注册token代理
    [[YYIMChat sharedInstance].chatManager registerTokenDelegate:self];
    // 添加代理
    [[YYIMChat sharedInstance].chatManager addDelegate:self];
    // 注册推送证书（Name 要和 im.yyuap.com 上设置的一致）
    [[YYIMChat sharedInstance] registerApnsCerName:self.cerName];
    // 设置日志级别
    [[YYIMChat sharedInstance] setLogLevel:YYIM_LOG_FLAG_ERROR];
    // 本地推送
    [[YYIMChat sharedInstance].chatManager setEnableLocalNotification:YES];
}

#pragma mark - public

- (void)loginWithUserid:(NSString *)userid
               nickname:(NSString *)nickname
                  token:(YYToken *)token
             completion:(YYIMLoginCompleteBlock)completion {
    
    if (![self checkUser:userid]) {
        YYIMLogInfo(@"userid 不合法");
        return;
    }
    self.nickname = nickname;
    self.token = token;
    [[YYIMConfig sharedInstance] setToken:token.tokenStr];
    [[YYIMConfig sharedInstance] setTokenExpiration:token.expirationTimeInterval];
    [[YYIMChat sharedInstance].chatManager login:userid completion:completion];
}

- (void)getCompleteRecentMessages:(void(^)(NSArray<YYRecentMessage *> *))block {
    
    NSArray *recentMessages = [[YYIMChat sharedInstance].chatManager getRecentMessage];
    self.lastRecentMessages = recentMessages;
    if (block) {
        block(recentMessages);
    }
}

- (void)createGroupWithName:(NSString *)groupName users:(NSArray *)users completion:(void (^)(NSString *))completion
{
    if (users.count == 0) {
        NSString *userId = [[YYIMConfig sharedInstance] getUser];
        if(userId){
            users = @[userId];
        }
        else{
            completion(nil);
            return;
        }
    }
    
    self.seriId = [[YYIMChat sharedInstance].chatManager createChatGroupWithName:groupName user:users];
    self.createGroupCompletion = completion;
}

- (void)registerObserverForReceiveMessage:(void (^)(YYMessage *))block {
    
    if (self.receiveMsgBlocks == nil) {
        self.receiveMsgBlocks = [NSMutableArray array];
    }
    [self.receiveMsgBlocks addObject:block];
}

- (void)sendReceiveMessageEventForChatId:(NSString *)chatId {
    
    if (self.receiveMsgBlocks.count == 0) {
        return;
    }
    for (YYMessage *message in self.lastRecentMessages) {
        
        NSString *theChatId = nil;
        if ([YM_MESSAGE_TYPE_CHAT isEqualToString:message.chatType]) {
            theChatId = message.rosterId;
        }
        else if ([YM_MESSAGE_TYPE_GROUPCHAT isEqualToString:message.chatType]) {
            theChatId = ([message direction] == YM_MESSAGE_DIRECTION_RECEIVE) ? message.fromId : message.toId;
        }
        if ([theChatId isEqualToString:chatId]) {
            for (void (^block)(YYMessage *) in self.receiveMsgBlocks) {
                block(message);
            }
            break;
        }
    }
}

#pragma mark - private

- (BOOL)checkUser:(NSString *)userid {
    
    NSString *pattern = @"[a-z0-9A-Z_.-]{1,50}";
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray *matches = [expression matchesInString:userid options:0 range:NSMakeRange(0, [userid length])];
    return matches.count > 0;
}

- (NSOperationQueue *)recentMessagesQueue {
    if (_recentMessagesQueue == nil) {
        _recentMessagesQueue = [[NSOperationQueue alloc] init];
        _recentMessagesQueue.maxConcurrentOperationCount = 1;
    }
    return _recentMessagesQueue;
}

// 如果 RecentMessage 发生变化触发 Receive Message 事件
- (void)sendReceiveEventIfRecentMessagesChanged {
    
    if (self.receiveMsgBlocks.count == 0) {
        return;
    }
    [self.recentMessagesQueue addOperationWithBlock:^{
        
        NSArray *changedMessages = nil;
        NSArray *recentMessages = [[YYIMChat sharedInstance].chatManager getRecentMessage];
        if (self.lastRecentMessages.count == 0) {
            changedMessages = recentMessages;
        }
        else {
            NSIndexSet *indexes = [recentMessages indexesOfObjectsPassingTest:^BOOL(YYRecentMessage *message, NSUInteger idx, BOOL *stop) {
                for (YYRecentMessage *theMessage in self.lastRecentMessages) {
//                    if (theMessage.type == message.type &&
//                        [theMessage.pid isEqualToString:message.pid] &&
//                        theMessage.isIntegrated) {
//                        return NO;
//                    }
                }
                return YES;
            }];
            changedMessages = [recentMessages objectsAtIndexes:indexes];
        }
        for (YYRecentMessage *message in changedMessages) {
            for (void (^block)(YYMessage *) in self.receiveMsgBlocks) {
                block(message);
            }
        }
        self.lastRecentMessages = recentMessages;
    }];
}

#pragma mark - <YYIMChatDelegate>

- (void)willConnect{
    YYIMLogInfo(@"YYIM willConnect");
    [self returnConnectStateBlock:[self transformToIMConnectState]];
}
- (void)didConnect {
    YYIMLogInfo(@"YYIM didConnect");
    [self returnConnectStateBlock:[self transformToIMConnectState]];
}

- (void)didAuthenticate {
    YYIMLogInfo(@"YYIM didAuthenticate");
    [self returnConnectStateBlock:[self transformToIMConnectState]];
}

- (void)didConnectFailure:(YYIMError *)error {
    YYIMLogInfo(@"YYIM 连接IM服务器失败:%ld|%@", (long)[error errorCode], [error errorMsg]);
    [self returnConnectStateBlock:[self transformToIMConnectState]];
}

- (void)didAuthenticateFailure:(YYIMError *)error {
    YYIMLogInfo(@"YYIM IM服务器认证失败:%ld|%@", (long)[error errorCode], [error errorMsg]);
    [self returnConnectStateBlock:[self transformToIMConnectState]];
}

- (void)didDisconnect{
    YYIMLogInfo(@"YYIM didDisconnect");
    [self returnConnectStateBlock:[self transformToIMConnectState]];
}

- (void)didLoginConflictOccurred {
    YYIMLogInfo(@"您的帐号在其他客户端登陆");
    [self returnConnectStateBlock:3];
}

- (NSInteger)transformToIMConnectState{
    YYIMConnectState yyimconnectState = [[YYIMChat sharedInstance].chatManager connectState];
    NSInteger connectState;
    //    IMConnectStateDisconnect = 0,
    //    IMConnectStateConnected,   // =1
    //    IMConnectStateConnecting, // =2
    //    IMConnectStateConflict, // =3
    switch (yyimconnectState) {
        case kYYIMConnectStateDisconnect:
            connectState = 0;
            break;
        case kYYIMConnectStateConnected:
            connectState = 1;
            break;
        case kYYIMConnectStateConnecting:
            connectState = 2;
            break;
        default:
            break;
    }
    return connectState;
}

- (void)returnConnectStateBlock:(NSInteger)connectState{
    if(self.stateBlock){
        self.stateBlock(connectState);
    }
}

- (void)setConnectState:(connectStateBlock)block{
    self.stateBlock = block;
}
- (void)setUpdatetRecent:(updateRecentBlock)block {
    self.updateRecentBlock = block;
}
- (void)returnUpdateRecent:(BOOL)isUpdate {
    if(self.updateRecentBlock){
        self.updateRecentBlock(isUpdate);
    }
}

- (YYToken *)getAppToken {
    return self.token;
}



#pragma mark - <YYIMTokenDelegate>

- (void)getAppTokenWithComplete:(void (^)(BOOL, id))complete {
    if (self.token && self.token.tokenStr.length > 0) {
        complete(YES, self.token);
    } else {
        NSString *URLString = [[YYIMConfig sharedInstance] getUserToken];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"clientId"] = self.clientId;
        parameters[@"clientSecret"] = self.clientSecret;
        parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:YYIM_ACCOUNT];
        parameters[@"nickname"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"YYIM_NICKNAME"];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [sessionManager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = (NSDictionary *)responseObject;
            YYToken *token = [YYToken tokenWithExpiration:[dic objectForKey:@"token"] expiration:[dic objectForKey:@"expiration"]];
            YYIMLogInfo(@"中国人getAppTokenWithComplete$succ:%@|%f", [token tokenStr], [token expirationTimeInterval]);
            complete(YES, token);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            YYIMLogError(@"getAppTokenWithComplete$fail:%@|%@", response, [error localizedDescription]);
            
            NSString *message = response.statusCode == 401 ? @"用户名或密码错误" : @"未知错误";
            YYIMError *ymError = [YYIMError errorWithCode:response.statusCode errorMessage:message];
            [ymError setSrcError: error];
            complete(NO, ymError);
            
        }];
    }
}

#pragma mark - <YYIMChatDelegate>

- (void)didSendMessage:(YYMessage *)message {
    [self sendReceiveEventIfRecentMessagesChanged];
}

- (void)didReceiveMessage:(YYMessage *)message {
    [self sendReceiveEventIfRecentMessagesChanged];
    [self updateBadgeNumber];
    [self returnUpdateRecent:YES];
}

- (void)didReceiveOfflineMessages {
    [self sendReceiveEventIfRecentMessagesChanged];
}

- (void)didMessageDelete:(NSDictionary *)info {
    [self sendReceiveEventIfRecentMessagesChanged];
}

- (void)didRevokeMessageWithPid:(NSString *)pid {
    [self sendReceiveEventIfRecentMessagesChanged];
}

- (void)didMessageRevoked:(YYMessage *)message {
    [self sendReceiveEventIfRecentMessagesChanged];
    [self returnUpdateRecent:YES];
}

- (void)didMessageStateChange:(YYMessage *)message {
    [self updateBadgeNumber];
    [self returnUpdateRecent:YES];
}

- (void)didMessageStateChangeWithChatId:(NSString *)chatId {
    [self updateBadgeNumber];
    [self returnUpdateRecent:YES];
}

- (void)updateBadgeNumber {
    NSInteger badgeNumber = [[YYIMChat sharedInstance].chatManager getUnreadMsgCount];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
    });
}

#pragma mark - <YYIMUserDelegate>

- (void)didUserInfoUpdate {
    [self sendReceiveEventIfRecentMessagesChanged];
}

- (void)didUserInfoUpdate:(YYUser *)user {
    [self sendReceiveEventIfRecentMessagesChanged];
}

#pragma mark - <YYIMChatGroupDelegate>

- (void)didChatGroupInfoUpdate {
    [self sendReceiveEventIfRecentMessagesChanged];
}

- (void)didChatGroupMemberUpdate {
    [self sendReceiveEventIfRecentMessagesChanged];
}

- (void)didChatGroupCreateWithSeriId:(NSString *)seriId group:(YYChatGroup *)group {
    
    if ([seriId isEqualToString:self.seriId] && self.createGroupCompletion) {
        self.createGroupCompletion(group.groupId);
        self.createGroupCompletion = nil;
    }
}

- (void)didNotChatGroupCreateWithSeriId:(NSString *)seriId {
    
    if ([seriId isEqualToString:self.seriId] && self.createGroupCompletion) {
        self.createGroupCompletion(nil);
        self.createGroupCompletion = nil;
    }
}

@end
