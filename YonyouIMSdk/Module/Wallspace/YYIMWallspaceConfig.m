//
//  YYIMWallspaceConfig.m
//  YonyouIMSdk
//
//  Created by litfb on 15/9/15.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import "YYIMWallspaceConfig.h"

#define YYIM_WALLSPACE_SERVER                       @"YYIM_WALLSPACE_SERVER"
#define YYIM_WALLSPACE_SERVER_HTTPS                 @"YYIM_WALLSPACE_SERVER_HTTPS"

#define YW_SUR_SPACEBYUSER_SERVLET                  @"YW_SUR_SPACEBYUSER_SERVLET"
#define YW_SPACE_NAMELIKE_SERVLET                   @"YW_SPACE_NAMELIKE_SERVLET"
#define YW_SPACE_PAGE_SERVLET                       @"YW_SPACE_PAGE_SERVLET"
#define YW_SPACE_CREATE_SERVLET                     @"YW_SPACE_CREATE_SERVLET"
#define YW_SPACE_MODIFY_SERVLET                     @"YW_SPACE_MODIFY_SERVLET"
#define YW_SPACE_DELETE_SERVLET                     @"YW_SPACE_DELETE_SERVLET"
#define YW_SUR_JOIN_SERVLET                         @"YW_SUR_JOIN_SERVLET"
#define YW_SUR_APPLY_SERVLET                        @"YW_SUR_APPLY_SERVLET"
#define YW_SUR_ADD4ADMIN_SERVLET                    @"YW_SUR_ADD4ADMIN_SERVLET"
#define YW_SUA_AGREEAPPLY_SERVLET                   @"YW_SUA_AGREEAPPLY_SERVLET"
#define YW_SUA_DENYAPPLY_SERVLET                    @"YW_SUA_DENYAPPLY_SERVLET"
#define YW_SUA_GETAPPLYLISTBYSID_SERVLET            @"YW_SUA_GETAPPLYLISTBYSID_SERVLET"
#define YW_SUR_ONEAPPLYBYID_SERVLET                 @"YW_SUR_ONEAPPLYBYID_SERVLET"
#define YW_SUA_GETAPPLYLISTBYMANGER_SERVLET         @"YW_SUA_GETAPPLYLISTBYMANGER_SERVLET"
#define YW_SUR_USERBYSPACE_SERVLET                  @"YW_SUR_USERBYSPACE_SERVLET"
#define YW_SUR_REMOVE_SERVLET                       @"YW_SUR_REMOVE_SERVLET"
#define YW_POST_PUBLISH_SERVLET                     @"YW_POST_PUBLISH_SERVLET"
#define YW_POST_DELPOST_SERVLET                     @"YW_POST_DELPOST_SERVLET"
#define YW_POST_UPDATE_SERVLET                      @"YW_POST_UPDATE_SERVLET"
#define YW_REPLY_REPLY_SERVLET                      @"YW_REPLY_REPLY_SERVLET"
#define YW_REPLY_PRAISE_SERVLET                     @"YW_REPLY_PRAISE_SERVLET"
#define YW_REPLY_CANCELPRAISE_SERVLET               @"YW_REPLY_CANCELPRAISE_SERVLET"
#define YW_REPLY_REPLYCOUNT_SERVLET                 @"YW_REPLY_REPLYCOUNT_SERVLET"
#define YW_REPLY_PRAISECOUNT_SERVLET                @"YW_REPLY_PRAISECOUNT_SERVLET"
#define YW_REPLY_REMOVEREPLY_SERVLET                @"YW_REPLY_REMOVEREPLY_SERVLET"
#define YW_DYNAMIC_POSTLIST_SERVLET                 @"YW_DYNAMIC_POSTLIST_SERVLET"
#define YW_DYNAMIC_POSTLISTBYTS_SERVLET             @"YW_DYNAMIC_POSTLISTBYTS_SERVLET"
#define YW_DYNAMIC_RELATETOME_SERVLET               @"YW_DYNAMIC_RELATETOME_SERVLET"
#define YW_DYNAMIC_ONENEWDYNAMIC_SERVLET            @"YW_DYNAMIC_ONENEWDYNAMIC_SERVLET"
#define YW_DYNAMIC_IFUPDATED_SERVLET                @"YW_DYNAMIC_IFUPDATED_SERVLET"
#define YW_UTIL_SEARCHUSER_SERVLET                  @"YW_UTIL_SEARCHUSER_SERVLET"
#define YW_WSNOTIFY_NOTIFYLIST_SERVLET              @"YW_WSNOTIFY_NOTIFYLIST_SERVLET"

