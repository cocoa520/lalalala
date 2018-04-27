//
//  CapacityView.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CapacityView : NSView
{
    NSColor *_color;
    NSRect _rect;
    float _percent;
}

- (id)initWithFrame:(NSRect)frame WithFillColor:(NSColor *)fillcolor withPercent:(float)percent;

@end
