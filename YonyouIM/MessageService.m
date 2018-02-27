//
//  MessageService.m
//  CloudHR
//
//  Created by Chenly on 16/7/19.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

#import "MessageService.h"
#import "IMManager.h"
#import "ChatViewController.h"
//#import "ChatGroupViewController.h"
//#import "ChatGroupReformer.h"
//#import "FaceToFaceViewController.h"

// YYIM
#import "YYIMChatHeader.h"
#import "YYMessage+Extend.h"
#import "YYIMUIDefs.h"
#import "YYSearchMessage.h"



//#import <YYModel/YYModel.h>
//#import <Aspects/Aspects.h>

static NSString * const _Version = @"3";
NSString * const IMMessagesShouldReloadNotification = @"IMMessagesShouldReload";

@interface MessageService () <YYIMChatDelegate, YYIMUserDelegate>

@property (nonatomic, strong) NSMutableArray *loadingUsers;
@property (nonatomic, copy) void (^fetchMessagesCompletion)(void);

@end

@implementation MessageService

+ (void)load {
//    [[IUMMediator sharedInstance] registerExtension:@"YYIM" forClass:NSStringFromClass(self)];
}

+ (NSString *)pluginVersion{
    return _Version;
}

- (void)getPluginVersion:(id)args{
    //回调要修改：
//    [args evaluateJavaScriptCallbackWithObject:@{@"result":_Version}];
}
    
- (void)setConfig:(id)args {
    if (!args[@"params"]) {
        return;
    }
    NSString *imServer         = args[@"params"][@"IM_SERVER_IP"];
    NSString *imShortServer    = args[@"params"][@"IM_SHORT_SERVER"];
    NSString *uploadServer     = args[@"params"][@"UPLOAD_FILE_SERVER"];
    NSString *downloadServer   = args[@"params"][@"DOWNLOAD_FILE_SERVER"];
    NSString *imServerPort     = args[@"params"][@"IM_SERVER_PORT"];
    NSString *imSSLServer      = args[@"params"][@"IM_SSL_SERVER_PORT"];
    NSString *imserverEnablSSL = args[@"params"][@"IM_SERVER_ENABLESSL"];
    NSString *resetServerHttps = args[@"params"][@"IM_RESET_SERVER_HTTPS"];

    [[NSUserDefaults standardUserDefaults] setObject:imServer forKey:@"IM_SERVER_IP"];
    [[NSUserDefaults standardUserDefaults] setObject:imShortServer forKey:@"IM_SHORT_SERVER"];
    [[NSUserDefaults standardUserDefaults] setObject:uploadServer forKey:@"UPLOAD_FILE_SERVER"];
    [[NSUserDefaults standardUserDefaults] setObject:downloadServer forKey:@"DOWNLOAD_FILE_SERVER"];
    [[NSUserDefaults standardUserDefaults] setObject:imServerPort forKey:@"IM_SERVER_PORT"];
    [[NSUserDefaults standardUserDefaults] setObject:imSSLServer forKey:@"IM_SSL_SERVER_PORT"];
    [[NSUserDefaults standardUserDefaults] setObject:imserverEnablSSL forKey:@"IM_SERVER_ENABLESSL"];
    [[NSUserDefaults standardUserDefaults] setObject:resetServerHttps forKey:@"IM_RESET_SERVER_HTTPS"];
    
    if ([imServer isKindOfClass:[NSString class]] && imServer.length > 0) {
        [[YYIMConfig sharedInstance] setIMServer:imServer];
    }
    if ([imShortServer isKindOfClass:[NSString class]] && imShortServer.length > 0) {
        [[YYIMConfig sharedInstance] setIMRestServer:imShortServer];
    }
    if ([uploadServer isKindOfClass:[NSString class]] && uploadServer.length > 0) {
        [[YYIMConfig sharedInstance] setResourceUploadServer:uploadServer];
    }
    if ([downloadServer isKindOfClass:[NSString class]] && downloadServer.length > 0) {
        [[YYIMConfig sharedInstance] setResourceDownloadServer:downloadServer];
    }
    if ([imserverEnablSSL isKindOfClass:[NSString class]] && imserverEnablSSL.length > 0) {
        [[YYIMConfig sharedInstance] setIMServerEnableSSL:[imserverEnablSSL boolValue]];
    }
    if ([imServerPort isKindOfClass:[NSString class]] && imServerPort.length > 0) {
        [[YYIMConfig sharedInstance] setIMServerPort:[imServerPort integerValue]];
    }
    if ([imSSLServer isKindOfClass:[NSString class]] && imSSLServer.length > 0) {
        [[YYIMConfig sharedInstance] setIMServerSSLPort:[imSSLServer integerValue]];
    }
    if ([resetServerHttps isKindOfClass:[NSString class]] && resetServerHttps.length > 0) {
        [[YYIMConfig sharedInstance] setIMRestServerHTTPS:[resetServerHttps boolValue]];
    }
}