/** 圈子服务地址 */
#define DEFAULT_YW_SERVER                           @"im.yyuap.com"
/** 圈子服务scheme */
#define DEFAULT_YW_SERVER_HTTPS                     YES

/** 查询圈子列表（用户已加入的圈子） */
#define DEFAULT_YW_SUR_SPACEBYUSER_SERVLET          @"{scheme}://{server}/sysadmin/plugins/friends/spaceUserRelation/spaceByUser"
/** 分页查询圈子列表（按圈子名称）*/
#define DEFAULT_YW_SPACE_NAMELIKE_SERVLET           @"{scheme}://{server}/sysadmin/plugins/friends/space/nameLike"
/** 分页查询圈子列表（按用户加入状态分类）*/
#define DEFAULT_YW_SPACE_PAGE_SERVLET               @"{scheme}://{server}/sysadmin/plugins/friends/space/page"
/** 创建圈子 */
#define DEFAULT_YW_SPACE_CREATE_SERVLET             @"{scheme}://{server}/sysadmin/plugins/friends/space/create"
/** 修改圈子 */
#define DEFAULT_YW_SPACE_MODIFY_SERVLET             @"{scheme}://{server}/sysadmin/plugins/friends/space/modify"
/** 删除圈子 */
#define DEFAULT_YW_SPACE_DELETE_SERVLET             @"{scheme}://{server}/sysadmin/plugins/friends/space/delete"
/** 用户加入圈子(开放型) */
#define DEFAULT_YW_SUR_JOIN_SERVLET                 @"{scheme}://{server}/sysadmin/plugins/friends/spaceUserRelation/join"
/** 用户申请加入圈子(封闭型) */
#define DEFAULT_YW_SUR_APPLY_SERVLET                @"{scheme}://{server}/sysadmin/plugins/friends/spaceUserRelation/apply"
/** 批量将用户加入圈子(不区分圈子类型) */
#define DEFAULT_YW_SUR_ADD4ADMIN_SERVLET            @"{scheme}://{server}/sysadmin/plugins/friends/spaceUserRelation/add4admin"
/** 批量同意加入圈子申请 */
#define DEFAULT_YW_SUA_AGREEAPPLY_SERVLET           @"{scheme}://{server}/sysadmin/plugins/friends/spaceUserAuth/agreeApply"
/** 批量拒绝加入圈子的申请 */
#define DEFAULT_YW_SUA_DENYAPPLY_SERVLET            @"{scheme}://{server}/sysadmin/plugins/friends/spaceUserAuth/denyApply"
/** 查询某圈子的全部未审批申请 */
#define DEFAULT_YW_SUA_GETAPPLYLISTBYSID_SERVLET    @"{scheme}://{server}/sysadmin/plugins/friends/spaceUserAuth/getApplyListBySid"
/** 查询某圈子的某个人的申请 */
#define DEFAULT_YW_SUR_ONEAPPLYBYID_SERVLET         @"{scheme}://{server}/sysadmin/plugins/friends/spaceUserRelation/oneApplyById"
/** 查询某管理员帐号管理的圈子的全部未审核加入申请 */
#define DEFAULT_YW_SUA_GETAPPLYLISTBYMANGER_SERVLET @"{scheme}://{server}/sysadmin/plugins/friends/spaceUserAuth/getApplyListByManger"
/** 查询圈子成员列表 */
#define DEFAULT_YW_SUR_USERBYSPACE_SERVLET          @"{scheme}://{server}/sysadmin/plugins/friends/spaceUserRelation/usersBySpace"
/** 退出圈子 */
#define DEFAULT_YW_SUR_REMOVE_SERVLET               @"{scheme}://{server}/sysadmin/plugins/friends/spaceUserRelation/remove"
/** 发动态 */
#define DEFAULT_YW_POST_PUBLISH_SERVLET             @"{scheme}://{server}/sysadmin/plugins/friends/post/publish"
/** 删除发言 */
#define DEFAULT_YW_POST_DELPOST_SERVLET             @"{scheme}://{server}/sysadmin/plugins/friends/post/wallspace/delpost"
/** 修改发言 */
#define DEFAULT_YW_POST_UPDATE_SERVLET              @"{scheme}://{server}/sysadmin/plugins/friends/post/update"
/** 回复文字 */
#define DEFAULT_YW_REPLY_REPLY_SERVLET              @"{scheme}://{server}/sysadmin/plugins/friends/reply/wallspace/reply"
/** 点赞 */
#define DEFAULT_YW_REPLY_PRAISE_SERVLET             @"{scheme}://{server}/sysadmin/plugins/friends/reply/wallspace/praise"
/** 取消点赞 */
#define DEFAULT_YW_REPLY_CANCELPRAISE_SERVLET       @"{scheme}://{server}/sysadmin/plugins/friends/reply/wallspace/cancelPraise"
/** 回复数量统计 */
#define DEFAULT_YW_REPLY_REPLYCOUNT_SERVLET         @"{scheme}://{server}/sysadmin/plugins/friends/reply/wallspace/replyCount"
/** 点赞数量统计 */
#define DEFAULT_YW_REPLY_PRAISECOUNT_SERVLET        @"{scheme}://{server}/sysadmin/plugins/friends/reply/wallspace/praiseCount"
/** 删除发言回复 */
#define DEFAULT_YW_REPLY_REMOVEREPLY_SERVLET        @"{scheme}://{server}/sysadmin/plugins/friends/reply/wallspace/removeReply"
/** 取得动态列表(根据页码查询) */
#define DEFAULT_YW_DYNAMIC_POSTLIST_SERVLET         @"{scheme}://{server}/sysadmin/plugins/friends/dynamic/wallspace/postList"
/** 取得动态列表(根据时间戳查询) */
#define DEFAULT_YW_DYNAMIC_POSTLISTBYTS_SERVLET     @"{scheme}://{server}/sysadmin/plugins/friends/dynamic/wallspace/postListByTS"
/** 获取与我相关未读动态 */
#define DEFAULT_YW_DYNAMIC_RELATETOME_SERVLET       @"{scheme}://{server}/sysadmin/plugins/friends/dynamic/wallspace/relateToMe"
/** 根据通知消息获取一条动态 */
#define DEFAULT_YW_DYNAMIC_ONENEWDYNAMIC_SERVLET    @"{scheme}://{server}/sysadmin/plugins/friends/dynamic/wallspace/oneNewDynamic"
/** 查询圈子动态是否有更新 */
#define DEFAULT_YW_DYNAMIC_IFUPDATED_SERVLET        @"{scheme}://{server}/sysadmin/plugins/friends/dynamic/wallspace/ifUpdated"
/** 搜索用户 */
#define DEFAULT_YW_UTIL_SEARCHUSER_SERVLET          @"{scheme}://{server}/sysadmin/plugins/friends/util/searchUser"
/** 取得通知列表 */
#define DEFAULT_YW_WSNOTIFY_NOTIFYLIST_SERVLET      @"{scheme}://{server}/sysadmin/plugins/friends/wsNotify/notifyList"

