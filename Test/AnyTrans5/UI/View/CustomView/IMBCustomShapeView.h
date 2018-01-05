//
//  IMBCustomShapeIView.h
//  MacClean
//
//  Created by LuoLei on 16-1-26.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBCustomShapeView : NSView
{
    NSImage *_leftImage;
    NSImage *_middleImage;
    NSImage *_rightImage;
}
@property (nonatomic, readwrite, retain) NSImage *leftImage;
@property (nonatomic, readwrite, retain) NSImage *middleImage;
@property (nonatomic, readwrite, retain) NSImage *rightImage;
- (void)setLeftImage:(NSImage *)leftImage midImage:(NSImage *)midImage rightImage:(NSImage *)rightImage;
@end
