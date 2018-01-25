//
//  FolderNavController.h
//  YonyouIM
//
//  Created by litfb on 15/7/13.
//  Copyright (c) 2015年 yonyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYIMDefs.h"

@protocol YMDirDelegate;

@interface FolderNavController : UINavigationController

@property (retain, nonatomic) NSArray *dirIdArray;

@property id<YMDirDelegate> dirDelegate;

@end

@protocol YMDirDelegate <NSObject>

- (void)didSelectDir:(NSString *)dirId fileSet:(YYIMFileSet)fileSet group:(NSString *)groupId;

@end