//
//  ChangeMemberViewController.h
//  YonyouIM
//
//  Created by hb on 2017/9/7.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "YYIMBaseViewController.h"

typedef void(^addManager)(NSArray *array);
typedef void(^removeManager)(NSArray *array);
typedef void(^removeMember)(NSArray *array);

@interface ChangeMemberViewController : YYIMBaseViewController
//标题
@property NSString *actionName;
// 人员
@property (nonatomic, retain) NSArray *memberArray;
// 方法回调
@property (copy, nonatomic) addManager addManager;
@property (copy, nonatomic) removeManager removeManager;
@property (copy, nonatomic) removeMember removeMember;
@end
