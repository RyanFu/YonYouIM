//
//  YYIMExtManager.m
//  YonyouIMSdk
//
//  Created by litfb on 15/4/10.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYIMExtManager.h"
#import "YYIMDBHelper.h"
#import "YMAFNetworking.h"
#import "YYIMConfig.h"
#import "YYIMLogger.h"
#import "JUMPFramework.h"
#import "YYIMJUMPHelper.h"
#import "YYIMError.h"

//userprofile沉浸模式对应的字段
#define YYIM_EXT_SILENCE_MODE_SWITCH    @"silenceModeSwitch"
// 勿扰模式
#define YYIM_EXT_NODISTURB_SWITCH       @"noDisturbSwitch"

#define YYIM_EXT_NEWMESSAGE_REMIND     @"remind"
#define YYIM_EXT_NEWMESSAGE_PREVIEW    @"preview"
// 声音
#define YYIM_EXT_NEWMESSAGE_SOUND       @"sound"
// 震动
#define YYIM_EXT_NEWMESSAGE_VIBRATE     @"vibration"
// 勿扰模式时间
#define YYIM_EXT_NODISTURB_BEGINHOUR    @"noDisturbBeginTimeHour"
#define YYIM_EXT_NODISTURB_BEGINMINUTE  @"noDisturbBeginTimeMinute"
#define YYIM_EXT_NODISTURB_ENDHOUR      @"noDisturbEndTimeHour"
#define YYIM_EXT_NODISTURB_ENDMINUTE    @"noDisturbEndTimeMinute"

@interface YYIMExtManager ()<JUMPStreamDelegate>

@end

@implementation YYIMExtManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)loadUserProfilesWithComplete:(void (^)(BOOL result,NSDictionary *dic, NSString *msg)) complete {
    [YYIMJUMPHelper genAvailableTokenWithComplete:^(BOOL result, YYToken *token, YYIMError *tokenError) {
        if (result && [token tokenStr]) {
            YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
            [manager setRequestSerializer:[YMAFJSONRequestSerializer serializer]];
            [manager setCompletionQueue:[self moduleQueue]];
            NSString *urlString = [NSString stringWithFormat:@"%@?token=%@", [[YYIMConfig sharedInstance] getUserProfileServlet], [token tokenStr]];
            
            [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSDictionary *dic = (NSDictionary *)responseObject;
                // 免打扰
                [[YYIMDBHelper sharedInstance] clearNoDisturb];
                NSArray *muteItems = [dic objectForKey:@"muteItems"];
                if (muteItems && [muteItems count] > 0) {
                    for (NSString *muteItem in muteItems) {
                        JUMPJID *jid = [JUMPJID jidWithString:muteItem];
                        if ([[jid domain] isEqualToString:[[YYIMConfig sharedInstance] getConferenceServerName]]) {
                            NSString *groupId = [YYIMJUMPHelper parseUser:[jid user]];
                            YYChatGroupExt *ext = [[YYIMDBHelper sharedInstance] getChatGroupExtWithId:groupId];
                            [ext setNoDisturb:YES];
                            [[YYIMDBHelper sharedInstance] updateChatGroupExt:ext];
                        } else if ([[jid domain] isEqualToString:[[YYIMConfig sharedInstance] getPubAccountServerName]]) {
                            NSString *accountId = [YYIMJUMPHelper parseUser:[jid user]];
                            YYPubAccountExt *ext = [[YYIMDBHelper sharedInstance] getPubAccountExtWithId:accountId];
                            [ext setNoDisturb:YES];
                            [[YYIMDBHelper sharedInstance] updatePubAccountExt:ext];
                        } else {
                            NSString *userId = [YYIMJUMPHelper parseUser:[jid user]];
                            YYUserExt *ext = [[YYIMDBHelper sharedInstance] getUserExtWithId:userId];
                            [ext setNoDisturb:YES];
                            [[YYIMDBHelper sharedInstance] updateUserExt:ext];
                        }
                    }
                }
                
                // 置顶
                [[YYIMDBHelper sharedInstance] clearStickTop];
                NSArray *stickItems = [dic objectForKey:@"stickItems"];
                if (stickItems && [stickItems count] > 0) {
                    for (NSString *stickItem in stickItems) {
                        JUMPJID *jid = [JUMPJID jidWithString:stickItem];
                        if ([[jid domain] isEqualToString:[[YYIMConfig sharedInstance] getConferenceServerName]]) {
                            NSString *groupId = [YYIMJUMPHelper parseUser:[jid user]];
                            YYChatGroupExt *ext = [[YYIMDBHelper sharedInstance] getChatGroupExtWithId:groupId];
                            [ext setStickTop:YES];
                            [[YYIMDBHelper sharedInstance] updateChatGroupExt:ext];
                        } else if ([[jid domain] isEqualToString:[[YYIMConfig sharedInstance] getPubAccountServerName]]) {
                            NSString *accountId = [YYIMJUMPHelper parseUser:[jid user]];
                            YYPubAccountExt *ext = [[YYIMDBHelper sharedInstance] getPubAccountExtWithId:accountId];
                            [ext setStickTop:YES];
                            [[YYIMDBHelper sharedInstance] updatePubAccountExt:ext];
                        } else {
                            NSString *userId = [YYIMJUMPHelper parseUser:[jid user]];
                            YYUserExt *ext = [[YYIMDBHelper sharedInstance] getUserExtWithId:userId];
                            [ext setStickTop:YES];
                            [[YYIMDBHelper sharedInstance] updateUserExt:ext];
                        }
                    }
                }
                
                // 用户配置信息
                NSMutableDictionary *profileDic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"profile"]];
                if ([dic.allKeys containsObject:@"noPushStatus"]) {
                    [profileDic setObject:dic[@"noPushStatus"] forKey:@"noPushStatus"];
                }
                [[YYIMDBHelper sharedInstance] updateUserProfile:profileDic];
                
                [[self activeDelegate] didUserProfileUpdate:[[YYIMDBHelper sharedInstance] getUserProfiles]];
                if (complete) {
                    if (!profileDic) {
                        profileDic = [NSMutableDictionary dictionary];
                    }
                    complete(YES,profileDic,nil);
                }
            } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                YYIMLogError(@"didNotLoadUserProfile%@", responseObject);
                NSDictionary *dic = (NSDictionary *)responseObject;
                [[self activeDelegate] didNotLoadUserProfileWithError:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                if (complete) {
                    complete(NO,nil,[dic objectForKey:@"message"]);
                }
            }];
        } else {
            [[self activeDelegate] didNotLoadUserProfileWithError:tokenError];
            if (complete) {
                complete(NO,nil,tokenError.errorMsg);
            }
        }
    }];
}