- (void)login:(id)args {
    if (!args[@"params"]) {
        return;
    }
    NSDictionary *userinfo = args[@"params"][@"userinfo"];
    NSString *usercode   = userinfo[@"usercode"];
    NSString *userName   = userinfo[@"userName"];
    NSString *token      = userinfo[@"token"];
    NSString *expiration = userinfo[@"expir"];
    
    if (![[YYIMChat sharedInstance].chatManager isConnected]) {
        
        YYIMLoginCompleteBlock completion = ^(BOOL result, NSDictionary *userInfo, YYIMError *loginError) {
            
            id resultValue = nil;
            if (!result) {
                NSString *message;
                if ([[loginError errorMsg] isEqualToString:@"app not found"]) {
                    message = @"登录的应用不存在";
                } else {
                    message = [loginError errorMsg];
                }
                if (!message) {
                    message = @"连接IM服务器失败";
                }
                resultValue = @{ @"success": @NO, @"errorMsg": message };
            }
            else {
                resultValue = @{ @"success": @YES };
            }
            //这里回调给h5,要修改:
//            id returnValue = [SUMJSSerialization jsObjectForCallServiceWithResult:resultValue];
//            [args evaluateJavaScriptCallbackWithObject:returnValue];
        };
        if (token && token.length > 0) {
            YYToken *yyToken = [YYToken tokenWithExpiration:token expiration:expiration];
            [[IMManager sharedInstance] loginWithUserid:usercode nickname:userName token:yyToken completion:completion];
        } else {
            // 登录
            [[IMManager sharedInstance] setToken:nil];
            [self loginIM:usercode password:@"" name:userName args:args];
        }
    }
    else {
        if (token && token.length > 0) {
            [[YYIMConfig sharedInstance] setToken:token];
        }
        if (expiration && expiration.length > 0) {
            [[YYIMConfig sharedInstance] setTokenExpiration:[expiration doubleValue] / 1000];
        }
        //这里回调给h5,要修改:
//        id returnValue = [SUMJSSerialization jsObjectForCallServiceWithResult:@{ @"success": @YES }];
//        [args evaluateJavaScriptCallbackWithObject:returnValue];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    });
}

- (void)logout:(id<SUMExtension>)args {
    
 [[YYIMChat sharedInstance].chatManager logoff];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application = [UIApplication sharedApplication];
        [application setApplicationIconBadgeNumber:0];
    });
}

- (void)updateUserInfo:(id)args {
    
    NSString *userName = args[@"params"][@"userName"];
    NSString *userPhoto = args[@"params"][@"userPhoto"];
    
    YYUser *user = [[YYIMChat sharedInstance].chatManager getUserWithId:[[YYIMConfig sharedInstance] getUser]];
    if (userName) {
        user.userName = userName;
    }
    if (userPhoto) {
        user.userPhoto = userPhoto;
    }
    [[YYIMChat sharedInstance].chatManager updateUser:user];
}

