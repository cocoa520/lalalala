//
//  IMBDrawArcView.h
//  ArcDemo
//
//  Created by Pallas on 8/28/14.
//  Copyright (c) 2014 com.imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CountdownCallback
@required
- (void)countdownComplete;
@optional
- (void)remainCountdown:(int)remain;

@end

@interface IMBDrawArcView : NSView {
@private
    id _delegate;
    int radius;
    NSPoint centerPoint;
    float _startAngle;
    float _endAngle;
    BOOL _clockwise;
    NSTimer *timer;
    BOOL _countdownStop;
    dispatch_queue_t _countdownQueue;
    int _seconds;
}

@property (nonatomic, readwrite, retain) id delegate;

- (void)startWithStartAngle:(float)startAngle withSeconds:(int)seconds;

- (void)initialTimerAndQueue;
- (void)stopAnimation;

@end
