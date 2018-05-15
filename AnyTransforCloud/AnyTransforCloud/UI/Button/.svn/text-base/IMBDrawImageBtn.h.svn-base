//
//  IMBDrawOneImageBtn.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-8.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
@interface IMBDrawImageBtn : NSButton{
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _buttonType;
    NSImage *_mouseDownImage;
    NSImage *_mouseUpImage;
    NSImage *_mouseExitedImage;
    NSImage *_mouseEnteredImage;
    BOOL _isDFUGuide;
    BOOL _isEnble;
    BOOL _longTimeDown;
    NSImage *_longTimeImage;
}
@property (nonatomic, retain) NSImage *longTimeImage;
@property (nonatomic, assign) BOOL longTimeDown;
@property (nonatomic, assign) BOOL isDFUGuide;
@property (nonatomic, assign) BOOL isEnble;
-(void)mouseDownImage:(NSImage*) mouseDownImg withMouseUpImg:(NSImage *) mouseUpImg withMouseExitedImg:(NSImage *) mouseExiteImg mouseEnterImg:(NSImage *) mouseEnterImg;
@end
