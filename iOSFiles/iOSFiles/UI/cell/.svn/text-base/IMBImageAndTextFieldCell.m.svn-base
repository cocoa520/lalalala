//
//  IMBImageAndTextFieldCell.m
//  iOSFiles
//
//  Created by JGehry on 3/8/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBImageAndTextFieldCell.h"
#import "IMBCommonDefine.h"
@implementation IMBImageAndTextFieldCell
@synthesize marginX = _marginX;
@synthesize paddingX = _paddingX;
@synthesize image = _image;
@synthesize imageSize = _imageSize;
@synthesize reserveWidth = _reserveWidth;
@synthesize rightImage = _rightImage;
@synthesize rightSize = _rightSize;
@synthesize isDownloadComplete = _isDownloadComplete;
@synthesize encrytedImg = _encryptedImg;
@synthesize damageImg = _damageImg;
@synthesize isOneRow = _isOneRow;
@synthesize isDrawBgImg = _isDrawBgImg;
@synthesize deleteImage = _deleteImage;
@synthesize messageCount = _messageCount;
@synthesize isShowMessageCount = _isShowMessageCount;

- (id)init {
    if ((self = [super init])) {
        //[self setLineBreakMode:NSLineBreakByTruncatingTail];
        //[self setSelectable:YES];
        _imageSize = NSMakeSize(0, 0);
        _marginX = 3;
        _paddingX = 3;
        _reserveWidth = 0;
        _messageCount = 0;
    }
    return self;
}

