//
//  IMBSignOutButton.h
//  PhoneClean
//
//  Created by iMobie023 on 15-7-8.
//  Copyright (c) 2015年 imobie.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
@interface IMBSignOutButton : NSButton
{
  NSTrackingArea *_trackingArea;
    NSImage *_mouseEnteredImage;
    NSImage *_mouseExitedImage;
    NSImage *_mouseDownImage;
    NSImage *_enabledImage;
    BackButtonType _buttonType;
    BOOL _isleftBtn;
    NSImage *_isDownBackgroundImg;
    BOOL _isDown;
    NSString *_titleStr;
    BOOL _isPhoto;
    BOOL _isTuiTuBtn;
    NSColor *_backGroudCol;
    MouseStatusEnum _mouseState;
//    BOOL _isNoMouseUp;
}
@property (nonatomic, retain) NSColor *backGroudCol;
@property (nonatomic, assign) BOOL isTuiTuBtn;
@property (nonatomic, assign) BOOL isPhoto;
@property (nonatomic, assign) BackButtonType buttonType;
@property (nonatomic, retain) NSString *titleStr;
@property (nonatomic, retain) NSImage *isDownBackgroundImg;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) BOOL isleftBtn;
@property (nonatomic, retain) NSImage *mouseEnteredImage;
@property (nonatomic, retain) NSImage *mouseExitedImage;
@property (nonatomic, retain) NSImage *mouseDownImage;
@property (nonatomic, retain) NSImage *enabledImage;

@end