@implementation YYIMWallspaceConfig

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
        [self setWallspaceServer:DEFAULT_YW_SERVER];
        [self setWallspaceServerHTTPS:DEFAULT_YW_SERVER_HTTPS];
        
        [self setSurSpaceByUserServlet:DEFAULT_YW_SUR_SPACEBYUSER_SERVLET];
        [self setSpaceNameLikeServlet:DEFAULT_YW_SPACE_NAMELIKE_SERVLET];
        [self setSpacePageServlet:DEFAULT_YW_SPACE_PAGE_SERVLET];
        [self setSpaceCreateServlet:DEFAULT_YW_SPACE_CREATE_SERVLET];
        [self setSpaceModifyServlet:DEFAULT_YW_SPACE_MODIFY_SERVLET];
        [self setSpaceDeleteServlet:DEFAULT_YW_SPACE_DELETE_SERVLET];
        [self setSurJoinServlet:DEFAULT_YW_SUR_JOIN_SERVLET];
        [self setSurApplyServlet:DEFAULT_YW_SUR_APPLY_SERVLET];
        [self setSurAdd4AdminServlet:DEFAULT_YW_SUR_ADD4ADMIN_SERVLET];
        [self setSuaAgreeApplyServlet:DEFAULT_YW_SUA_AGREEAPPLY_SERVLET];
        [self setSuaDenyApplyServlet:DEFAULT_YW_SUA_DENYAPPLY_SERVLET];
        [self setSuaGetApplyListBySidServlet:DEFAULT_YW_SUA_GETAPPLYLISTBYSID_SERVLET];
        [self setSurOneApplyByIdServlet:DEFAULT_YW_SUR_ONEAPPLYBYID_SERVLET];
        [self setSuaGetApplyListByMangerServlet:DEFAULT_YW_SUA_GETAPPLYLISTBYMANGER_SERVLET];
        [self setSurUsersBySpaceServlet:DEFAULT_YW_SUR_USERBYSPACE_SERVLET];
        [self setSurRemoveServlet:DEFAULT_YW_SUR_REMOVE_SERVLET];
        [self setPostPublishServlet:DEFAULT_YW_POST_PUBLISH_SERVLET];
        [self setPostDelpostServlet:DEFAULT_YW_POST_DELPOST_SERVLET];
        [self setPostUpdateServlet:DEFAULT_YW_POST_UPDATE_SERVLET];
        [self setReplyReplyServlet:DEFAULT_YW_REPLY_REPLY_SERVLET];
        [self setReplyPraiseServlet:DEFAULT_YW_REPLY_PRAISE_SERVLET];
        [self setReplyCancelPraiseServlet:DEFAULT_YW_REPLY_CANCELPRAISE_SERVLET];
        [self setReplyReplyCountServlet:DEFAULT_YW_REPLY_REPLYCOUNT_SERVLET];
        [self setReplyPraiseCountServlet:DEFAULT_YW_REPLY_PRAISECOUNT_SERVLET];
        [self setReplyRemoveReplyServlet:DEFAULT_YW_REPLY_REMOVEREPLY_SERVLET];
        [self setDynamicPostListServlet:DEFAULT_YW_DYNAMIC_POSTLIST_SERVLET];
        [self setDynamicPostListByTSServlet:DEFAULT_YW_DYNAMIC_POSTLISTBYTS_SERVLET];
        [self setDynamicRelateToMeServlet:DEFAULT_YW_DYNAMIC_RELATETOME_SERVLET];
        [self setDynamicOneNewDynamicServlet:DEFAULT_YW_DYNAMIC_ONENEWDYNAMIC_SERVLET];
        [self setDynamicIfUpdatedServlet:DEFAULT_YW_DYNAMIC_IFUPDATED_SERVLET];
        [self setUtilSearchUserServlet:DEFAULT_YW_UTIL_SEARCHUSER_SERVLET];
        [self setWsNotifyNotifyListServlet:DEFAULT_YW_WSNOTIFY_NOTIFYLIST_SERVLET];
    }
    return self;
}