- (void)fetchMessages:(id<SUMExtension>)args {
    
    if (self.fetchMessagesCompletion) {
        return;
    }
    
    [[IMManager sharedInstance] getCompleteRecentMessages:^(NSArray<YYRecentMessage *> *recentMessages) {
        
        NSMutableArray *messages = [NSMutableArray array];
        for (YYRecentMessage *yyMessage in recentMessages) {
            
            NSDictionary *message = [yyMessage messageForJavascript];
            if (message[@"account"] == nil && message[@"chat"] == nil) {
                // 如果用户名为空，则不返回给前端
                continue;
            }
            [messages addObject:message];
        }
        //要修改，回调：
//        id returnValue = [SUMJSSerialization jsObjectForCallServiceWithResult:messages];
//        [args evaluateJavaScriptCallbackWithObject:returnValue];
    }];
}

- (void)fetchAccountMessages:(id)args {
    if (!args[@"params"]) {
        return;
    }
    NSString *pubAccountId = args[@"params"][@"accountID"];
    NSArray *yyMessages = [[YYIMChat sharedInstance].chatManager getMessageWithId:pubAccountId];;
    NSMutableArray *messages = [NSMutableArray array];
    for (YYMessage *yyMessage in yyMessages) {
        NSMutableDictionary *json = ({
            NSData *data = [yyMessage.message dataUsingEncoding:NSUTF8StringEncoding];
            id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            jsonObj;
        });
        json[@"date"] = @(yyMessage.date).stringValue;
        [messages addObject:json];
    }
    id result = [messages reverseObjectEnumerator].allObjects;
    //要回调，要修改：
//    id returnValue = [SUMJSSerialization jsObjectForCallServiceWithResult:result];
//    [args evaluateJavaScriptCallbackWithObject:returnValue];
}

- (void)chat:(id)args {
    if (!args[@"params"]) {
        return;
    }
    NSString *chatID = args[@"params"][@"chatID"];
    NSString *type   = args[@"params"][@"type"] ?: YM_MESSAGE_TYPE_CHAT;
    NSString *extend = args[@"params"][@"extend"];
    NSString *inputMessage = args[@"params"][@"inputMessage"];
    NSArray *sendMessage   = args[@"params"][@"sendMessage"];
    
    if (chatID == nil || ![chatID isKindOfClass:[NSString class]]) {
        return;
    }
    
    [[YYIMChat sharedInstance].chatManager loadUser:chatID];
    
    if ([type isEqualToString:YM_MESSAGE_TYPE_CHAT]) {
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[@"id"] = @"chat";
        params[@"type"] = @"chat";
        params[@"extendValue"] = extend;
        params[@"inputMessage"] = inputMessage;
        params[@"sendMessage"] = sendMessage;
        params[@"chatId"] = chatID;
        params[@"chatType"] = YM_MESSAGE_TYPE_CHAT;
        //跳转聊天：
//        [[IUMMediator sharedInstance] Summer_pushViewControllerWithParams:params];
    }
//    else if ([type isEqualToString:YM_MESSAGE_TYPE_GROUPCHAT]) {
//
//        id closeToWin = args[@"params"][@"backToWin"] ?: [NSNull null];
//        NSMutableDictionary *params = [NSMutableDictionary new];
//        params[@"id"] = @"chatGroup";
//        params[@"type"] = @"chatGroup";
//        params[@"extendValue"] = extend;
//        params[@"inputMessage"] = inputMessage;
//        params[@"sendMessage"] = sendMessage;
//        params[@"groupId"] = chatID;
//        params[@"backToWin"] = closeToWin;
//        [[IUMMediator sharedInstance] Summer_pushViewControllerWithParams:params];
//    }
}

