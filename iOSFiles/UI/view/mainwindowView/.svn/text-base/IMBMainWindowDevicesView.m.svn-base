//
//  IMBMainWindowDevicesView.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/21.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBMainWindowDevicesView.h"
#import "IMBCommonDefine.h"


@implementation IMBMainWindowDevicesView

#pragma mark - synthesize
@synthesize titleLabel = _titleLabel;
@synthesize messageLabel = _messageLabel;

#pragma mark - initialize
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    [_titleLabel setFont:[NSFont fontWithName:IMBCommonFont size:18.0]];
    [_titleLabel setTextColor:COLOR_TEXT_ORDINARY];
    [_titleLabel setStringValue:CustomLocalizedString(@"NotConnectDeviceTitle", nil)];
    
    [_messageLabel setFont:[NSFont fontWithName:IMBCommonFont size:14.0]];
    [_messageLabel setTextColor:COLOR_TEXT_EXPLAIN];
    [_messageLabel setStringValue:CustomLocalizedString(@"NotConnectDeviceTips", nil)];
    
    
}

@end
