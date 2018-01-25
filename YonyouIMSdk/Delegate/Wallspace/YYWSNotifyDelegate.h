//
//  YYWSNotifyDelegate.h
//  YonyouIMSdk
//
//  Created by litfb on 15/10/26.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSNotifyDelegate <NSObject>

@optional

/**
 *  取得通知列表成功
 *
 *  @param result 结果
 */
- (void)didGetNotifyList:(NSString *)result;

/**
 *  取得通知列表失败
 *
 *  @param error 错误
 */
- (void)didNotGetNotifyListWithError:(NSError *)error;

@end