- (void)registerMessageObserver:(id)args {
    
    NSString *function = args[@"params"][@"callback"];
    [[IMManager sharedInstance] registerObserverForReceiveMessage:^(YYMessage *yyMessage) {
//        if (vc == nil || !yyMessage.isIntegrated) {
//            return;
//        }
        NSMutableDictionary *message = [[yyMessage messageForJavascript] mutableCopy];
        BOOL isNew = (yyMessage.status == YM_MESSAGE_STATE_NEW);
        message[@"newCount"] = @(isNew ? 1 : 0);
        message[@"action"] = @"addMessage";
        //回调：要改
//        id returnValue = [SUMJSSerialization jsObjectForCallServiceWithResult:message];
//        [[SUMJavaScriptBridge sharedInstance] evaluateJavaScriptWithFunction:function object:returnValue inWebView:vc.webView];
    }];
    [[IMManager sharedInstance] setConnectState:^(NSInteger connectState) {
        id result = @{
                      @"action": @"checkConnect",
                      @"connect": @(connectState)
                      };
        //回调：要改
//        id returnValue = [SUMJSSerialization jsObjectForCallServiceWithResult:result];
//        [[SUMJavaScriptBridge sharedInstance] evaluateJavaScriptWithFunction:function object:returnValue inWebView:vc.webView];
    }];
    [[IMManager sharedInstance] setUpdatetRecent:^(BOOL isUpdate) {
        id result = @{ @"action": @"updateRecent" };
        //回调：要改
//        id returnValue = [SUMJSSerialization jsObjectForCallServiceWithResult:result];
//        [[SUMJavaScriptBridge sharedInstance] evaluateJavaScriptWithFunction:function object:returnValue inWebView:vc.webView];
    }];
//    // 注册 Summer 事件
//    [[IUMMediator sharedInstance] Summer_addListener:vc forEvent:SummerChatNewMessageEvent handler:function];
//    [[IUMMediator sharedInstance] Summer_addListener:vc forEvent:SummerChatDismissGroupEvent handler:function];
}

- (void)updateMessageReaded:(id)args {
    
    NSString *accountID = args[@"params"][@"accountID"];
    [[YYIMChat sharedInstance].chatManager updateMessageReadedWithId:accountID];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    });
}

- (void)deleteMessage:(id)args {
    
    NSString *pid = args[@"params"][@"id"];
    [[YYIMChat sharedInstance].chatManager deleteMessageWithPid:pid];
    //回调：
//    [args evaluateJavaScriptCallbackWithObject:@""];
}

- (void)deleteChat:(id)args {
    
    NSString *chatId = args[@"params"][@"id"];
    [[YYIMChat sharedInstance].chatManager deleteMessageWithId:chatId];
    //回调：
//    [args evaluateJavaScriptCallbackWithObject:@""];
}

// 置顶
- (void)setStickTop:(id)args {
    
    BOOL stickTop = [args[@"params"][@"isTop"] boolValue];
    NSString *chatId = args[@"params"][@"chatID"];
    if (chatId.length > 0) {
        [[YYIMChat sharedInstance].chatManager updateUserStickTop:stickTop userId:chatId];
        [[YYIMChat sharedInstance].chatManager updateGroupStickTop:stickTop groupId:chatId];
        return;
    }
    
    NSString *accountID = args[@"params"][@"accountID"];
    if (accountID.length > 0) {
        [[YYIMChat sharedInstance].chatManager updatePubAccountStickTop:stickTop accountId:accountID];
        return;
    }
}

// 免打扰
- (void)setNoDisturb:(id)args {
    
    BOOL noDisturb = [args[@"params"][@"noDisturb"] boolValue];
    NSString *chatId = args[@"params"][@"chatID"];
    if (chatId.length > 0) {
        [[YYIMChat sharedInstance].chatManager updateUserNoDisturb:noDisturb userId:chatId];
        [[YYIMChat sharedInstance].chatManager updateGroupNoDisturb:noDisturb groupId:chatId];
        return;
    }
    
    NSString *accountID = args[@"params"][@"accountID"];
    if (accountID.length > 0) {
        [[YYIMChat sharedInstance].chatManager updatePubAccountNoDisturb:noDisturb accountId:accountID];
        return;
    }
}

// 获取消息设置
- (id)getSettings:(id)args {
    
    YYSettings *settings = [[YYIMChat sharedInstance].chatManager getSettings];
    if (!settings) {
        return nil;
    }
    
    NSMutableDictionary *object = [NSMutableDictionary dictionary];
    object[@"newMsgRemind"] = @(settings.newMsgRemind);
    object[@"playSound"] = @(settings.playSound);
    object[@"playVibrate"] = @(settings.playVibrate);
    
    return object;
}

