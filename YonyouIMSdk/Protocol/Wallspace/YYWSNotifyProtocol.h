//
//  YYWSNotifyProtocol.h
//  YonyouIMSdk
//
//  Created by litfb on 15/10/26.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSNotifyProtocol <NSObject>

/**
 *  取得通知列表
 *
 *  @param param param 参数from html
 *  @"https://im.yyuap.com/sysadmin/plugins/friends/wsNotify/notifyList"
 */
- (void)getNotifyListWithParam:(NSString *)param;

@end
