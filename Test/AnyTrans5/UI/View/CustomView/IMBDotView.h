//
//  IMBDotView.h
//  AnyTrans
//
//  Created by smz on 17/10/25.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBDotView : NSView {
    float _circleRadius;
    NSColor *_fillColor;
    NSColor *_highLightColor;
    BOOL _isNowPage;
}
@property (nonatomic, assign) float circleRadius;
@property (nonatomic, retain) NSColor *fillColor;
@property (nonatomic, retain) NSColor *highLightColor;
@property (nonatomic, assign) BOOL isNowPage;

@end