- (NSString *)getWallspaceServer {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:YYIM_WALLSPACE_SERVER];
}

- (void)setWallspaceServer:(NSString *)server {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:server forKey:YYIM_WALLSPACE_SERVER];
    [userDefaults synchronize];
}

- (BOOL)isWallspaceServerHTTPS {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:YYIM_WALLSPACE_SERVER_HTTPS];
}

- (void)setWallspaceServerHTTPS:(BOOL)isHTTPS {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isHTTPS forKey:YYIM_WALLSPACE_SERVER_HTTPS];
    [userDefaults synchronize];
}

- (NSString *)getWallspaceServerScheme {
    return [self isWallspaceServerHTTPS] ? @"https" : @"http";
}

// 查询圈子列表（用户已加入的圈子）
- (NSString *)getSurSpaceByUserServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SUR_SPACEBYUSER_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 查询圈子列表（用户已加入的圈子）
- (void)setSurSpaceByUserServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SUR_SPACEBYUSER_SERVLET];
    [userDefaults synchronize];
}

// 分页查询圈子列表（按圈子名称）
- (NSString *)getSpaceNameLikeServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SPACE_NAMELIKE_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 分页查询圈子列表（按圈子名称）
- (void)setSpaceNameLikeServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SPACE_NAMELIKE_SERVLET];
    [userDefaults synchronize];
}

