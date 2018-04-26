//
//  IMBBorderRectAndColorView.h
//  MacClean
//
//  Created by Gehry on 4/17/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBBorderRectAndColorView : NSView{
    NSColor *_background;
    double _borderLineSize;
    NSColor *_lineColor;
    
    NSGradient *gradient;
    NSShadow *outerShadow;
    BOOL _isOffSetY;
    float _offsetY;     //投影Y轴偏移量
    float _blurRadius;
}

@property (nonatomic, retain) NSColor *background;
@property (nonatomic, assign) double borderLineSize;
@property (nonatomic, retain) NSColor *lineColor;
@property (nonatomic, assign) BOOL isOffSetY;
@property (nonatomic, assign) float offsetY;
@property (nonatomic, assign) float blurRadius;



@end
