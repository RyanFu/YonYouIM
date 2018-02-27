//
//  YYIMDateParser.m
//  uclture
//
//  Created by Chenly on 2017/6/15.
//
//

#import "YYIMDateParser.h"

@implementation YYIMDateParser

+ (instancetype)parser {
    static YYIMDateParser *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YYIMDateParser alloc] init];
    });
    return instance;
}

- (NSString *)dateStringWithMessageDate:(NSTimeInterval)messageDate {
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:(messageDate / 1000)];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = @"y年M月d日 HH:mm";
    if([calendar isDateInToday:date]) {
        // 当日
        dateFormat = @"HH:mm";
    }
    else if([calendar isDateInYesterday:date]) {
        // 昨天
        dateFormat = @"昨天 HH:mm";
    }
    else if ([calendar isDate:date equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitWeekOfYear]) {
        // 本周
        NSInteger weekday = [calendar components:NSCalendarUnitWeekday fromDate:date].weekday;
        NSArray *weekdays = @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];
        dateFormat = [NSString stringWithFormat:@"星期%@ HH:mm", weekdays[weekday - 1]];
    }
    dateFormatter.dateFormat = dateFormat;
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

@end

