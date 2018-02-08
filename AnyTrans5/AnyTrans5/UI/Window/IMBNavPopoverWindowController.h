//
//  IMBNavPopoverWindowController.h
//  AnyTrans
//
//  Created by m on 11/8/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBPopOverView.h"
#import "IMBCommonEnum.h"
#import "IMBWhiteView.h"
#import <QuartzCore/QuartzCore.h>
#import "iCarousel.h"
@interface IMBNavPopoverWindowController : NSWindowController 
{
    IBOutlet IMBPopOverView *_mainView;
    IBOutlet IMBWhiteView *_titleView;
    IBOutlet NSTextField *_mainLabel;
    IBOutlet NSTextField *_subLabel;
    
    NSTextField *_otherLabel;//用于西语
    
    NSString *_mainTitle;
    NSString *_subTitle;
    BOOL _isUP;
    
    NSTrackingArea *_trackingArea;
    FunctionType _currentType;
    
    //iTunes
    NSView *_animationView;
    CAShapeLayer *_shapeLayer1;//用于水波动画
    CAShapeLayer *_shapeLayer2;
    CAShapeLayer *_shapeLayer3;
    CALayer *_layer1;
    CALayer *_layer2;
    CALayer *_layer3;
    
    //backUp
    NSView *_backUpView;
    CALayer *_backUpLayer;
    CALayer *_backUpLayer1;
    CALayer *_backUpLayer2;
    CALayer *_backUpLayer3;
    CALayer *_backUpLayer4;
    CALayer *_backUpLayer5;
    CALayer *_backUpLayer6;
    CALayer *_backUpLayer7;
    CALayer *_backUpLayer8;
    CALayer *_backUpLayer9;
    CALayer *_backUpLayer10;
    CALayer *_backUpLayer11;
    CALayer *_backUpLayer12;
    
    //iCloud
    NSView *_iCloudView;
    CALayer *_iCloudLayer1;
    CALayer *_iCloudLayer2;
    CALayer *_iCloudLayer3;
    CALayer *_iCloudLayer4;
    
    //device
    NSView *_deviceView;
    NSTimer *_timer;
    int count;
    CALayer *_deviceLayer;
    CALayer *_deviceSubLayer1;
    CALayer *_deviceSubLayer2;
    CALayer *_deviceSubLayer3;
    CALayer *_deviceSubLayer4;
    CALayer *_deviceSubLayer5;
    CALayer *_deviceSubLayer6;
    
    //downLoad
    NSView *_downLoadView;
    CALayer *_downLoadLayer1;
    CALayer *_downLoadLayer2;
    CALayer *_downLoadLayer3;
    CALayer *_downLoadLayer4;
    
    //toiOS
    NSView *_toiOSView;
    CALayer *_androidLayer;
    CALayer *_iOSLayer;
    CALayer *_toiOSLayer1;
    CALayer *_toiOSLayer2;
    CALayer *_toiOSLayer3;
    CALayer *_toiOSLayer4;
    CALayer *_toiOSLayer5;
    CALayer *_toiOSLayer6;
    
    //skin
    NSView *_skinView;
    CALayer *_skinLayer1;
    CALayer *_skinLayer2;
    CALayer *_skinLayer3;
    CALayer *_skinLayer4;
    NSTimer *_skinTimer;
    
    //airBackup
    NSView *_airBackupView;
    CALayer *_airBackupLayer1;
    CALayer *_airBackupLayer2;
    CALayer *_airBackupLayer3;
    CALayer *_airBackupLayer4;
    CALayer *_airBackupLayer5;
    CALayer *_airBackupLayer6;
    CALayer *_airBackupLayer7;
    CALayer *_airBackupLayer8;
    NSTimer *_airBackupTimer;
    int _airCount;
}
@property (nonatomic, assign) FunctionType currentType;
@property (nonatomic, assign) BOOL isUP;

@end
