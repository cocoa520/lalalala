//
//  IMBImageAndTextFieldCell.m
//  iOSFiles
//
//  Created by JGehry on 3/8/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBImageAndTextFieldCell.h"
#import "IMBCommonDefine.h"
#import <AppKit/NSCell.h>
#import "StringHelper.h"
#import "TempHelper.h"

@implementation IMBImageAndTextFieldCell
@synthesize marginX = _marginX;
@synthesize paddingX = _paddingX;
@synthesize image = _image;
@synthesize imageSize = _imageSize;
@synthesize reserveWidth = _reserveWidth;
@synthesize rightImage = _rightImage;
@synthesize rightSize = _rightSize;
@synthesize lockImg = _lockImg;
@synthesize iCloudImg = _iCloudImg;
@synthesize imageStrName = _imageStrName;
@synthesize imageName = _imageName;
@synthesize isDataImage = _isDataImage;
@synthesize imageText = _imageText;
- (id)init {
    if ((self = [super init])) {
        [self setLineBreakMode:NSLineBreakByTruncatingTail];
        //[self setSelectable:YES];
        _imageSize = NSMakeSize(0, 0);
        _marginX = 3;
        _paddingX = 3;
        _reserveWidth = 0;
        _imageStrName = @"";
    }
    return self;
}

