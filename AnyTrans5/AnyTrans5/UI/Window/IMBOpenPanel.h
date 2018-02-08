//
//  IMBOpenPanel.h
//  iMobieTrans
//
//  Created by iMobie on 14-9-9.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBOpenPanel : NSOpenPanel
+ (void)deviceDisconnected:(NSNotification *)notification;
@end