- (void)updateUserNoDisturb:(BOOL)noDisturb userId:(NSString *)userId {
    [YYIMJUMPHelper genAvailableTokenWithComplete:^(BOOL result, YYToken *token, YYIMError *tokenError) {
        if (result && [token tokenStr]) {
            JUMPJID *jid = [YYIMJUMPHelper genFullJid:userId];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[jid bare] forKey:@"bareJID"];
            
            YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
            [manager setRequestSerializer:[YMAFJSONRequestSerializer serializer]];
            [manager setCompletionQueue:[self moduleQueue]];
            NSString *urlString = [NSString stringWithFormat:@"%@?token=%@", [[YYIMConfig sharedInstance] getUserProfileMuteServlet], [token tokenStr]];
            
            if (noDisturb) {
                [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetNoDisturbSuccess");
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetNoDisturbFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdateUserNoDisturb:userId error:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                }];
            } else {
                [manager DELETE:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetNoDisturbSuccess");
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetNoDisturbFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdateUserNoDisturb:userId error:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                }];
            }
        } else {
            [[self activeDelegate] didNotUpdateUserNoDisturb:userId error:tokenError];
        }
    }];
}

- (void)updateUserStickTop:(BOOL)stickTop userId:(NSString *)userId {
    [YYIMJUMPHelper genAvailableTokenWithComplete:^(BOOL result, YYToken *token, YYIMError *tokenError) {
        if (result && [token tokenStr]) {
            JUMPJID *jid = [YYIMJUMPHelper genFullJid:userId];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[jid bare] forKey:@"bareJID"];
            
            YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
            [manager setRequestSerializer:[YMAFJSONRequestSerializer serializer]];
            [manager setCompletionQueue:[self moduleQueue]];
            NSString *urlString = [NSString stringWithFormat:@"%@?token=%@", [[YYIMConfig sharedInstance] getUserProfileStickServlet], [token tokenStr]];
            
            if (stickTop) {
                [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetStickTopSuccess");
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetStickTopFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdateUserStickTop:userId error:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                }];
            } else {
                [manager DELETE:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetStickTopSuccess");
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetStickTopFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdateUserStickTop:userId error:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                }];
            }
        } else {
            [[self activeDelegate] didNotUpdateUserStickTop:userId error:tokenError];
        }
    }];
}