- (void)dealloc {
    [_image release];
    [_rightImage release];
    [_lockImg release];
    [_imageText release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    IMBImageAndTextFieldCell *cell = (IMBImageAndTextFieldCell *)[super copyWithZone:zone];
    // The image ivar will be directly copied; we need to retain or copy it.
    cell->_image = [_image retain];
    cell->_rightImage = [_rightImage retain];
    cell ->_lockImg = [_lockImg retain];
    cell -> _imageText = [_imageText retain];
    return cell;
}

- (NSSize)_imageSize:(CGFloat)cellFrameHeight {
    if (_imageSize.width == 0 && _imageSize.height == 0) {
        _imageSize = NSMakeSize(cellFrameHeight - 4, cellFrameHeight - 4);
    }
    return _imageSize;
}

- (NSRect)imageRectForBounds:(NSRect)cellFrame {
    
    NSRect result;
    if (_image != nil) {
        result.size = [self _imageSize:_image.size.height];
        result.origin = cellFrame.origin;
        result.origin.x += _marginX;
        result.origin.y += ceil((cellFrame.size.height - result.size.height) / 2);
    } else {
        if (_reserveWidth > 0) {
            NSRect rect = NSZeroRect;
            rect.origin = cellFrame.origin;
            rect.size = [self _imageSize:_reserveWidth];
            rect.origin.x += _marginX;
            result = rect;
        }
        else{
            result = NSZeroRect;
        }
    }
    return result;
}

// We could manually implement expansionFrameWithFrame:inView: and drawWithExpansionFrame:inView: or just properly implement titleRectForBounds to get expansion tooltips to automatically work for us
- (NSRect)titleRectForBounds:(NSRect)cellFrame {
    NSRect result;
    if (![StringHelper stringIsNilOrEmpty:_imageText]) {
        result.size = [StringHelper calcuTextBounds:_imageText fontSize:12.0].size;
        result.origin = cellFrame.origin;
        result.origin.x += 10;
        result.origin.y += ceil((cellFrame.size.height - result.size.height) / 2);
    } else {
        result = [super titleRectForBounds:cellFrame];
        result.origin.x += self.paddingX;
    }
    return result;
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent {
    [super editWithFrame:[self titleRectForBounds:aRect] inView:controlView editor:textObj delegate:anObject event:theEvent];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength {
    [super selectWithFrame:[self titleRectForBounds:aRect] inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSRect imageFrame;
    if (_image != nil) {
        if (self.isHighlighted && self.controlView.window.isKeyWindow) {
            NSImage *surImage = [_image retain];
            NSString *imageName = _image.name;
            if ([StringHelper stringIsNilOrEmpty:imageName]) {
                imageName = _imageName;
            }
            if(_isDataImage) {
                
            }else {
                if (_image != nil) {
                    [_image release];
                    _image = nil;
                }
                if (self.backgroundStyle == NSBackgroundStyleDark) {
                    _image = [[StringHelper imageNamed:[NSString stringWithFormat:@"%@1",imageName]] retain];
                    
                }else{
                    _image = [[StringHelper imageNamed:[NSString stringWithFormat:@"%@2",imageName]] retain];
                }
            }
            
            
            if (_image == nil) {
                _image = [surImage retain];
            }
            [surImage release];
        }
        imageFrame = [self imageRectForBounds:cellFrame];
        [_image drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        NSInteger newX = NSMaxX(imageFrame) + _paddingX;
        cellFrame.size.width = NSMaxX(cellFrame) - newX;
        cellFrame.origin.x = newX;
    } else {
        imageFrame = [self imageRectForBounds:cellFrame];
        NSInteger newX = NSMaxX(imageFrame) + _paddingX;
        cellFrame.size.width = NSMaxX(cellFrame) - newX;
        cellFrame.origin.x = newX;
    }
    [super drawWithFrame:cellFrame inView:controlView];
    
    //扩展 文字右边的图
    if (_rightImage != nil) {
        
        NSRect rect;
        rect.origin.x = controlView.frame.size.width - _rightSize.width - 4;
        rect.origin.y = cellFrame.origin.y + ceilf((cellFrame.size.height - _rightSize.height)/2.0) + 1;
        rect.size = _rightImage.size;
        [_rightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        
    }
    if (_lockImg != nil) {
        NSRect rect;
        rect.origin.x = cellFrame.origin.x  - 10;
        rect.origin.y = cellFrame.origin.y + ceilf((cellFrame.size.height - _rightSize.height)/2.0) ;
        rect.size = _lockImg.size;
        [_lockImg drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    }
    
    if (_iCloudImg != nil) {
        NSRect rect;
        rect.origin.x = cellFrame.origin.x - 18;
        rect.origin.y = cellFrame.origin.y + 45;
        rect.size = _iCloudImg.size;
        [_iCloudImg drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    }
    
    if (![StringHelper stringIsNilOrEmpty:_imageText]) {
        NSRect rect = [self imageTitleRectForBounds:cellFrame];
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setAlignment:NSLeftTextAlignment];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:COLOR_TEXT_ORDINARY,NSForegroundColorAttributeName ,paragraphStyle,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontAttributeName, nil];
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:_imageText attributes:attributes];
        [as drawWithRect: rect
                 options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin];
        [as release];
    }
}

- (NSRect)imageTitleRectForBounds:(NSRect)theRect {
    /* get the standard text content rectangle */
    NSRect titleFrame = [super titleRectForBounds:theRect];
    
    /* find out how big the rendered text will be */
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:_imageText];
    NSRect textRect = NSZeroRect;
    if (titleStr != nil) {
        textRect = [titleStr boundingRectWithSize: titleFrame.size
                                          options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin ];
        [titleStr release];
    }
    /* If the height of the rendered text is less then the available height,
     * we modify the titleRect to center the text vertically */
    if (textRect.size.height < titleFrame.size.height) {
        titleFrame.origin.x = titleFrame.origin.x + 8;
        titleFrame.origin.y = theRect.origin.y + (theRect.size.height - textRect.size.height) / 2.0;
        titleFrame.size.height = textRect.size.height + 2;
        titleFrame.size.width -= 4;
    }
    return titleFrame;
}

- (NSSize)cellSize {
    NSSize cellSize = [super cellSize];
    if (_image != nil) {
        cellSize.width += _imageSize.width;
    }
    cellSize.width += _marginX;
    return cellSize;
}

- (NSUInteger)hitTestForEvent:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView {
    NSPoint point = [controlView convertPoint:[event locationInWindow] fromView:nil];
    // If we have an image, we need to see if the user clicked on the image portion.
    if (_image != nil) {
        // This code closely mimics drawWithFrame:inView:
        NSSize imageSize = [self _imageSize:cellFrame.size.height];
        NSRect imageFrame;
        NSDivideRect(cellFrame, &imageFrame, &cellFrame, _marginX + imageSize.width, NSMinXEdge);
        
        imageFrame.origin.x += _marginX;
        imageFrame.size = imageSize;
        // If the point is in the image rect, then it is a content hit
        if (NSMouseInRect(point, imageFrame, [controlView isFlipped])) {
            // We consider this just a content area. It is not trackable, nor it it editable text. If it was, we would or in the additional items.
            // By returning the correct parts, we allow NSTableView to correctly begin an edit when the text portion is clicked on.
            return NSCellHitContentArea;
        }
    }
    // At this point, the cellFrame has been modified to exclude the portion for the image. Let the superclass handle the hit testing at this point.
    return [super hitTestForEvent:event inRect:cellFrame ofView:controlView];
}


@end

