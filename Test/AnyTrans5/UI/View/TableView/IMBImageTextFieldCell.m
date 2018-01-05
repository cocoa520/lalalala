//
//  IMBImageTextFieldCell.m
//  PhotoTrans
//
//  Created by iMobie on 11/1/13.
//  Copyright (c) 2013 iMobie. All rights reserved.
//

#import "IMBImageTextFieldCell.h"

@implementation IMBImageTextFieldCell
@synthesize image = _image;
@synthesize imageSize = _imageSize;
@synthesize marginX = _marginX;

-(id)init {
    if (self = [super init]) {
        _imageSize = NSMakeSize(0, 0);
        _marginX = 3;
    }
    return self;
}

- (void)dealloc
{
    [_image release];
    [super dealloc];
}

-(id)copyWithZone:(NSZone *)zone{
    IMBImageTextFieldCell *cell = (IMBImageTextFieldCell *)[super copyWithZone:zone];
    cell->_image = [_image retain];
    return cell;
}

-(NSSize)_imageSize:(CGFloat)celLFrameHerght{
    if (_imageSize.width == 0 && _imageSize.height == 0) {
        _imageSize = NSMakeSize(celLFrameHerght - 4, celLFrameHerght - 4);
    }
    return _imageSize;
}

-(NSRect)imageRectForBounds:(NSRect)theRect{
    NSRect result;
    if (_image != nil) {
        result.size = [self _imageSize:theRect.size.height];
        result.origin = theRect.origin;
        result.origin.x += _marginX;
        result.origin.y += ceil((theRect.size.height - result.size.height) / 2);
    }else{
        result = NSZeroRect;
    }
    return result;
}

-(void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{
    if (_image != nil) {
        NSRect imageFrame = [self imageRectForBounds:cellFrame];
        [_image drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        NSInteger newX = NSMaxX(imageFrame) + _marginX;
        cellFrame.size.width = NSMaxX(cellFrame) - newX;
        cellFrame.origin.x = newX;
    }
    [super drawWithFrame:cellFrame inView:controlView];
}

@end