- (void)updateGroupNoDisturb:(BOOL)noDisturb groupId:(NSString *)groupId {
    [YYIMJUMPHelper genAvailableTokenWithComplete:^(BOOL result, YYToken *token, YYIMError *tokenError) {
        if (result && [token tokenStr]) {
            JUMPJID *jid = [YYIMJUMPHelper genFullGroupJid:groupId];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[jid bare] forKey:@"bareJID"];
            
            YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
            [manager setRequestSerializer:[YMAFJSONRequestSerializer serializer]];
            [manager setCompletionQueue:[self moduleQueue]];
            NSString *urlString = [NSString stringWithFormat:@"%@?token=%@", [[YYIMConfig sharedInstance] getUserProfileMuteServlet], [token tokenStr]];
            
            if (noDisturb) {
                [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetNoDisturbSuccess");
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetNoDisturbFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdateGroupNoDisturb:groupId error:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                }];
            } else {
                [manager DELETE:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetNoDisturbSuccess");
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetNoDisturbFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdateGroupNoDisturb:groupId error:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                }];
            }
        } else {
            [[self activeDelegate] didNotUpdateGroupNoDisturb:groupId error:tokenError];
        }
    }];
}

- (void)updateGroupStickTop:(BOOL)stickTop groupId:(NSString *)groupId {
    [YYIMJUMPHelper genAvailableTokenWithComplete:^(BOOL result, YYToken *token, YYIMError *tokenError) {
        if (result && [token tokenStr]) {
            JUMPJID *jid = [YYIMJUMPHelper genFullGroupJid:groupId];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[jid bare] forKey:@"bareJID"];
            
            YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
            [manager setRequestSerializer:[YMAFJSONRequestSerializer serializer]];
            [manager setCompletionQueue:[self moduleQueue]];
            NSString *urlString = [NSString stringWithFormat:@"%@?token=%@", [[YYIMConfig sharedInstance] getUserProfileStickServlet], [token tokenStr]];
            
            if (stickTop) {
                [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetStickTopSuccess");
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetStickTopFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdateGroupStickTop:groupId error:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                }];
            } else {
                [manager DELETE:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetStickTopSuccess");
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetStickTopFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdateGroupStickTop:groupId error:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                }];
            }
        } else {
            [[self activeDelegate] didNotUpdateGroupStickTop:groupId error:tokenError];
        }
    }];
}

- (void)updatePubAccountNoDisturb:(BOOL)noDisturb accountId:(NSString *)accountId {
    [YYIMJUMPHelper genAvailableTokenWithComplete:^(BOOL result, YYToken *token, YYIMError *tokenError) {
        if (result && [token tokenStr]) {
            JUMPJID *jid = [YYIMJUMPHelper genFullPubAccountJid:accountId];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[jid bare] forKey:@"bareJID"];
            
            YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
            [manager setRequestSerializer:[YMAFJSONRequestSerializer serializer]];
            [manager setCompletionQueue:[self moduleQueue]];
            NSString *urlString = [NSString stringWithFormat:@"%@?token=%@", [[YYIMConfig sharedInstance] getUserProfileMuteServlet], [token tokenStr]];
            
            if (noDisturb) {
                [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetNoDisturbSuccess");
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetNoDisturbFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdatePubAccountNoDisturb:accountId error:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                }];
            } else {
                [manager DELETE:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetNoDisturbSuccess");
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetNoDisturbFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdatePubAccountNoDisturb:accountId error:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                }];
            }
        } else {
            [[self activeDelegate] didNotUpdatePubAccountNoDisturb:accountId error:tokenError];
        }
    }];
}

- (void)updatePubAccountStickTop:(BOOL)stickTop accountId:(NSString *)accountId {
    [YYIMJUMPHelper genAvailableTokenWithComplete:^(BOOL result, YYToken *token, YYIMError *tokenError) {
        if (result && [token tokenStr]) {
            JUMPJID *jid = [YYIMJUMPHelper genFullPubAccountJid:accountId];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[jid bare] forKey:@"bareJID"];
            
            YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
            [manager setRequestSerializer:[YMAFJSONRequestSerializer serializer]];
            [manager setCompletionQueue:[self moduleQueue]];
            NSString *urlString = [NSString stringWithFormat:@"%@?token=%@", [[YYIMConfig sharedInstance] getUserProfileStickServlet], [token tokenStr]];
            
            if (stickTop) {
                [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetStickTopSuccess");
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetStickTopFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdatePubAccountStickTop:accountId error:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                }];
            } else {
                [manager DELETE:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetStickTopSuccess");
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetStickTopFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdatePubAccountStickTop:accountId error:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                }];
            }
        } else {
            [[self activeDelegate] didNotUpdatePubAccountStickTop:accountId error:tokenError];
        }
    }];
}

