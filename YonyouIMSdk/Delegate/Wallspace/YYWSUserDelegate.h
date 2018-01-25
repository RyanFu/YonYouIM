//
//  YYWSUserDelegate.h
//  YonyouIMSdk
//
//  Created by litfb on 15/8/20.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYWSUserDelegate <NSObject>

@optional

/**
 *  查询User成功
 *
 *  @param result 结果
 */
- (void)didSearchUser:(NSString *)result;

/**
 *  查询User失败
 *
 *  @param error 错误
 */
- (void)didNotSearchUserWithError:(NSError *)error;

@end