// 修改消息设置
- (void)updateSettings:(id)args {
    if (!args[@"params"]) {
        return;
    }
    NSString *newMsgRemind = args[@"params"][@"newMsgRemind"];
    NSString *playSound = args[@"params"][@"playSound"];
    NSString *playVibrate = args[@"params"][@"playVibrate"];
    
    YYSettings *settings = [[YYIMChat sharedInstance].chatManager getSettings];
    if (newMsgRemind) {
        settings.newMsgRemind = [newMsgRemind boolValue];
    }
    if (playSound) {
        settings.playSound = [playSound boolValue];
    }
    if (playVibrate) {
        settings.playVibrate = [playVibrate boolValue];
    }
    [[YYIMChat sharedInstance].chatManager updateSettings:settings];
}

// 打开面对面建群界面
- (void)openFaceToFace:(id<SUMExtension>)args {

}

- (void)createGroup:(id<SUMExtension>)args {

}

- (void)deleteGroup:(id<SUMExtension>)args {
   
}

- (void)joinGroup:(id<SUMExtension>)args {

}

- (void)getChatGroups:(id<SUMExtension>)args {
    
}

- (void)getChatGroupMember:(id<SUMExtension>)args {
   
}

- (void)groupAddMember:(id<SUMExtension>)args {
 
}

- (void)groupKickMember:(id<SUMExtension>)args {
 
}

// 转发
- (void)forwardMessage:(id)args{
    
    NSDictionary *data = args[@"params"][@"data"];
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *chatId = data[@"chatId"] ;
    NSString *chatType = data[@"chatType"];
    NSString *pid = data[@"pid"];
    [[YYIMChat sharedInstance].chatManager forwardMessage:chatId pid:pid chatType:chatType];
    
}
- (void)getRecentContacters:(id<SUMExtension>)args {
   
}

- (void)setSilenceMode:(id)args {
    NSDictionary *data = args[@"params"][@"data"];
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString * slience = data[@"isSilence"];
    BOOL isSlience = NO;
    if ([slience isEqualToString:@"true"]) {
        isSlience = YES;
    }
    [[YYIMChat sharedInstance].chatManager updateSilenceMode:slience complete:^(BOOL result, NSString *msg) {
        id resultValue = nil;
        if (!result) {
            NSString *message = msg ?:@"设置沉浸错误";
            resultValue = @{ @"success": @NO, @"errorMsg": message };
        }
        else {
            resultValue = @{ @"success": @YES };
        }
        //回调，要改：
//        id returnValue = [SUMJSSerialization jsObjectForCallServiceWithResult:resultValue];
//        [args evaluateJavaScriptCallbackWithObject:returnValue];
    }];
}

- (void)isSilenceMode:(id<SUMExtension>)args {
    [[YYIMChat sharedInstance].chatManager loadUserProfilesWithComplete:^(BOOL result, NSDictionary *dic, NSString *msg) {
        id resultValue = nil;
        if (!result) {
            NSString *message = msg ?:@"获取沉浸模式错误";
            resultValue = @{ @"success": @NO, @"errorMsg": message };
        } else {
            NSString * silence = dic[@"silenceModeSwitch"];
            BOOL isSilence = NO;
            if ([silence isEqualToString:@"on"]) {
                isSilence = YES;
            }
            resultValue = @{ @"success": @YES,@"isSilence" : [NSNumber numberWithBool:isSilence]};
        }
        //回调，要改：
//        id returnValue = [SUMJSSerialization jsObjectForCallServiceWithResult:resultValue];
//        [args evaluateJavaScriptCallbackWithObject:returnValue];
    }];
}
// 联系人、聊天记录等搜索
- (void)searchByKey:(id<SUMExtension>)args {

}
// 搜索界面
- (void)chatSearch:(id<SUMExtension>)args {

}

- (void)chatSendLog:(id<SUMExtension>)args {
    [[YYIMChat sharedInstance].chatManager sendFileLogComplete:nil];
}

#pragma mark - <YYIMChatDelegate>

- (void)didReceiveMessage:(YYMessage *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    });
}