- (NSDictionary<NSString *,NSString *> *)getUserProfiles {
    return [[YYIMDBHelper sharedInstance] getUserProfiles];
}

- (void)setUserProfileWithDic:(NSDictionary<NSString *,NSString *> *)profileDic {
    [YYIMJUMPHelper genAvailableTokenWithComplete:^(BOOL result, YYToken *token, YYIMError *tokenError) {
        if (result && [token tokenStr]) {
            YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
            [manager setRequestSerializer:[YMAFJSONRequestSerializer serializer]];
            [manager setCompletionQueue:[self moduleQueue]];
            NSString *urlString = [NSString stringWithFormat:@"%@?token=%@", [[YYIMConfig sharedInstance] getUserProfileServlet], [token tokenStr]];
            
            [manager POST:urlString parameters:profileDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                YYIMLogInfo(@"SetUserProfileSuccess");
            } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                YYIMLogError(@"SetUserProfileFaild:%@|%@", responseObject, error);
                NSDictionary *dic = (NSDictionary *)responseObject;
                [[self activeDelegate] didNotSetUserProfileWithError:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
            }];
        } else {
            [[self activeDelegate] didNotSetUserProfileWithError:tokenError];
        }
    }];
}

- (void)removeUserProfileWithKeys:(NSArray<NSString *> *)profileKeys {
    [YYIMJUMPHelper genAvailableTokenWithComplete:^(BOOL result, YYToken *token, YYIMError *tokenError) {
        if (result && [token tokenStr]) {
            YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
            [manager setRequestSerializer:[YMAFJSONRequestSerializer serializer]];
            [manager setCompletionQueue:[self moduleQueue]];
            NSString *urlString = [NSString stringWithFormat:@"%@?token=%@", [[YYIMConfig sharedInstance] getUserProfileServlet], [token tokenStr]];
            
            [manager PUT:urlString parameters:profileKeys success:^(NSURLSessionDataTask *task, id responseObject) {
                YYIMLogInfo(@"RemoveUserProfileSuccess");
            } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                YYIMLogError(@"RemoveUserProfileFaild:%@|%@", responseObject, error);
                NSDictionary *dic = (NSDictionary *)responseObject;
                [[self activeDelegate] didNotRemoveUserProfileWithError:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
            }];
        } else {
            [[self activeDelegate] didNotRemoveUserProfileWithError:tokenError];
        }
    }];
}

- (void)clearUserProfiles {
    [YYIMJUMPHelper genAvailableTokenWithComplete:^(BOOL result, YYToken *token, YYIMError *tokenError) {
        if (result && [token tokenStr]) {
            YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
            [manager setRequestSerializer:[YMAFJSONRequestSerializer serializer]];
            [manager setCompletionQueue:[self moduleQueue]];
            NSString *urlString = [NSString stringWithFormat:@"%@?token=%@", [[YYIMConfig sharedInstance] getUserProfileServlet], [token tokenStr]];
            
            [manager DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                YYIMLogInfo(@"ClearUserProfileSuccess");
            } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                YYIMLogError(@"ClearUserProfileFaild:%@|%@", responseObject, error);
                NSDictionary *dic = (NSDictionary *)responseObject;
                [[self activeDelegate] didNotClearUserProfileWithError:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
            }];
        } else {
            [[self activeDelegate] didNotClearUserProfileWithError:tokenError];
        }
    }];
}

- (YYUserExt *)getUserExtWithId:(NSString *)userId {
    return [[YYIMDBHelper sharedInstance] getUserExtWithId:userId];
}

- (YYChatGroupExt *)getChatGroupExtWithId:(NSString *)groupId {
    return [[YYIMDBHelper sharedInstance] getChatGroupExtWithId:groupId];
}

- (YYPubAccountExt *)getPubAccountExtWithId:(NSString *)accountId {
    return [[YYIMDBHelper sharedInstance] getPubAccountExtWithId:accountId];
}

- (void)setChatGroupShowName:(BOOL)showName groupId:(NSString *)groupId {
    YYChatGroupExt *ext = [[YYIMDBHelper sharedInstance] getChatGroupExtWithId:groupId];
    [ext setShowName:showName];
    [[YYIMDBHelper sharedInstance] updateChatGroupExt:ext];
    
    [[self activeDelegate] didChatGroupExtUpdate:ext];
}

- (void)updateUserExt:(YYUserExt *)userExt {
    [[YYIMDBHelper sharedInstance] updateUserExt:userExt];
}

- (void)updateChatGroupExt:(YYChatGroupExt *)chatGroupExt {
    [[YYIMDBHelper sharedInstance] updateChatGroupExt:chatGroupExt];
}

