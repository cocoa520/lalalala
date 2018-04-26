//
//  IMBiCloudNoTitleBarWinodw.h
//  iOSFiles
//
//  Created by smz on 18/3/14.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBNoTitleBarWindow.h"
@class BackGroundView;

@interface IMBiCloudNoTitleBarWinodw : NSWindow {
    NSButton *_closeButton;
    NSButton *_minButton;
    NSButton *_maxButton;
    BackGroundView *_maxAndminView;
}
@property (nonatomic,assign)BackGroundView *maxAndminView;
@property(nonatomic,assign)NSButton *closeButton;
@property(nonatomic,assign)NSButton *minButton;
@property(nonatomic,assign)NSButton *maxButton;
@end

