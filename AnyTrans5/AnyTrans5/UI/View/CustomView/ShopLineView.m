//
//  ShopLineView.m
//  AnyTrans
//
//  Created by m on 10/22/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "ShopLineView.h"
#import "StringHelper.h"
@implementation ShopLineView
@synthesize centerLength = _centerLength;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path1 = nil;
    if (_centerLength > 0) {
        path1=[NSBezierPath bezierPathWithRect:NSMakeRect(0, 0, dirtyRect.size.width / 2.0 - _centerLength/2.0 , dirtyRect.size.height)];
    }else {
        path1=[NSBezierPath bezierPathWithRect:NSMakeRect(0, 0, dirtyRect.size.width / 2.0 - 12 , dirtyRect.size.height)];
    }
    
    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setFill];
    [path1 fill];
    
    NSBezierPath *path2 = nil;
    if (_centerLength > 0) {
        path2=[NSBezierPath bezierPathWithRect:NSMakeRect(dirtyRect.size.width / 2.0 + _centerLength / 2.0, 0, dirtyRect.size.width / 2.0 - 12 , dirtyRect.size.height)];
    }else {
        path2=[NSBezierPath bezierPathWithRect:NSMakeRect(dirtyRect.size.width / 2.0 + 12, 0, dirtyRect.size.width / 2.0 - 12 , dirtyRect.size.height)];
    }
    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setFill];
    [path2 fill];
}

@end