- (void)updatePubAccountExt:(YYPubAccountExt *)pubAccountExt {
    [[YYIMDBHelper sharedInstance] updatePubAccountExt:pubAccountExt];
}

#pragma mark JUMPStreamDelegate

- (void)jumpStream:(JUMPStream *)sender didReceiveMessage:(JUMPMessage *)message {
    if ([message checkOpData:JUMP_OPDATA(JUMPUserProfileOnlineDeliverPacketOpCode)]) {
        [self handleUserProfileOnlineDeliverPacket:message];
    }
}

#pragma mark handle

//用户设置有变更的时候都会触发在线的透传
- (void)handleUserProfileOnlineDeliverPacket:(JUMPMessage *)message {
    // category
    NSString *category = [message objectForKey:@"category"];
    // attributes
    NSDictionary *attributes = [message objectForKey:@"attributes"];
    
    if ([category isEqualToString:@"setSilenceMode"]) {
        // 取当前profile
        NSDictionary *profiles = [[YYIMDBHelper sharedInstance] getUserProfiles];
        // 新profile
        NSMutableDictionary<NSString *,NSString *> *newProfileDic = [NSMutableDictionary dictionary];
        // 加上旧的
        [newProfileDic setDictionary:profiles];
        [newProfileDic setObject:@"on" forKey:YYIM_EXT_SILENCE_MODE_SWITCH];
        // 保存
        [[YYIMDBHelper sharedInstance] updateUserProfile:newProfileDic];
        [[self activeDelegate] didUserProfileUpdate:[[YYIMDBHelper sharedInstance] getUserProfiles]];
    } else if ([category isEqualToString:@"cancelSilenceMode"]) {
        // 取当前profile
        NSDictionary *profiles = [[YYIMDBHelper sharedInstance] getUserProfiles];
        // 新profile
        NSMutableDictionary<NSString *,NSString *> *newProfileDic = [NSMutableDictionary dictionary];
        // 加上旧的
        [newProfileDic setDictionary:profiles];
        [newProfileDic setObject:@"off" forKey:YYIM_EXT_SILENCE_MODE_SWITCH];
        // 保存
        [[YYIMDBHelper sharedInstance] updateUserProfile:newProfileDic];
        [[self activeDelegate] didUserProfileUpdate:[[YYIMDBHelper sharedInstance] getUserProfiles]];
    } else if ([category isEqualToString:@"setNoDisturb"]) {
        // 取当前profile
        NSDictionary *profiles = [[YYIMDBHelper sharedInstance] getUserProfiles];
        // 新profile
        NSMutableDictionary<NSString *,NSString *> *newProfileDic = [NSMutableDictionary dictionary];
        // 加上旧的
        [newProfileDic setDictionary:profiles];
        // 覆盖上新的
        [newProfileDic addEntriesFromDictionary:attributes];
        // 保存
        [[YYIMDBHelper sharedInstance] updateUserProfile:newProfileDic];
        
        [[self activeDelegate] didUserProfileUpdate:[[YYIMDBHelper sharedInstance] getUserProfiles]];
    } else if ([category isEqualToString:@"cancelNoDisturb"]) {
        // 取当前profile
        NSDictionary *profiles = [[YYIMDBHelper sharedInstance] getUserProfiles];
        // 新profile
        NSMutableDictionary<NSString *,NSString *> *newProfileDic = [NSMutableDictionary dictionary];
        // 加上旧的
        [newProfileDic setDictionary:profiles];
        [newProfileDic setObject:@"off" forKey:YYIM_EXT_NODISTURB_SWITCH];
        // 保存
        [[YYIMDBHelper sharedInstance] updateUserProfile:newProfileDic];
        
        [[self activeDelegate] didUserProfileUpdate:[[YYIMDBHelper sharedInstance] getUserProfiles]];
    } else if ([category isEqualToString:@"addProfile"]) {// 更新Profile项
        // 取当前profile
        NSDictionary *profiles = [[YYIMDBHelper sharedInstance] getUserProfiles];
        // 新profile
        NSMutableDictionary<NSString *,NSString *> *newProfileDic = [NSMutableDictionary dictionary];
        // 加上旧的
        [newProfileDic setDictionary:profiles];
        // 覆盖上新的
        [newProfileDic addEntriesFromDictionary:attributes];
        // 保存
        [[YYIMDBHelper sharedInstance] updateUserProfile:newProfileDic];
        
        [[self activeDelegate] didUserProfileUpdate:[[YYIMDBHelper sharedInstance] getUserProfiles]];
    } else if ([category isEqualToString:@"deleteProfile"]) {// 删除部分Profile项
        // 要删除的key
        NSArray *keys = [attributes objectForKey:@"keys"];
        // 取当前profile
        NSDictionary *profiles = [[YYIMDBHelper sharedInstance] getUserProfiles];
        // 新profile
        NSMutableDictionary<NSString *,NSString *> *newProfileDic = [NSMutableDictionary dictionary];
        // 加上旧的
        [newProfileDic setDictionary:profiles];
        // 删掉要删的
        [newProfileDic removeObjectsForKeys:keys];
        // 保存
        [[YYIMDBHelper sharedInstance] updateUserProfile:newProfileDic];
        
        [[self activeDelegate] didUserProfileUpdate:[[YYIMDBHelper sharedInstance] getUserProfiles]];
    } else if ([category isEqualToString:@"removeProfile"]) {// 删除所有Profile
        [[YYIMDBHelper sharedInstance] updateUserProfile:nil];
        [[self activeDelegate] didUserProfileUpdate:[[YYIMDBHelper sharedInstance] getUserProfiles]];
    } else if ([category isEqualToString:@"setNoPushStatus"]) {
        // 取当前profile
        NSDictionary *profiles = [[YYIMDBHelper sharedInstance] getUserProfiles];
        // 新profile
        NSMutableDictionary<NSString *,NSString *> *newProfileDic = [NSMutableDictionary dictionary];
        // 加上旧的
        [newProfileDic setDictionary:profiles];
        // 覆盖上新的
        [newProfileDic addEntriesFromDictionary:attributes];
        // 保存
        [[YYIMDBHelper sharedInstance] updateUserProfile:newProfileDic];
        
        [[self activeDelegate] didUserProfileUpdate:[[YYIMDBHelper sharedInstance] getUserProfiles]];
    } else {
        NSString *jidStr = [attributes objectForKey:@"bareJID"];
        JUMPJID *jid = [JUMPJID jidWithString:jidStr];
        
        if ([[jid domain] isEqualToString:[[YYIMConfig sharedInstance] getConferenceServerName]]) {
            NSString *groupId = [YYIMJUMPHelper parseUser:[jid user]];
            YYChatGroupExt *ext = [[YYIMDBHelper sharedInstance] getChatGroupExtWithId:groupId];
            if ([category isEqualToString:@"setStick"]) {// 设置置顶
                [ext setStickTop:YES];
            } else if ([category isEqualToString:@"cancelStick"]) {// 取消置顶
                [ext setStickTop:NO];
            } else if ([category isEqualToString:@"setMute"]) {// 设置静音
                [ext setNoDisturb:YES];
            } else if ([category isEqualToString:@"cancelMute"]) {// 取消静音
                [ext setNoDisturb:NO];
//            } else if ([category isEqualToString:@"setIntoGroupAssistant"]) {// 助手
//                [ext setAssistant:YES];
//            } else if ([category isEqualToString:@"cancelFromGroupAssistant"]) {// 取消助手
//                [ext setAssistant:NO];
            }
            
            [[YYIMDBHelper sharedInstance] updateChatGroupExt:ext];
            
            [[self activeDelegate] didChatGroupExtUpdate:ext];
        } else if ([[jid domain] isEqualToString:[[YYIMConfig sharedInstance] getPubAccountServerName]]) {
            NSString *accountId = [YYIMJUMPHelper parseUser:[jid user]];
            YYPubAccountExt *ext = [[YYIMDBHelper sharedInstance] getPubAccountExtWithId:accountId];
            if ([category isEqualToString:@"setStick"]) {// 设置置顶
                [ext setStickTop:YES];
            } else if ([category isEqualToString:@"cancelStick"]) {// 取消置顶
                [ext setStickTop:NO];
            } else if ([category isEqualToString:@"setMute"]) {// 设置静音
                [ext setNoDisturb:YES];
            } else if ([category isEqualToString:@"cancelMute"]) {// 取消静音
                [ext setNoDisturb:NO];
            }
            [[YYIMDBHelper sharedInstance] updatePubAccountExt:ext];
            
            [[self activeDelegate] didPubAccountExtUpdate:ext];
        } else if ([[jid domain] isEqualToString:[[YYIMConfig sharedInstance] getIMServerName]]) {
            NSString *userId = [YYIMJUMPHelper parseUser:[jid user]];
            YYUserExt *ext = [[YYIMDBHelper sharedInstance] getUserExtWithId:userId];
            if ([category isEqualToString:@"setStick"]) {// 设置置顶
                [ext setStickTop:YES];
            } else if ([category isEqualToString:@"cancelStick"]) {// 取消置顶
                [ext setStickTop:NO];
            } else if ([category isEqualToString:@"setMute"]) {// 设置静音
                [ext setNoDisturb:YES];
            } else if ([category isEqualToString:@"cancelMute"]) {// 取消静音
                [ext setNoDisturb:NO];
            }
            [[YYIMDBHelper sharedInstance] updateUserExt:ext];
            
            [[self activeDelegate] didUserExtUpdate:ext];
        }
    }
}