// 分页查询圈子列表（按用户加入状态分类）
- (NSString *)getSpacePageServlet  {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SPACE_PAGE_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 分页查询圈子列表（按用户加入状态分类）
- (void)setSpacePageServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SPACE_PAGE_SERVLET];
    [userDefaults synchronize];
}

// 创建圈子
- (NSString *)getSpaceCreateServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SPACE_CREATE_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 创建圈子
- (void)setSpaceCreateServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SPACE_CREATE_SERVLET];
    [userDefaults synchronize];
}

// 修改圈子
- (NSString *)getSpaceModifyServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SPACE_MODIFY_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 修改圈子
- (void)setSpaceModifyServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SPACE_MODIFY_SERVLET];
    [userDefaults synchronize];
}

// 删除圈子
- (NSString *)getSpaceDeleteServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SPACE_DELETE_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 删除圈子
- (void)setSpaceDeleteServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SPACE_DELETE_SERVLET];
    [userDefaults synchronize];
}

// 用户加入圈子(开放型)
- (NSString *)getSurJoinServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SUR_JOIN_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 用户加入圈子(开放型)
- (void)setSurJoinServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SUR_JOIN_SERVLET];
    [userDefaults synchronize];
}

// 用户申请加入圈子(封闭型)
- (NSString *)getSurApplyServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SUR_APPLY_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 用户申请加入圈子(封闭型)
- (void)setSurApplyServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SUR_APPLY_SERVLET];
    [userDefaults synchronize];
}

// 批量将用户加入圈子(不区分圈子类型)
- (NSString *)getSurAdd4AdminServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SUR_ADD4ADMIN_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 批量将用户加入圈子(不区分圈子类型)
- (void)setSurAdd4AdminServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SUR_ADD4ADMIN_SERVLET];
    [userDefaults synchronize];
}

// 批量同意加入圈子申请
- (NSString *)getSuaAgreeApplyServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SUA_AGREEAPPLY_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 批量同意加入圈子申请
- (void)setSuaAgreeApplyServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SUA_AGREEAPPLY_SERVLET];
    [userDefaults synchronize];
}

// 批量拒绝加入圈子的申请
- (NSString *)getSuaDenyApplyServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SUA_DENYAPPLY_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 批量拒绝加入圈子的申请
- (void)setSuaDenyApplyServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SUA_DENYAPPLY_SERVLET];
    [userDefaults synchronize];
}

// 查询某圈子的全部未审批申请
- (NSString *)getSuaGetApplyListBySidServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SUA_GETAPPLYLISTBYSID_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 查询某圈子的全部未审批申请
- (void)setSuaGetApplyListBySidServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SUA_GETAPPLYLISTBYSID_SERVLET];
    [userDefaults synchronize];
}

// 查询某圈子的某个人的申请
- (NSString *)getSurOneApplyByIdServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SUR_ONEAPPLYBYID_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 查询某圈子的某个人的申请
- (void)setSurOneApplyByIdServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SUR_ONEAPPLYBYID_SERVLET];
    [userDefaults synchronize];
}

// 查询某管理员帐号管理的圈子的全部未审核加入申请
- (NSString *)getSuaGetApplyListByMangerServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SUA_GETAPPLYLISTBYMANGER_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 查询某管理员帐号管理的圈子的全部未审核加入申请
- (void)setSuaGetApplyListByMangerServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SUA_GETAPPLYLISTBYMANGER_SERVLET];
    [userDefaults synchronize];
}

// 查询圈子成员列表
- (NSString *)getSurUsersBySpaceServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SUR_USERBYSPACE_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 查询圈子成员列表
- (void)setSurUsersBySpaceServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SUR_USERBYSPACE_SERVLET];
    [userDefaults synchronize];
}

// 退出圈子
- (NSString *)getSurRemoveServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_SUR_REMOVE_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 退出圈子
- (void)setSurRemoveServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_SUR_REMOVE_SERVLET];
    [userDefaults synchronize];
}

// 发动态
- (NSString *)getPostPublishServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_POST_PUBLISH_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 发动态
- (void)setPostPublishServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_POST_PUBLISH_SERVLET];
    [userDefaults synchronize];
}

// 删除发言
- (NSString *)getPostDelpostServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_POST_DELPOST_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 删除发言
- (void)setPostDelpostServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_POST_DELPOST_SERVLET];
    [userDefaults synchronize];
}

