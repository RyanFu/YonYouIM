//
//  YYMessage+IUM.h
//  YYCulture
//
//  Created by Chenly on 2017/6/12.
//  Copyright © 2017年 Yonyou. All rights reserved.
//

#import "YYMessage.h"

#define YM_MESSAGE_DISPLAY_STATE_NORMAL         0
#define YM_MESSAGE_DISPLAY_STATE_UNREAD         1
#define YM_MESSAGE_DISPLAY_STATE_READED         2
#define YM_MESSAGE_DISPLAY_STATE_LOADING        3
#define YM_MESSAGE_DISPLAY_STATE_FAILED         4
#define YM_MESSAGE_DISPLAY_STATE_AUDIO_UNREAD   5

@interface YYMessage (Extend)

@property (nonatomic, readonly) NSInteger displayState;
@property (nonatomic, readonly) id conciseContent;
@property (nonatomic, readonly) BOOL isIntegrated;

- (NSDictionary *)messageForJavascript;
- (YYMessage *)aiMessage;

@end