- (void)dealloc {
    [_image release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    IMBImageAndTextFieldCell *cell = (IMBImageAndTextFieldCell *)[super copyWithZone:zone];
    // The image ivar will be directly copied; we need to retain or copy it.
    cell->_image = [_image retain];
    cell->_rightImage = [_rightImage retain];
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
    /*
     if (_image != nil) {
     CGFloat imageWidth = [self _imageSize:cellFrame.size.height].width;
     result = cellFrame;
     result.origin.x += (3 + imageWidth);
     result.size.width -= (3 + imageWidth);
     } else {
     */
    result = [super titleRectForBounds:cellFrame];
    result.origin.x += self.paddingX;
    //}
    return result;
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent {
    [super editWithFrame:[self titleRectForBounds:aRect] inView:controlView editor:textObj delegate:anObject event:theEvent];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength {
    [super selectWithFrame:[self titleRectForBounds:aRect] inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    if (_image != nil) {
        
        NSRect imageFrame = [self imageRectForBounds:cellFrame];
    
        [_image drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        
        
        if (self.isHighlighted) {
            NSImage *surImage = [_image retain];
            NSString *imageName = _image.name;
            if (_image != nil) {
                [_image release];
                _image = nil;
            }
            _image = [[NSImage imageNamed:[NSString stringWithFormat:@"%@1",imageName]] retain];
            if (_image == nil) {
                _image = [surImage retain];
            }
            [surImage release];
            if (_isDrawBgImg) {
                NSRect imageFrame = [self imageRectForBounds:cellFrame];
                NSImage *headImage = [NSImage imageNamed:@"messageBg2"];
                [headImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                
            }
        } else {
            if (_isDrawBgImg) {
                if (_isOneRow) {
                    NSRect imageFrame = [self imageRectForBounds:cellFrame];
                    NSImage *headImage = [NSImage imageNamed:@"messageBg1"];
                    [headImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                }else{
                    NSRect imageFrame = [self imageRectForBounds:cellFrame];
                    NSImage *headImage = [NSImage imageNamed:@"messageBg3"];
                    [headImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                }
                
                
            }
        }
        
        if (_messageCount > 0 && _isShowMessageCount) {
            NSString *messageCountStr = nil;
            if (_messageCount>=999) {
                messageCountStr = [NSString stringWithFormat:@"%ld+",(long)999];
            } else
            {
                messageCountStr = [NSString stringWithFormat:@"%ld",(long)_messageCount];
            }
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:messageCountStr?messageCountStr:@""];
            if (_messageCount >= 999) {
                [str addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:8] range:NSMakeRange(0, str.length)];
            } else
            {
                [str addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:10] range:NSMakeRange(0, str.length)];
            }
            
            [str addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, str.length)];
            
            NSRect rect = imageFrame;
            NSRect textrect = imageFrame;
            if (str.length == 1) {
                rect.origin.x = rect.origin.x + 21;
                rect.origin.y -= 3;
                rect.size.width = 22;
                rect.size.height = 14;
                //rect = NSMakeRect(40, 2, 20, 20);
                textrect.origin.x = textrect.origin.x + 21 + (22-str.size.width)/2;
                textrect.origin.y += 1+(14-str.size.height)/2 - 5 - 1;
                textrect.size.width = str.size.width;
                textrect.size.height = str.size.height;
                
                
                //textrect = NSMakeRect(40+(20-str.size.width)/2, 1+(20-str.size.height)/2, str.size.width, str.size.height);
            } else {
                rect.origin.x = rect.origin.x + 19;
                rect.origin.y -= 1;
                rect.size.width = 24;
                rect.size.height = 14;
                textrect.origin.x = textrect.origin.x + 19 + (24-str.size.width)/2;
                textrect.origin.y += (14-str.size.height)/2 - 2 - 1;
                textrect.size.width = str.size.width;
                textrect.size.height = str.size.height;
            }
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:7 yRadius:7];
            [COLOR_MESSAGECOUNT_BG setFill];
            [path fill];
            //[path setLineWidth:2];
            //[COLOR_MESSAGECOUNT_BG setStroke];
            //[path stroke];
            [str drawInRect:textrect];
        }
        
        if (_encryptedImg != nil) {
            NSRect rect = NSMakeRect(imageFrame.origin.x+_image.size.width/2, imageFrame.origin.y +_image.size.height - _encryptedImg.size.height, _encryptedImg.size.width, _encryptedImg.size.height);
            [_encryptedImg drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }else if (_damageImg!= nil) {
            NSRect rect = NSMakeRect(imageFrame.origin.x + _image.size.width/2, imageFrame.origin.y +_image.size.height - _damageImg.size.height, _damageImg.size.width, _damageImg.size.height);
            [_damageImg drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
        
        NSInteger newX = NSMaxX(imageFrame) + _paddingX;
        cellFrame.size.width = NSMaxX(cellFrame) - newX;
        cellFrame.origin.x = newX;
        
    }else{
        NSRect imageFrame = [self imageRectForBounds:cellFrame];
        NSInteger newX = NSMaxX(imageFrame) + _paddingX;
        cellFrame.size.width = NSMaxX(cellFrame) - newX;
        cellFrame.origin.x = newX;
    }
    [super drawWithFrame:cellFrame inView:controlView];
    
    if (_isDownloadComplete) {
        NSImage *enImage = [NSImage imageNamed:@"downloaded_icon"];
        
        NSRect imageFrame = [self imageRectForBoundsEN:cellFrame];
        imageFrame.size = enImage.size;
        imageFrame.origin.x -= 4;
        [enImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    }
    //扩展 文字右边的图
    if (_rightImage != nil) {
        
        NSRect rect;
        rect.origin.x = controlView.frame.size.width - _rightSize.width - 4;
        rect.origin.y = cellFrame.origin.y + ceilf((cellFrame.size.height - _rightSize.height)/2.0) + 1;
        rect.size = _rightImage.size;
        [_rightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        
    }
    
    
}

-(NSRect)imageRectForBoundsEN:(NSRect)theRect {
    NSRect result;
    if (_image != nil) {
        result.size = [self _imageSize:theRect.size.height];
        result.origin = theRect.origin;
        result.origin.x += (_marginX + 13);
        result.origin.y += ceil((theRect.size.height - result.size.height) / 2 + 19);
    }else{
        result = NSZeroRect;
    }
    return result;
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

