//
//  IMBTransferProgressView.h
//  AnyTransforCloud
//
//  Created by hym on 06/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
@interface IMBTransferProgressView : NSView
{
    NSColor *_arcColor;
    CAShapeLayer *_arcLayer;
    BOOL _isDownLoad;
    double _progress;
}
@property (nonatomic, assign) BOOL isDownLoad;
- (void)setProgress:(double)progress;
- (void)setFillPathAngle:(double)angle;
- (void)reInitProgress;
@end
