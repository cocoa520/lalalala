//
//  IMBDrawOneImageBtn.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-8.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
#import "IMBCloudEntity.h"
@interface IMBDrawOneImageBtn : NSButton{
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _buttonType;
    NSImage *_mouseDownImage;
    NSImage *_mouseUpImage;
    NSImage *_mouseExitedImage;
    NSImage *_mouseEnteredImage;
    BOOL _isEnble;
    BOOL _longTimeDown;
    NSImage *_longTimeImage;
    IMBCloudEntity *_cloudEntity;
    CALayer *_backgroundLayer;
    CALayer *_imageLayer;
    BOOL _isFristAnimation;
    BOOL _isDownOtherBtn; ///选中一个按钮另外的按钮不执行动画
    id _delegate;
    NSString *_toolTipStr;
}
@property (nonatomic, retain) IMBCloudEntity *cloudEntity;
@property (nonatomic, retain) NSImage *longTimeImage;
@property (nonatomic, assign) BOOL longTimeDown;
@property (nonatomic, assign) BOOL isEnble;
@property (nonatomic, assign) BOOL isDownOtherBtn;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString *toolTipStr;
-(void)mouseDownImage:(NSImage*) mouseDownImg withMouseUpImg:(NSImage *) mouseUpImg withMouseExitedImg:(NSImage *) mouseExiteImg mouseEnterImg:(NSImage *) mouseEnterImg;
@end