// 修改发言
- (NSString *)getPostUpdateServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_POST_UPDATE_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 修改发言
- (void)setPostUpdateServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_POST_UPDATE_SERVLET];
    [userDefaults synchronize];
}

// 回复文字
- (NSString *)getReplyReplyServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_REPLY_REPLY_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 回复文字
- (void)setReplyReplyServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_REPLY_REPLY_SERVLET];
    [userDefaults synchronize];
}

// 点赞
- (NSString *)getReplyPraiseServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_REPLY_PRAISE_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 点赞
- (void)setReplyPraiseServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_REPLY_PRAISE_SERVLET];
    [userDefaults synchronize];
}

// 取消点赞
- (NSString *)getReplyCancelPraiseServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_REPLY_CANCELPRAISE_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 取消点赞
- (void)setReplyCancelPraiseServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_REPLY_CANCELPRAISE_SERVLET];
    [userDefaults synchronize];
}

// 回复数量统计
- (NSString *)getReplyReplyCountServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_REPLY_REPLYCOUNT_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 回复数量统计
- (void)setReplyReplyCountServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_REPLY_REPLYCOUNT_SERVLET];
    [userDefaults synchronize];
}

// 点赞数量统计
- (NSString *)getReplyPraiseCountServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_REPLY_PRAISECOUNT_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 点赞数量统计
- (void)setReplyPraiseCountServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_REPLY_PRAISECOUNT_SERVLET];
    [userDefaults synchronize];
}

// 删除发言回复
- (NSString *)getReplyRemoveReplyServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_REPLY_REMOVEREPLY_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 删除发言回复
- (void)setReplyRemoveReplyServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_REPLY_REMOVEREPLY_SERVLET];
    [userDefaults synchronize];
}

// 取得动态列表(根据页码查询)
- (NSString *)getDynamicPostListServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_DYNAMIC_POSTLIST_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 取得动态列表(根据页码查询)
- (void)setDynamicPostListServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_DYNAMIC_POSTLIST_SERVLET];
    [userDefaults synchronize];
}

// 取得动态列表(根据时间戳查询)
- (NSString *)getDynamicPostListByTSServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_DYNAMIC_POSTLISTBYTS_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 取得动态列表(根据时间戳查询)
- (void)setDynamicPostListByTSServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_DYNAMIC_POSTLISTBYTS_SERVLET];
    [userDefaults synchronize];
}

// 获取与我相关未读动态
- (NSString *)getDynamicRelateToMeServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_DYNAMIC_RELATETOME_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 获取与我相关未读动态
- (void)setDynamicRelateToMeServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_DYNAMIC_RELATETOME_SERVLET];
    [userDefaults synchronize];
}

// 根据通知消息获取一条动态
- (NSString *)getDynamicOneNewDynamicServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_DYNAMIC_ONENEWDYNAMIC_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 根据通知消息获取一条动态
- (void)setDynamicOneNewDynamicServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_DYNAMIC_ONENEWDYNAMIC_SERVLET];
    [userDefaults synchronize];
}

// 查询圈子动态是否有更新
- (NSString *)getDynamicIfUpdatedServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_DYNAMIC_IFUPDATED_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 查询圈子动态是否有更新
- (void)setDynamicIfUpdatedServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_DYNAMIC_IFUPDATED_SERVLET];
    [userDefaults synchronize];
}

// 搜索用户
- (NSString *)getUtilSearchUserServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_UTIL_SEARCHUSER_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 搜索用户
- (void)setUtilSearchUserServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_UTIL_SEARCHUSER_SERVLET];
    [userDefaults synchronize];
}

// 取得通知列表
- (NSString *)getWsNotifyNotifyListServlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *servlet = [userDefaults stringForKey:YW_WSNOTIFY_NOTIFYLIST_SERVLET];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{scheme}" withString:[self getWallspaceServerScheme]];
    servlet = [servlet stringByReplacingOccurrencesOfString:@"{server}" withString:[self getWallspaceServer]];
    return servlet;
}

// 取得通知列表
- (void)setWsNotifyNotifyListServlet:(NSString *)servlet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:servlet forKey:YW_WSNOTIFY_NOTIFYLIST_SERVLET];
    [userDefaults synchronize];
}

@end