//////////////新添加
/**
 设置沉浸模式
 
 @param silenceMode 沉浸模式
 */
- (void)updateSilenceMode:(BOOL)silenceMode complete:(void (^)(BOOL result, NSString *msg)) complete {
    [YYIMJUMPHelper genAvailableTokenWithComplete:^(BOOL result, YYToken *token, YYIMError *tokenError) {
        if (result && [token tokenStr]) {
            YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
            [manager setRequestSerializer:[YMAFJSONRequestSerializer serializer]];
            [manager setCompletionQueue:[self moduleQueue]];
            NSString *urlString = [NSString stringWithFormat:@"%@?token=%@", [[YYIMConfig sharedInstance] updateImmersionMode], [token tokenStr]];
            
            if (silenceMode) {
                [manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetSilenceModeSuccess");
                    if (complete) {
                        complete(YES,nil);
                    }
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetSilenceModeFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdateSilenceModeWithError:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                    if (complete) {
                        complete(NO,[dic objectForKey:@"message"]);
                    }
                }];
            } else {
                [manager DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetSilenceModeSuccess");
                    if (complete) {
                        complete(YES,nil);
                    }
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetSilenceModeFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdateSilenceModeWithError:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                    if (complete) {
                        complete(NO,[dic objectForKey:@"message"]);
                    }
                }];
            }
        } else {
            [[self activeDelegate] didNotUpdateSilenceModeWithError:tokenError];
            if (complete) {
                complete(NO,tokenError.errorMsg);
            }
        }
    }];
}
//勿扰模式

