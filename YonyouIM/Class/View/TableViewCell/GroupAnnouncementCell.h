//
//  GroupAnnouncementCell.h
//  YonyouIM
//
//  Created by hb on 2017/9/7.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupAnnouncementCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *iNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iDetailLabel;

- (void)reuse;

- (void)setName:(NSString *)name;

- (void)setDetail:(NSString *)detail;
@end
