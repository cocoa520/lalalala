//
//  IMBOpenPanel.m
//  iMobieTrans
//
//  Created by iMobie on 14-9-9.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBOpenPanel.h"
#import "IMBNotificationDefine.h"
@implementation IMBOpenPanel

+ (NSOpenPanel *)openPanel
{
    //判断当前设备断开
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDisconnected:) name:DeviceDisConnectedNotification object:nil];

    return [super openPanel];
}

+ (void)deviceDisconnected:(NSNotification *)notification
{
    [NSApp stopModal];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DeviceDisConnectedNotification object:nil];
    [super dealloc];
}
@end