- (void)enableUserNoDisturbance:(NSInteger)beginHour beginMinute:(NSInteger)beginMinute endHour:(NSInteger)endHour endMinute:(NSInteger)endMinute {
    [YYIMJUMPHelper genAvailableTokenWithComplete:^(BOOL result, YYToken *token, YYIMError *tokenError) {
        if (result && [token tokenStr]) {
            YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
            [manager setRequestSerializer:[YMAFJSONRequestSerializer serializer]];
            [manager setCompletionQueue:[self moduleQueue]];
            NSString *urlString = [NSString stringWithFormat:@"%@?token=%@", [[YYIMConfig sharedInstance] getUserProfileNoDisturbanceServlet], [token tokenStr]];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[NSNumber numberWithInteger:beginHour] forKey:@"beginTimeHour"];
            [params setObject:[NSNumber numberWithInteger:beginMinute] forKey:@"beginTimeMinute"];
            [params setObject:[NSNumber numberWithInteger:endHour] forKey:@"endTimeHour"];
            [params setObject:[NSNumber numberWithInteger:endMinute] forKey:@"endTimeMinute"];
            
            [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                YYIMLogInfo(@"enableUserNoDisturbanceSuccess");
            } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                YYIMLogError(@"enableUserNoDisturbanceFaild:%@|%@", responseObject, error);
                [self.activeDelegate didNotUpdateMultiTerminalNoPushWithError:[YYIMError errorWithNSError:error]];
            }];
        } else {
            [self.activeDelegate didNotUpdateMultiTerminalNoPushWithError:tokenError];
        }
    }];
}
- (YYUserProfileSetting *)getUserProfileSetting {
    
    YYUserProfileSetting *setting = [YYUserProfileSetting sharedInstance];
    
    NSDictionary *profileDic = [self getUserProfiles];
    
    [setting setIsPreview:YES];
    [setting setIsVoiceInApp:YES];
    [setting setIsVibrateInApp:YES];
    
    if (profileDic) {
        if ([profileDic objectForKey:YYIM_EXT_NEWMESSAGE_REMIND]) {
            [setting setIsRemind:[[profileDic objectForKey:YYIM_EXT_NEWMESSAGE_REMIND] boolValue]];
        }
        
        if ([profileDic objectForKey:YYIM_EXT_NEWMESSAGE_PREVIEW]) {
            [setting setIsPreview:[[profileDic objectForKey:YYIM_EXT_NEWMESSAGE_PREVIEW] boolValue]];
        }
        
        if ([profileDic objectForKey:YYIM_EXT_NEWMESSAGE_SOUND]) {
            [setting setIsVoiceInApp:[[profileDic objectForKey:YYIM_EXT_NEWMESSAGE_SOUND] boolValue]];
        }
        
        if ([profileDic objectForKey:YYIM_EXT_NEWMESSAGE_VIBRATE]) {
            [setting setIsVibrateInApp:[[profileDic objectForKey:YYIM_EXT_NEWMESSAGE_VIBRATE] boolValue]];
        }
        
        NSArray *profileArray = [profileDic allKeys];
        
        if ([profileArray containsObject:YYIM_EXT_NODISTURB_SWITCH]) {
            NSString *result = [profileDic objectForKey:YYIM_EXT_NODISTURB_SWITCH];
            
            if ([result isEqualToString:@"on"]) {
                [setting setNoDisturbSwitch:YES];
            } else {
                [setting setNoDisturbSwitch:NO];
            }
        } else {
            [setting setNoDisturbSwitch:NO];
        }
        
        if ([profileArray containsObject:YYIM_EXT_NODISTURB_BEGINHOUR]) {
            NSNumber *time = [profileDic objectForKey:YYIM_EXT_NODISTURB_BEGINHOUR];
            [setting setNoDisturbBeginTimeHour:[time integerValue]];
        } else {
            [setting setNoDisturbBeginTimeHour:-1];
        }
        
        if ([profileArray containsObject:YYIM_EXT_NODISTURB_BEGINMINUTE]) {
            NSNumber *time = [profileDic objectForKey:YYIM_EXT_NODISTURB_BEGINMINUTE];
            [setting setNoDisturbBeginTimeMinute:[time integerValue]];
        } else {
            [setting setNoDisturbBeginTimeMinute:-1];
        }
        
        if ([profileArray containsObject:YYIM_EXT_NODISTURB_ENDHOUR]) {
            NSNumber *time = [profileDic objectForKey:YYIM_EXT_NODISTURB_ENDHOUR];
            [setting setNoDisturbEndTimeHour:[time integerValue]];
        } else {
            [setting setNoDisturbEndTimeHour:-1];
        }
        
        if ([profileArray containsObject:YYIM_EXT_NODISTURB_ENDMINUTE]) {
            NSNumber *time = [profileDic objectForKey:YYIM_EXT_NODISTURB_ENDMINUTE];
            [setting setNoDisturbEndTimeMinute:[time integerValue]];
        } else {
            [setting setNoDisturbEndTimeMinute:-1];
        }
        
        if ([profileArray containsObject:YYIM_EXT_SILENCE_MODE_SWITCH]) {
            NSString *result = [profileDic objectForKey:YYIM_EXT_SILENCE_MODE_SWITCH];
            if ([result isEqualToString:@"on"]) {
                [setting setSilenceSwitch:YES];
            } else {
                [setting setSilenceSwitch:NO];
            }
        } else {
            [setting setSilenceSwitch:NO];
        }
    }
    return setting;
}

