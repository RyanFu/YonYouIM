//
//  YYMessage+IUM.m
//  YYCulture
//
//  Created by Chenly on 2017/6/12.
//  Copyright © 2017年 Yonyou. All rights reserved.
//

#import "YYMessage+Extend.h"
#import "YYIMChatHeader.h"
#import "YYIMDateParser.h"

@implementation YYMessage (Extend)

- (id)conciseContent {
    
    id content = nil;
    switch (self.type) {
        case YM_MESSAGE_CONTENT_TEXT: {
            if (self.message) {
                NSData *data = [self.message dataUsingEncoding:NSUTF8StringEncoding];
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                content = json[@"content"];
            }
            break;
        }
        case YM_MESSAGE_CONTENT_FILE:
            // TODO: 文件
            if (self.message) {
                NSData *data = [self.message dataUsingEncoding:NSUTF8StringEncoding];
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                content = json[@"content"];
            }
            break;
        case YM_MESSAGE_CONTENT_IMAGE:
            content = [self getResLocal] ?: [self getResThumbLocal];
            break;
        case YM_MESSAGE_CONTENT_MICROVIDEO:
            // TODO: 小视频
            break;
        case YM_MESSAGE_CONTENT_REVOKE: {
            
            NSString *userName;
            if (self.direction == YM_MESSAGE_DIRECTION_SEND) {
                userName = @"你";
            }
            else {
                YYUser *user = [[YYIMChat sharedInstance].chatManager getUserWithId:self.rosterId];
                userName = user.userName;
            }
            content = [NSString stringWithFormat:@"%@撤回了一条消息", userName];
            break;
        }
        case YM_MESSAGE_CONTENT_AUDIO:
            content = [self getResLocal];
            break;
        case YM_MESSAGE_CONTENT_PROMPT:
            content = [self getPromptMessageContent];
            break;
        case YM_MESSAGE_CONTENT_LOCATION:
            content = [self getResLocal];
            break;
        case YM_MESSAGE_CONTENT_AI:
            if (self.message) {
                NSData *data = [self.message dataUsingEncoding:NSUTF8StringEncoding];
                content = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            }
            break;
        default: {
            content = self.message;
            break;
        }
    }
    return content;
}

