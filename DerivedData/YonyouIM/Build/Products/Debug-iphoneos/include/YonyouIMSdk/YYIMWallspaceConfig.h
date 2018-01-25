//
//  YYIMWallspaceConfig.h
//  YonyouIMSdk
//
//  Created by litfb on 15/9/15.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYIMWallspaceConfig : NSObject

+ (instancetype)sharedInstance;

/**
 *  圈子服务地址
 *
 *  @return 圈子服务地址
 */
- (NSString *)getWallspaceServer;

/**
 *  圈子服务地址
 *
 *  @param server 圈子服务地址
 */
- (void)setWallspaceServer:(NSString *)server;

/**
 *  圈子服务是否https
 *
 *  @return 圈子服务是否HTTPS
 */
- (BOOL)isWallspaceServerHTTPS;

/**
 *  设置圈子服务是否https
 *
 *  @param isHTTPS 圈子服务scheme
 */
- (void)setWallspaceServerHTTPS:(BOOL)isHTTPS;

// 查询圈子列表（用户已加入的圈子）
- (NSString *)getSurSpaceByUserServlet;
// 查询圈子列表（用户已加入的圈子）
- (void)setSurSpaceByUserServlet:(NSString *)servlet;

// 分页查询圈子列表（按圈子名称）
- (NSString *)getSpaceNameLikeServlet;
// 分页查询圈子列表（按圈子名称）
- (void)setSpaceNameLikeServlet:(NSString *)servlet;

// 分页查询圈子列表（按用户加入状态分类）
- (NSString *)getSpacePageServlet;
// 分页查询圈子列表（按用户加入状态分类）
- (void)setSpacePageServlet:(NSString *)servlet;

// 创建圈子
- (NSString *)getSpaceCreateServlet;
// 创建圈子
- (void)setSpaceCreateServlet:(NSString *)servlet;

// 修改圈子
- (NSString *)getSpaceModifyServlet;
// 修改圈子
- (void)setSpaceModifyServlet:(NSString *)servlet;

// 删除圈子
- (NSString *)getSpaceDeleteServlet;
// 删除圈子
- (void)setSpaceDeleteServlet:(NSString *)servlet;

// 用户加入圈子(开放型)
- (NSString *)getSurJoinServlet;
// 用户加入圈子(开放型)
- (void)setSurJoinServlet:(NSString *)servlet;

// 用户申请加入圈子(封闭型)
- (NSString *)getSurApplyServlet;
// 用户申请加入圈子(封闭型)
- (void)setSurApplyServlet:(NSString *)servlet;

// 批量将用户加入圈子(不区分圈子类型)
- (NSString *)getSurAdd4AdminServlet;
// 批量将用户加入圈子(不区分圈子类型)
- (void)setSurAdd4AdminServlet:(NSString *)servlet;

// 批量同意加入圈子申请
- (NSString *)getSuaAgreeApplyServlet;
// 批量同意加入圈子申请
- (void)setSuaAgreeApplyServlet:(NSString *)servlet;

// 批量拒绝加入圈子的申请
- (NSString *)getSuaDenyApplyServlet;
// 批量拒绝加入圈子的申请
- (void)setSuaDenyApplyServlet:(NSString *)servlet;

// 查询某圈子的全部未审批申请
- (NSString *)getSuaGetApplyListBySidServlet;
// 查询某圈子的全部未审批申请
- (void)setSuaGetApplyListBySidServlet:(NSString *)servlet;

// 查询某圈子的某个人的申请
- (NSString *)getSurOneApplyByIdServlet;
// 查询某圈子的某个人的申请
- (void)setSurOneApplyByIdServlet:(NSString *)servlet;

// 查询某管理员帐号管理的圈子的全部未审核加入申请
- (NSString *)getSuaGetApplyListByMangerServlet;
// 查询某管理员帐号管理的圈子的全部未审核加入申请
- (void)setSuaGetApplyListByMangerServlet:(NSString *)servlet;

// 查询圈子成员列表
- (NSString *)getSurUsersBySpaceServlet;
// 查询圈子成员列表
- (void)setSurUsersBySpaceServlet:(NSString *)servlet;

// 退出圈子
- (NSString *)getSurRemoveServlet;
// 退出圈子
- (void)setSurRemoveServlet:(NSString *)servlet;

// 发动态
- (NSString *)getPostPublishServlet;
// 发动态
- (void)setPostPublishServlet:(NSString *)servlet;

// 删除发言
- (NSString *)getPostDelpostServlet;
// 删除发言
- (void)setPostDelpostServlet:(NSString *)servlet;

// 修改发言
- (NSString *)getPostUpdateServlet;
// 修改发言
- (void)setPostUpdateServlet:(NSString *)servlet;

// 回复文字
- (NSString *)getReplyReplyServlet;
// 回复文字
- (void)setReplyReplyServlet:(NSString *)servlet;

// 点赞
- (NSString *)getReplyPraiseServlet;
// 点赞
- (void)setReplyPraiseServlet:(NSString *)servlet;

// 取消点赞
- (NSString *)getReplyCancelPraiseServlet;
// 取消点赞
- (void)setReplyCancelPraiseServlet:(NSString *)servlet;

// 回复数量统计
- (NSString *)getReplyReplyCountServlet;
// 回复数量统计
- (void)setReplyReplyCountServlet:(NSString *)servlet;

// 点赞数量统计
- (NSString *)getReplyPraiseCountServlet;
// 点赞数量统计
- (void)setReplyPraiseCountServlet:(NSString *)servlet;

// 删除发言回复
- (NSString *)getReplyRemoveReplyServlet;
// 删除发言回复
- (void)setReplyRemoveReplyServlet:(NSString *)servlet;

// 取得动态列表(根据页码查询)
- (NSString *)getDynamicPostListServlet;
// 取得动态列表(根据页码查询)
- (void)setDynamicPostListServlet:(NSString *)servlet;

// 取得动态列表(根据时间戳查询)
- (NSString *)getDynamicPostListByTSServlet;
// 取得动态列表(根据时间戳查询)
- (void)setDynamicPostListByTSServlet:(NSString *)servlet;

// 获取与我相关未读动态
- (NSString *)getDynamicRelateToMeServlet;
// 获取与我相关未读动态
- (void)setDynamicRelateToMeServlet:(NSString *)servlet;

// 根据通知消息获取一条动态
- (NSString *)getDynamicOneNewDynamicServlet;
// 根据通知消息获取一条动态
- (void)setDynamicOneNewDynamicServlet:(NSString *)servlet;

// 查询圈子动态是否有更新
- (NSString *)getDynamicIfUpdatedServlet;
// 查询圈子动态是否有更新
- (void)setDynamicIfUpdatedServlet:(NSString *)servlet;

// 搜索用户
- (NSString *)getUtilSearchUserServlet;
// 搜索用户
- (void)setUtilSearchUserServlet:(NSString *)servlet;

// 取得通知列表
- (NSString *)getWsNotifyNotifyListServlet;
// 取得通知列表
- (void)setWsNotifyNotifyListServlet:(NSString *)servlet;

@end