- (BOOL) isTempNoDisturb:(NSString *)fromId {
    NSString *interface = [[YYIMConfig sharedInstance] getCurrentInterface];
    if (interface && interface.length > 0 && [interface isEqualToString:fromId]) {
        return YES;
    }
    return NO;
}
- (void)setUserMute:(BOOL)mute {
    NSString *user = [[YYIMConfig sharedInstance] getFullUser];
    [YYIMJUMPHelper genAvailableTokenWithComplete:^(BOOL result, YYToken *token, YYIMError *tokenError) {
        if (result && [token tokenStr]) {
            YMAFHTTPSessionManager *manager = [YMAFHTTPSessionManager manager];
            [manager setRequestSerializer:[YMAFJSONRequestSerializer serializer]];
            [manager setCompletionQueue:[self moduleQueue]];
            NSString *urlString = [NSString stringWithFormat:@"%@?token=%@", [[YYIMConfig sharedInstance] setUserMute], [token tokenStr]];
            
            if (mute) {
                [manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetMuteSuccess");
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetMuteFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdateUserMuteWithError:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                }];
            } else {
                urlString = [NSString stringWithFormat:@"%@&bareJID=%@",urlString,user];
                [manager DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    YYIMLogInfo(@"SetMuteSuccess");
                } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    YYIMLogError(@"SetMuteFaild:%@|%@", responseObject, error);
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    [[self activeDelegate] didNotUpdateUserMuteWithError:[YYIMError errorWithCode:[[dic objectForKey:@"detailCode"] integerValue] errorMessage:[dic objectForKey:@"message"]]];
                }];
            }
        } else {
            [[self activeDelegate] didNotUpdateUserMuteWithError:tokenError];
        }
    }];
}
@end
