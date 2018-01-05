//
//  IMBColorButton.h
//  AnyTrans
//
//  Created by smz on 17/7/27.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface IMBColorButton : NSPopUpButton {
    NSColor *_fillColor;
    BOOL _isHasBorder;
    NSColor *_borderColor;
    //现宽
    int _borderWidth;
    NSTrackingArea *_trackingArea;
    NSInteger _newTag;
    CAShapeLayer *_shapeLayer;
}
@property (nonatomic,retain) NSColor *fillColor;
@property (nonatomic,retain) NSColor *borderColor;
@property (nonatomic,assign) BOOL isHasBorder;
@property (nonatomic,assign) int borderWidth;
@property (nonatomic,assign) NSInteger newTag;

@end
