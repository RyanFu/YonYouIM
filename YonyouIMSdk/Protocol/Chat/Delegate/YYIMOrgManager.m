//
//  YYIMOrgManager.m
//  YonyouIMSdk
//
//  Created by litfb on 15/6/24.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYIMOrgManager.h"
#import "JUMPFramework.h"
#import "YYIMOrgDBHelper.h"
#import "YYOrgEntity.h"
#import "YYIMJUMPHelper.h"
#import "YYIMStringUtility.h"
#import "YYIMLogger.h"

@interface YYIMOrgManager ()<JUMPStreamDelegate>

@property BOOL enable;

@end

@implementation YYIMOrgManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark org protocol

- (void)setOrgEnable:(BOOL)enable {
    self.enable = enable;
}

- (YYOrg *)getRootOrg {
    if (!self.enable) {
        return nil;
    }
    
    return [[YYIMOrgDBHelper sharedInstance] getRootOrg];
}

- (YYOrg *)getOrgWithParentId:(NSString *)parentId {
    if (!self.enable) {
        return nil;
    }
    
    return [[YYIMOrgDBHelper sharedInstance] getOrgWithParentId:parentId];
}

- (void)loadOrgWithParentId:(NSString *)parentId {
    if (!self.enable) {
        return;
    }
    
    if ([YYIMStringUtility isEmpty:parentId]) {
        [[self activeDelegate] didReceiveOrgWithParentId:parentId org:nil];
        return;
    }
    
    // JUMPIQ
    NSString *packetId = [JUMPStream generateJUMPID];
    JUMPIQ *iq = [JUMPIQ iqWithOpData:JUMP_OPDATA(JUMPOrgItemsRequestPacketOpCode) packetID:packetId];
    [iq setObject:parentId forKey:@"parentId"];
    
    [[self tracker] addID:packetId
                   target:self
                 selector:@selector(handleGetOrgResponse:withInfo:)
                  timeout:30];
    // 发包
    [[self activeStream] sendPacket:iq];
    
}

#pragma mark jump delegate

- (BOOL)jumpStream:(JUMPStream *)sender didReceiveIQ:(JUMPIQ *)iq {
    return [[self tracker] invokeForID:[iq packetID] withObject:iq];
}

- (void)jumpStream:(JUMPStream *)sender didFailToSendIQ:(JUMPIQ *)iq error:(NSError *)error {
    if ([iq packetID]) {
        [[self tracker] invokeForID:[iq packetID] withObject:nil];
    }
}

#pragma mark private func

//org(opcode:0x2261):
//{
//    "id":"yf3o6o5sfxp0e8axeja9",
//    "parentId":"sfxp0e8a1sxe9",//1有特殊含义，表示请求根节点
//    "orgItems":[{
//        "orgId":"yf3o6o5sfxp0e8axeja9",
//        "name":"用友集团",
//        "isLeaf":true //表示叶子节点，即无下属组织，但是不表示没有用户
//    }],
//    "userItems":[{
//        "jid":"wangxin0@yonyou.com",
//        "name":"张新"
//        ""
//    }]
//}
- (void)handleGetOrgResponse:(JUMPIQ *)jumpIQ withInfo:(id <JUMPTrackingInfo>)info {
    if (!jumpIQ) {
        YYIMLogError(@"didNotReceiveOrgWithParentId");
        [[self activeDelegate] didNotReceiveOrgWithParentId:nil error:nil];
        return;
    }
    if (![jumpIQ checkOpData:JUMP_OPDATA(JUMPOrgItemsResultPacketOpCode)]) {
        YYIMLogError(@"didNotReceiveOrgWithParentId:%@-%@", [jumpIQ headerData], [jumpIQ jsonString]);
        [[self activeDelegate] didNotReceiveOrgWithParentId:nil error:nil];
        return;
    }
    
    NSArray *orgItems = [jumpIQ objectForKey:@"orgItems"];
    NSArray *userItems = [jumpIQ objectForKey:@"userItems"];
    
    NSString *parentId = [jumpIQ objectForKey:@"parentId"];
    NSString *parentName = [jumpIQ objectForKey:@"parentName"];
    
    if (![YYIMStringUtility isEmpty:parentName]) {
        YYOrgEntity *orgEntity = [[YYOrgEntity alloc] init];
        [orgEntity setParentId:@"root"];
        [orgEntity setOrgId:parentId];
        [orgEntity setOrgName:parentName];
        [orgEntity setIsLeaf:NO];
        [orgEntity setIsUser:NO];
        [[YYIMOrgDBHelper sharedInstance] batchUpdateOrgWithParentId:@"root" orgItems:[NSArray arrayWithObject:orgEntity]];
    }
    
    if ((!orgItems || [orgItems count] <= 0) && (!userItems || [userItems count] <= 0)) {
        [[self activeDelegate] didReceiveOrgWithParentId:parentId org:nil];
    }
    
    NSMutableArray *orgArray = [NSMutableArray array];
    for (NSDictionary *item in orgItems) {
        YYOrgEntity *orgEntity = [[YYOrgEntity alloc] init];
        [orgEntity setParentId:[jumpIQ objectForKey:@"parentId"]];
        [orgEntity setOrgId:[item objectForKey:@"orgId"]];
        [orgEntity setOrgName:[item objectForKey:@"name"]];
        [orgEntity setIsLeaf:[[item objectForKey:@"isLeaf"] boolValue]];
        [orgEntity setIsUser:NO];
        [orgArray addObject:orgEntity];
    }
    
    for (NSDictionary *item in userItems) {
        YYOrgEntity *orgEntity = [[YYOrgEntity alloc] init];
        [orgEntity setParentId:[jumpIQ objectForKey:@"parentId"]];
        [orgEntity setOrgId:[YYIMJUMPHelper parseUser:[item objectForKey:@"jid"]]];
        [orgEntity setOrgName:[item objectForKey:@"name"]];
        [orgEntity setIsLeaf:YES];
        [orgEntity setIsUser:YES];
        [orgEntity setUserEmail:[item objectForKey:@"email"]];
        [orgEntity setUserPhoto:[item objectForKey:@"photo"]];
        [orgArray addObject:orgEntity];
    }
    [[YYIMOrgDBHelper sharedInstance] batchUpdateOrgWithParentId:parentId orgItems:orgArray];
    
    YYOrg *org = [[YYIMOrgDBHelper sharedInstance] getOrgWithParentId:parentId];
    [[self activeDelegate] didReceiveOrgWithParentId:parentId org:org];
}

@end