- (void)didUserInfoUpdate:(YYUser *)user {
    
    if (self.fetchMessagesCompletion == nil) {
        return;
    }
    
    if ([self.loadingUsers containsObject:user.userId]) {
        [self.loadingUsers removeObject:self.loadingUsers];
    }
    if (self.loadingUsers.count == 0 && self.fetchMessagesCompletion) {
        self.fetchMessagesCompletion();
        self.fetchMessagesCompletion = nil;
    }
}

#pragma mark - private

- (void)resetRecentBudget {
    NSInteger unreadMsgCount = [[YYIMChat sharedInstance].chatManager getUnreadMsgCount];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application = [UIApplication sharedApplication];
        [application setApplicationIconBadgeNumber:unreadMsgCount];
    });
}
#pragma mark - private

- (void)loginIM:(NSString *)account password:(NSString *)password name:(NSString *)name args:(id<SUMExtension>)args {
    
    NSError *error;
    [self prepareAccount:account password:password error:&error];
    if (error) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"YYIM_NICKNAME"];
    YYIMLoginCompleteBlock completion = ^(BOOL result, NSDictionary *userInfo, YYIMError *loginError) {
        
        id resultValue = nil;
        if (!result) {
            NSString *message;
            if ([[loginError errorMsg] isEqualToString:@"app not found"]) {
                message = @"登录的应用不存在";
            } else {
                message = [loginError errorMsg];
            }
            if (!message) {
                message = @"连接IM服务器失败";
            }
            resultValue = @{ @"success": @NO, @"errorMsg": message };
        }
        else {
            resultValue = @{ @"success": @YES };
        }
        //回调：
//        id returnValue = [SUMJSSerialization jsObjectForCallServiceWithResult:resultValue];
//        [args evaluateJavaScriptCallbackWithObject:returnValue];
    };
    if (!account || account.length == 0) {
        [[YYIMChat sharedInstance].chatManager loginAnonymousWithCompletion:completion];
    } else {
        [[YYIMChat sharedInstance].chatManager login:account completion:completion];
    }
}

- (NSString *)prepareAccount:(NSString *)account password:(NSString *)password error:(NSError **)errPtr {
    // save last login account
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account forKey:YYIM_LASTLOGIN_ACCOUNT];
    
    NSRegularExpression *regexSingle = [NSRegularExpression regularExpressionWithPattern:@"[a-z0-9A-Z_.-]{1,50}" options:0 error:nil];
    NSTextCheckingResult *matchSingle = [regexSingle firstMatchInString:account options:0 range:NSMakeRange(0, [account length])];
    if (matchSingle) {
        [userDefaults setObject:account forKey:YYIM_ACCOUNT];
        [userDefaults setObject:password forKey:YYIM_PASSWORD];
        [userDefaults synchronize];
        return account;
    } else {
        *errPtr = [NSError errorWithDomain:@"com.yonyou.sns" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"用户名不合法" forKey:NSLocalizedDescriptionKey]];
        return account;
    }
}
#pragma mark 数据格式转换
- (NSString*)convertToJSONData:(id)infoDict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}
//- (NSDictionary*)getObjectData:(id)obj {
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    unsigned int propsCount;
//    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
//    for(int i =0;i < propsCount; i++) {
//        objc_property_t prop = props[i];
//        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
//        id value = [obj valueForKey:propName];
//        if(value == nil) {
//            value = [NSNull null];
//        } else {
//            value = [self getObjectInternal:value];
//        }
//        [dic setObject:value forKey:propName];
//    }
//    return dic;
//}
//- (id)getObjectInternal:(id)obj {
//    if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]]) {
//        return obj;
//    }
//    if([obj isKindOfClass:[NSArray class]]) {
//        NSArray *objarr = obj;
//        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
//        for(int i =0;i < objarr.count; i++) {
//            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]]atIndexedSubscript:i];
//        }
//        return arr;
//    }
//
//    if([obj isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *objdic = obj;
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
//        for(NSString *key in objdic.allKeys) {
//            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
//        }
//        return dic;
//    }
//    return [self getObjectData:obj];
//}
@end
