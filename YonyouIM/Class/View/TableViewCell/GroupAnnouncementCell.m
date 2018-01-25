//
//  GroupAnnouncementCell.m
//  YonyouIM
//
//  Created by hb on 2017/9/7.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "GroupAnnouncementCell.h"

@implementation GroupAnnouncementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self reuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)reuse {
    self.iNameLabel.text = nil;
    self.iDetailLabel.text = nil;
}

- (void)setName:(NSString *)name {
    self.iNameLabel.text = name;
}

- (void)setDetail:(NSString *)detail {
    if (!detail || detail.length == 0) {
        self.iDetailLabel.text = @"未设置";
        self.iDetailLabel.textColor = [UIColor grayColor];
    } else {
        self.iDetailLabel.text = detail;
        self.iDetailLabel.textColor = [UIColor blackColor];
    }
}

@end