- (NSString *)getPromptMessageContent {
    
    NSData *data = [self.message dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (json) {
        NSDictionary *content = json[@"content"];
        NSString *messageContent = nil;
        NSString *promptType = content[@"promptType"];
        if ([promptType isEqualToString:@"accept_roster"]) {
            // 同意好友
            NSString *userName = [self userNameForPrompt:[self rosterId]];
            if (userName) {
                messageContent = [NSString stringWithFormat:@"你已添加了%@，现在可以开始聊天了", userName];
            }
        }
        else if ([promptType isEqualToString:@"create"] || [promptType isEqualToString:@"invite"]) {
            // 创建群组 || 邀请
            NSString *operator = content[@"operator"];
            NSString *operatorName = [self userNameForPrompt:operator];
            NSArray *operhand = content[@"operhand"];
            NSMutableArray *operhandNameArray = [NSMutableArray array];
            for (NSString *userId in operhand) {
                NSString *operhandName = [self userNameForPrompt:userId];
                if (operhandName) {
                    [operhandNameArray addObject:operhandName];
                }
            }
            NSMutableString *str = [NSMutableString string];
            if (operatorName) {
                [str appendString:operatorName];
            }
            if (operhandNameArray.count == 0) {
                [str appendString:@"创建了群组"];
            }
            else {
                [str appendString:@"邀请"];
                [str appendString:[operhandNameArray componentsJoinedByString:@"、"]];
                [str appendString:@"加入了群组"];
            }
            messageContent = str;
        }
        else if ([promptType isEqualToString:@"modify"]) {
            // 改名
            NSMutableString *str = [NSMutableString string];
            
            NSString *operator = content[@"operator"];
            NSString *operatorName = [self userNameForPrompt:operator];
            if (operatorName) {
                [str appendString:operatorName];
            }
            [str appendString:@"将群名称修改为"];
            [str appendString:content[@"operhand"]];
            messageContent = str;
        }
        else if ([promptType isEqualToString:@"kickmember"]) {
            // 踢人
            NSMutableString *str = [NSMutableString string];
            
            NSString *operator = content[@"operator"];
            NSString *operatorName = [self userNameForPrompt:operator];
            if (operatorName) {
                [str appendString:operatorName];
                [str appendString:@"将"];
            }
            NSArray *operhand = content[@"operhand"];
            NSMutableArray *operhandNameArray = [NSMutableArray array];
            for (NSString *userId in operhand) {
                NSString *operhandName = [self userNameForPrompt:userId];
                if (operhandName) {
                    [operhandNameArray addObject:operhandName];
                }
            }
            [str appendString:[operhandNameArray componentsJoinedByString:@"、"]];
            [str appendString:@"踢出了房间"];
            messageContent = str;
        }
        else if ([promptType isEqualToString:@"exit"]) {
            // 退群
            NSMutableString *str = [NSMutableString string];
            
            NSString *operator = content[@"operator"];
            NSString *operatorName = [self userNameForPrompt:operator];
            if (operatorName) {
                [str appendString:operatorName];
            } else {
                [str appendString:@"一位用户"];
            }
            [str appendString:@"退出了群组"];
            messageContent = str;
        }
        else if ([promptType isEqualToString:@"join"]) {
            // 加入
            NSMutableString *str = [NSMutableString string];
            
            NSString *operator = content[@"operator"];
            NSString *operatorName = [self userNameForPrompt:operator];
            if (operatorName) {
                [str appendString:operatorName];
            } else {
                [str appendString:@"一位用户"];
            }
            [str appendString:@"加入了群组"];
            messageContent = str;
        }
        else {
            messageContent = content[@"message"];
        }
        return messageContent;
    }
    else {
        return self.message;
    }
}

- (NSString *)userNameForPrompt:(NSString *)userId {
    
    NSString *name = @"";
    if ([userId isEqualToString:[[YYIMConfig sharedInstance] getUser]]) {
        name = @"你";
    } else {
        YYUser *user = [[YYIMChat sharedInstance].chatManager getUserWithId:userId];
        if (user) {
            name = [user userName];
        }
    }
    return name;
}

- (NSDictionary *)messageForJavascript {
    
    YYIMChatManager *chatManager = [YYIMChat sharedInstance].chatManager;
    id<YYObjExtProtocol> ext = nil;
    if ([YM_MESSAGE_TYPE_CHAT isEqualToString:[self chatType]]) {
        [self setRoster:[chatManager getRosterWithId:[self rosterId]]];
        [self setUser:[chatManager getUserWithId:[self rosterId]]];
        ext = [chatManager getUserExtWithId:[self rosterId]];
    }
    else if ([YM_MESSAGE_TYPE_GROUPCHAT isEqualToString:[self chatType]]) {
        NSString *groupId = [self direction] == YM_MESSAGE_DIRECTION_RECEIVE ? [self fromId] : [self toId];
        NSString *userId = [self direction] == YM_MESSAGE_DIRECTION_SEND ? [self fromId] : [self rosterId];
        [self setGroup:[chatManager getChatGroupWithGroupId:groupId]];
        [self setRoster:[chatManager getRosterWithId:[self rosterId]]];
        [self setUser:[chatManager getUserWithId:userId]];
        ext = [chatManager getChatGroupExtWithId:groupId];
        if (self.user == nil) {
            return nil;
        }
    }
    else if ([YM_MESSAGE_TYPE_PUBACCOUNT isEqualToString:[self chatType]]) {
        [self setAccount:[chatManager getPubAccountWithAccountId:[self rosterId]]];
        ext = [chatManager getPubAccountExtWithId:[self rosterId]];
    }
    
    NSString *type = self.chatType;
    NSString *date = [[YYIMDateParser parser] dateStringWithMessageDate:self.date];
    
    NSInteger newCount = 0;
    if ([self isKindOfClass:[YYRecentMessage class]]) {
        newCount = ((YYRecentMessage *)self).newMessageCount;
    }
    
    self.content = [self getMessageContent];
    NSString *message = (self.keyInfo && self.keyInfo.length > 0) ? self.keyInfo : self.content.message;
    switch (self.type) {
        case YM_MESSAGE_CONTENT_FILE:
            message = @"【文件】";
            break;
        case YM_MESSAGE_CONTENT_IMAGE:
            message = @"【图片】";
            break;
        case YM_MESSAGE_CONTENT_MICROVIDEO:
            message = @"【小视频】";
            break;
        case YM_MESSAGE_CONTENT_AUDIO:
            message = @"【语音】";
            break;
        case YM_MESSAGE_CONTENT_REVOKE:
        case YM_MESSAGE_CONTENT_PROMPT:
            message = self.conciseContent;
            break;
        default:
            break;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = type;
    dic[@"date"] = date;
    dic[@"newCount"] = @(newCount);
    if (self.content) {
        dic[@"extend"] = self.content.extendValue;
    }
    if (self.user == nil && ![self.chatType isEqualToString:YM_MESSAGE_TYPE_PUBACCOUNT]) {
        NSString *userid = self.rosterId.length > 0 ? self.rosterId : self.fromId;
        self.user = [chatManager getUserWithId:userid];
        
    }
    if ([self.chatType isEqualToString:YM_MESSAGE_TYPE_CHAT]) {
        
        if ([self.rosterId isEqualToString:@"admin"]) {
            dic[@"chat"] = @{ @"chatID": @"admin", @"userName": @"系统通知"};
        }
        if (self.user) {
            NSMutableDictionary *chat = [NSMutableDictionary dictionary];
            chat[@"chatID"]    = self.user.userId;
            chat[@"userName"]  = self.user.userName;
            chat[@"userPhoto"] = self.user.userPhoto;
            dic[@"chat"] = chat;
        }
    }
    else if ([self.chatType isEqualToString:YM_MESSAGE_TYPE_GROUPCHAT]) {
        
        NSString *groupName = self.group.groupName;
        groupName = groupName.length > 0 ? groupName : @"群聊";
        if (self.type != YM_MESSAGE_CONTENT_REVOKE && self.type !=  YM_MESSAGE_CONTENT_PROMPT) {
            message = [NSString stringWithFormat:@"%@: %@", self.user.userName, message];
        }
        
        if (self.group) {
            NSMutableDictionary *chat = [NSMutableDictionary dictionary];
            chat[@"chatID"]    = self.group.groupId;
            chat[@"groupName"] = groupName;
            chat[@"userName"]  = self.user.userName;
            dic[@"chat"] = chat;
        }
        NSMutableArray *members = [NSMutableArray array];
        NSArray *yyMembers = [chatManager getGroupMembersWithGroupId:self.group.groupId limit:4];
        for (YYChatGroupMember *yyMember in yyMembers) {
            NSMutableDictionary *member = [NSMutableDictionary dictionary];
            member[@"name"]  = yyMember.memberName;
            member[@"photo"] = yyMember.memberPhoto;
            [members addObject:member];
        }
        dic[@"members"] = members;
    }
    else if ([self.chatType isEqualToString:YM_MESSAGE_TYPE_PUBACCOUNT]) {
        
        NSMutableDictionary *account = [NSMutableDictionary dictionary];
        account[@"accountID"]    = self.account.accountId;
        account[@"accountName"]  = self.account.accountName;
        account[@"accountPhoto"] = self.account.accountPhoto;
        dic[@"account"] = account;
    }
    dic[@"noDisturb"] = ext.noDisturb ? @"true": @"false";
    dic[@"isTop"]     = ext.stickTop ? @"true": @"false";
    dic[@"extend"]    = self.content.extendValue;
    dic[@"message"]   = message;
    
    return dic;
}

- (NSInteger)displayState {
    
    NSInteger state = YM_MESSAGE_DISPLAY_STATE_NORMAL;
    
    if (self.status == YM_MESSAGE_STATE_FAILD) {
        // 失败
        return YM_MESSAGE_DISPLAY_STATE_FAILED;
    }
    if (self.status == YM_MESSAGE_DISPLAY_STATE_NORMAL && (self.uploadStatus == YM_MESSAGE_UPLOADSTATE_ING || self.downloadStatus == YM_MESSAGE_DOWNLOADSTATE_ING)) {
        // 加载中
        return YM_MESSAGE_DISPLAY_STATE_LOADING;
    }
    if (self.type == YM_MESSAGE_CONTENT_AUDIO &&
        self.direction == YM_MESSAGE_DIRECTION_RECEIVE &&
        self.specificStatus != YM_MESSAGE_SPECIFIC_AUDIO_READ) {
        // 语音未读
        return YM_MESSAGE_DISPLAY_STATE_AUDIO_UNREAD;
    }
    
    if (self.direction == YM_MESSAGE_DIRECTION_SEND &&
        [self.chatType isEqualToString:YM_MESSAGE_TYPE_CHAT]) {
        
        if (self.status == YM_MESSAGE_STATE_DELIVERED) {
            state = YM_MESSAGE_DISPLAY_STATE_READED;
        }
        else if (self.status >= YM_MESSAGE_STATE_SENT_OR_READ) {
            state = YM_MESSAGE_DISPLAY_STATE_UNREAD;
        }
    }
    return state;
}

// 完整性验证
- (BOOL)isIntegrated {
    
    NSDictionary *messageDic = [self messageForJavascript];
    if (messageDic == nil) {
        return NO;
    }
    
    if ([self.chatType isEqualToString:YM_MESSAGE_TYPE_CHAT]) {
        
        if ([messageDic valueForKeyPath:@"chat.userName"] == nil) {
            return NO;
        }
    }
    else if ([self.chatType isEqualToString:YM_MESSAGE_TYPE_GROUPCHAT]) {
        
        if ([messageDic valueForKeyPath:@"chat.userName"] == nil ||
            [messageDic valueForKeyPath:@"chat.groupName"] == nil ||
            [[messageDic valueForKeyPath:@"members"] count] == 0) {
            return NO;
        }
    }
    else if ([self.chatType isEqualToString:YM_MESSAGE_TYPE_PUBACCOUNT]) {
        if ([messageDic valueForKeyPath:@"account.accountName"] == nil) {
            return NO;
        }
    }
    return YES;
}

- (YYMessage *)aiMessage {
    
    if (self.type == YM_MESSAGE_CONTENT_TEXT) {
        NSString *extendStr = [[self getMessageContent] extendValue];
        if (extendStr == nil) {
            return nil;
        }
        NSDictionary *extendDic = [NSJSONSerialization JSONObjectWithData:[extendStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        NSString *aiResult = extendDic[@"intelligentAnalysisResult"];
        if (aiResult) {
            NSDictionary *aiResultDic = [NSJSONSerialization JSONObjectWithData:[aiResult dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            NSString *conciseValue = [aiResultDic valueForKeyPath:@"response.botResponse.text"];
            NSDictionary *conciseDic = [NSJSONSerialization JSONObjectWithData:[conciseValue dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            NSString *appid = conciseDic[@"appid"];
            NSString *title = conciseDic[@"title"];
            if (([appid isKindOfClass:[NSString class]] && appid.length > 0) &&
                ([title isKindOfClass:[NSString class]] && title.length > 0)) {
                
                YYMessage *message = [[YYMessage alloc] init];
                message.message = conciseValue;
                message.type = YM_MESSAGE_CONTENT_AI;
                message.status = YM_MESSAGE_STATE_SENT_OR_READ;
                return message;
            }
        }
    }
    return nil;
}

@end
