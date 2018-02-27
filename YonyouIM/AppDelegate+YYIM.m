//
//  AppDelegate+YYIM.m
//  YYIMDemo
//
//  Created by Chenly on 2017/6/10.
//  Copyright © 2017年 Yonyou. All rights reserved.
//

#import "AppDelegate+YYIM.h"
#import "IMManager.h"
#import "YYIMChat.h"
#import "MessageService.h"
#import "ChatViewController.h"

#import <objc/runtime.h>
//#import "SUMJSSerialization.h"
@implementation AppDelegate (YYIM)

+ (void)load {
    Method origin;
    Method swizzle;
    origin  = class_getInstanceMethod([self class], @selector(application:didFinishLaunchingWithOptions:));
    swizzle = class_getInstanceMethod([self class], @selector(yyim_application:didFinishLaunchingWithOptions:));
    method_exchangeImplementations(origin, swizzle);
}

- (BOOL)yyim_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 注册远程推送
    [self registerRemoteNotification];
    // 注册有信推送服务
    [[IMManager sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    return [self yyim_application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[YYIMChat sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[YYIMChat sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[YYIMChat sharedInstance] applicationWillEnterForeground:application];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[YYIMChat sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[YYIMChat sharedInstance] applicationWillTerminate:application];
}

// 判断远程推送是否可用
- (BOOL)enabledRemoteNotification{
    
    UIUserNotificationType types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
    return (types & UIUserNotificationTypeAlert);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[YYIMChat sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[YYIMChat sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[YYIMChat sharedInstance] application:application didReceiveRemoteNotification:userInfo];
    
    if (application.applicationState == UIApplicationStateInactive) {
        [self openChatViewForRemoteNotification:userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    [[YYIMChat sharedInstance] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    completionHandler(UIBackgroundFetchResultNoData);
    
    if (application.applicationState == UIApplicationStateInactive) {
        [self openChatViewForRemoteNotification:userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[YYIMChat sharedInstance] application:application didReceiveLocalNotification:notification];
    
    if (application.applicationState == UIApplicationStateInactive) {
        [self openChatViewForRemoteNotification:notification.userInfo];
    }
}

- (void)registerRemoteNotification {
    // 注册推送
    UIApplication *application = [UIApplication sharedApplication];
    [application registerForRemoteNotifications];
    UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
}
#pragma mark - private

// 通过消息栏打开时，跳转到对应的聊天页
- (void)openChatViewForRemoteNotification:(NSDictionary *)userInfo {
//    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    if (![rootViewController isKindOfClass:[UINavigationController class]]) {
//        return;
//    }
//
//    UINavigationController *naviController = (UINavigationController *)rootViewController;
//    if (![naviController.topViewController isKindOfClass:[SUMCordovaController class]] &&
//        ![naviController.topViewController isKindOfClass:[ChatViewController class]]) {
//        return;
//    }
    
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"www/config" ofType:@"json"];
    if(configPath.length == 0) return;
    NSData *configData = [NSData dataWithContentsOfFile:configPath];
    NSError *error;
    NSDictionary *configDic = [NSJSONSerialization JSONObjectWithData:configData options:0 error:&error];
    NSString * pushStr = @"";
    pushStr = configDic[@"messageIntercept"];
    if (pushStr.length == 0) {
        pushStr = @"openIMSystemWin()";
    }
    NSString *chatId = [userInfo[@"yyim_from"] componentsSeparatedByString:@"."].firstObject;
    NSString *chatType = [userInfo[@"yyim_chattype"] componentsSeparatedByString:@"."].firstObject;
    if (!chatId || chatId.length == 0) {
        chatId = @"";
    }
    if (!chatType || chatType.length == 0) {
        chatType = @"";
    }
    if ([userInfo.allKeys containsObject:@"yyim_extend"]) {
        id contentDic = userInfo[@"yyim_extend"];
        if ([contentDic isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)contentDic;
            if (![dic.allKeys containsObject:@"extend"]) {
                NSDictionary *extendDic = @{@"extend":dic};
                contentDic = extendDic;
            }
        } else if ([contentDic isKindOfClass:[NSString class]]) {
            NSDictionary *dic = [self dictionaryWithJsonString:(NSString *)contentDic];
            if (![dic.allKeys containsObject:@"extend"]) {
                NSDictionary *extendDic = @{@"extend":contentDic};
                contentDic = extendDic;
            }
        }

//        NSString *obj = [SUMJSSerialization jsStringWithObject:@{@"result" : contentDic,@"chatType":chatType,@"chatID":chatId}];
//        pushStr = [pushStr stringByReplacingOccurrencesOfString:@"()" withString:@""];
//        NSString *script = [NSString stringWithFormat:@"%@(%@)",pushStr, obj];
//        [naviController popToRootViewControllerAnimated:NO];
//        if ([naviController.topViewController isKindOfClass:[SUMCordovaController class]]) {
//
//            SUMCordovaController *vc = (SUMCordovaController *)naviController.topViewController;
//            [vc evaluateJavaScript:script completion:nil];
//        }
    }
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
