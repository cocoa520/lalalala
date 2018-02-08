//
//  IMBPopupButtonCell.m
//  TestMyOwn
//
//  Created by iMobie on 6/26/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import "IMBPopupKindButtonCell.h"
#import "StringHelper.h"

@implementation IMBPopupKindButtonCell

- (void)drawImageWithFrame:(NSRect)cellRect inView:(NSView *)controlView{
    NSImage *image = [StringHelper imageNamed:@"contact_add2"];
    if([self isHighlighted] && self.alternateImage){
        image = self.alternateImage;
    }
    
    //TODO: respect -(NSCellImagePosition)imagePosition
    NSRect imageRect = NSZeroRect;
    imageRect.origin.y = (CGFloat)round(cellRect.size.height*0.5f-image.size.height*0.5f);
    imageRect.origin.x = (CGFloat)round(cellRect.size.width*0.5f-image.size.width*0.5f);
    imageRect.size = image.size;
    
    [image drawInRect:imageRect
             fromRect:NSZeroRect
            operation:NSCompositeSourceOver
             fraction:1.0f
       respectFlipped:YES
                hints:nil];
}

@end
