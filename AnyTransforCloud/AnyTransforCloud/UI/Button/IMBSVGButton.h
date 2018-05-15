//
//  IMBSVGButton.h
//  AnyTransforCloud
//
//  Created by hym on 13/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
#import "IMBCloudEntity.h"
#import <QuartzCore/QuartzCore.h>
@class PocketSVG;
@interface IMBSVGButton : NSButton {
    CALayer *_subLayer;
    PocketSVG *_myVectorDrawing;
    MouseStatusEnum _mouseState;
    NSTrackingArea *_trackingArea;
    NSMutableArray *_cloudAry;
    NSColor *_backgroundColor;
    BOOL _isClick; ///是否被选中
    CALayer *_backgroundLayer;
//    BOOL _longTimeDown;
    BOOL _isFristAnimation;
    BOOL _isDownOtherBtn; ///选中一个按钮另外的按钮不执行动画
    IMBCloudEntity *_cloudEntity;
    CAShapeLayer *_myShapeLayer2;
    id _delegate;
    NSString *_toolTipStr;
    BOOL _isDown;
    BOOL _isUnlockBtn;
}
@property (nonatomic, retain) IMBCloudEntity *cloudEntity;
@property (nonatomic, retain) NSColor *backgroundColor;
@property (nonatomic, retain) NSMutableArray *cloudAry;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) BOOL isDownOtherBtn;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString *toolTipStr;
@property (nonatomic, assign) BOOL isUnlockBtn;
- (void)setSvgFileName:(NSString *)svgName;
@end
