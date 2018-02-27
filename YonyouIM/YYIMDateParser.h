//
//  YYIMDateParser.h
//  uclture
//
//  Created by Chenly on 2017/6/15.
//
//

#import <Foundation/Foundation.h>

@interface YYIMDateParser : NSObject

+ (instancetype)parser;
- (NSString *)dateStringWithMessageDate:(NSTimeInterval)messageDate;

@end
