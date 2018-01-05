//
//  IMBIKimageView.m
//  iMobieTrans
//
//  Created by iMobie on 10/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBIKimageView.h"
#import <math.h>

@implementation IMBIKimageView
@synthesize superScrollView = _superScrollView;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setHasHorizontalScroller:NO];
        [self setHasHorizontalScroller:YES];
        [self setAutoresizes:YES];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setHasHorizontalScroller:NO];
        [self setHasVerticalScroller:NO];
    }
    return self;
}

- (BOOL) performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSURLPboardType] )
    {
        NSURL *fileURL = [NSURL URLFromPasteboard:pboard];
        [[super window] setTitle:[fileURL path]];
    }
    return YES;
}

-(BOOL)isGIF:(NSString *)path
{
    // checks if the path points to a GIF image
    NSString * pathExtension = [[path pathExtension] lowercaseString];
    return [pathExtension isEqualToString:@"gif"];
}

- (NSSize)getRealImageSize:(NSURL *)url
{
    NSArray * imageReps = [NSBitmapImageRep imageRepsWithContentsOfURL:url];
    NSInteger width = 0;
    NSInteger height = 0;
    
    for (NSImageRep * imageRep in imageReps) {
        if ([imageRep pixelsWide] > width)
            width = [imageRep pixelsWide];
        if ([imageRep pixelsHigh] > height)
            height = [imageRep pixelsHigh];
    }
    
    NSSize size;
    size.width = (CGFloat)width;
    size.height = (CGFloat)height;
    return size;
}

-(void)setImageWithURL:(NSURL *)url
{
    // checks if a layer is already set
    if ([self overlayForType:IKOverlayTypeImage] == nil)
        [self setOverlay:[CALayer layer] forType:IKOverlayTypeImage];
    // remove the overlay animation
    [[self overlayForType:IKOverlayTypeImage] removeAllAnimations];
    // check if it's a gif
    if ([self isGIF:[url path]] == YES)
    {
        // loads the image
        NSImage * image = [[NSImage alloc] initWithContentsOfFile:[url path]];
        // get the image representations, and iterate through them
        NSArray * reps = [image representations];
        for (NSImageRep * rep in reps)
        {
            // find the bitmap representation
            if ([rep isKindOfClass:[NSBitmapImageRep class]] == YES)
            {
                // get the bitmap representation
                NSBitmapImageRep * bitmapRep = (NSBitmapImageRep *)rep;
                // get the number of frames. If it's 0, it's not an animated gif, do nothing
                int numFrame = [[bitmapRep valueForProperty:NSImageFrameCount] intValue];
                if (numFrame == 0)
                    break;
                // create a value array which will contains the frames of the animation
                NSMutableArray * values = [NSMutableArray array];
                // loop through the frames (animationDuration is the duration of the whole animation)
                float animationDuration = 0.0f;
                for (int i = 0; i < numFrame; ++i)
                {
                    // set the current frame
                    [bitmapRep setProperty:NSImageCurrentFrame withValue:[NSNumber numberWithInt:i]];
                    // this part is optional. For some reasons, the NSImage class often loads a GIF with
                    // frame times of 0, so the GIF plays extremely fast. So, we check the frame duration, and if it's
                    // less than a threshold value, we set it to a default value of 1/20 second.
                    if ([[bitmapRep valueForProperty:NSImageCurrentFrameDuration] floatValue] < 0.000001f)
                        [bitmapRep setProperty:NSImageCurrentFrameDuration withValue:[NSNumber numberWithFloat:1.0f / 20.0f]];
                    // add the CGImageRef to this frame to the value array
                    [values addObject:(id)[bitmapRep CGImage]];
                    // update the duration of the animation
                    animationDuration += [[bitmapRep valueForProperty:NSImageCurrentFrameDuration] floatValue];
                }
                // create and setup the animation (this is pretty straightforward)
                CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
                [animation setValues:values];
                [animation setCalculationMode:@"discrete"];
                [animation setDuration:animationDuration];
                [animation setRepeatCount:HUGE_VAL];
                // add the animation to the layer
                [[self overlayForType:IKOverlayTypeImage] addAnimation:animation forKey:@"contents"];
                // stops at the first valid representation
                break;
            }
        }
        [image release];
    }
    
    // calls the super setImageWithURL method to handle standard images
    [super setImageWithURL:url];
}

- (void)setImage:(CGImageRef)image imageProperties:(NSDictionary *)metaData{
    [super setImage:image imageProperties:metaData];
//    [self setZoomFactor:self.zoomFactor];
}

- (void)setZoomFactor:(CGFloat)zoomFactor{
    NSScrollView *superScrollView = [self superScrollView];
    NSClipView *clipView = (NSClipView *)self.superview;
    [clipView setBackgroundColor:[NSColor colorWithDeviceRed:139.0/255 green:139.0/255 blue:139.0/255 alpha:1.0]];
    NSPoint beforePoint = [superScrollView documentVisibleRect].origin;
    BOOL needScrollToSpecificPointX = NO;
    BOOL needScrollToSpecificPointY = NO;
    BOOL beforeXSmallerThanOne = NO;
    BOOL beforeYSmallerThanOne = NO;
    BOOL biggerZoomFactor = self.zoomFactor <= zoomFactor;
    float originX = beforePoint.x;
    float originY = beforePoint.y;
    float centerOriginXProportion = 1.0;
    float centerOriginYProportion = 1.0;
    NSSize beforeImageSize = NSMakeSize(fabs(self.imageSize.width)*self.zoomFactor, fabs(self.imageSize.height)*self.zoomFactor);
    if (beforeImageSize.width > superScrollView.frame.size.width) {
        centerOriginXProportion = (originX + superScrollView.frame.size.width/2.0)/beforeImageSize.width;
    }
    else{
        beforeXSmallerThanOne = YES;
    }
    
    if (beforeImageSize.height > superScrollView.frame.size.height) {
        //暂时不改变
        centerOriginYProportion = (originY + superScrollView.frame.size.height/2.0)/beforeImageSize.height;
    }
    else{
        beforeYSmallerThanOne = YES;
    }
    
    [super setZoomFactor:zoomFactor];
    if (clipView.frame.size.width != 0 && clipView.frame.size.height != 0) {
        [superScrollView scrollClipView:clipView toPoint:beforePoint];
    }
    
    NSSize imageSize = NSMakeSize(fabs(self.imageSize.width*zoomFactor), fabs(self.imageSize.height*zoomFactor));
    if (imageSize.width > superScrollView.frame.size.width) {
        [self setHasHorizontalScroller:YES];
        needScrollToSpecificPointX = YES;
        if (beforeXSmallerThanOne) {
            originX = (imageSize.width - superScrollView.frame.size.width)/2.0;
        }
        else{
            if (biggerZoomFactor) {
                originX = (imageSize.width * centerOriginXProportion) - superScrollView.frame.size.width/2.0;
                if (originX + superScrollView.frame.size.width > imageSize.width) {
                    originX = imageSize.width - superScrollView.frame.size.width;
                }
                if (originX < 0) {
                    originX = 0;
                }
                
            }
            else{
                [superScrollView scrollClipView:clipView toPoint:NSMakePoint(0,originY)];
                
                originX = (imageSize.width * centerOriginXProportion) - superScrollView.frame.size.width/2.0;
                //                originX -= (beforeImageSize.width - imageSize.width)/4.0;
                if (originX + superScrollView.frame.size.width > imageSize.width) {
                    originX = imageSize.width - superScrollView.frame.size.width;
                }
                if (originX < 0) {
                    originX = 0;
                }
            }
        }
    }
    else{
        if (!beforeXSmallerThanOne) {
            needScrollToSpecificPointX = YES;
            originX = 0;
        }
        [self setHasHorizontalScroller:NO];
    }
    
    if (imageSize.height > superScrollView.frame.size.height) {
        [self setHasVerticalScroller:YES];
        needScrollToSpecificPointY = YES;
        if (beforeYSmallerThanOne) {
            originY = (imageSize.height - superScrollView.frame.size.height) /2.0;
        }
        else{
            if (biggerZoomFactor) {
                originY = (imageSize.height * centerOriginYProportion) - superScrollView.frame.size.height/2.0;
                if (originY + superScrollView.frame.size.height > imageSize.height) {
                    originY = imageSize.height - superScrollView.frame.size.height;
                }
                
                if (originY < 0) {
                    originY = 0;
                }
            }
            else{
                [superScrollView scrollClipView:clipView toPoint:NSMakePoint(originX,0)];
                originY = (imageSize.height * centerOriginYProportion) - superScrollView.frame.size.height/2.0;
                //                originY -= (beforeImageSize.height - imageSize.height)/4.0;
                
                if (originY + superScrollView.frame.size.height > imageSize.height) {
                    originY = imageSize.height - superScrollView.frame.size.height;
                }
                
                if (originY < 0) {
                    originY = 0;
                }
                
            }
            
        }
    }
    else{
        if (!beforeYSmallerThanOne) {
            needScrollToSpecificPointY = YES;
            originY = 0;
        }
        [self setHasVerticalScroller:NO];
    }
    if (needScrollToSpecificPointX || needScrollToSpecificPointY) {
        
        if (needScrollToSpecificPointX && needScrollToSpecificPointY) {
            //            [clipView scrollToPoint:NSMakePoint(originX, originY)];
            [superScrollView scrollClipView:clipView toPoint:NSMakePoint(originX, originY)];
        }
        else if(needScrollToSpecificPointX){
            //            [clipView scrollToPoint:NSMakePoint(originX, clipView.frame.origin.y)];
            [superScrollView scrollClipView:clipView toPoint:NSMakePoint(originX, clipView.frame.origin.y)];
            
        }
        else if(needScrollToSpecificPointY){
            //            [clipView scrollToPoint:NSMakePoint(clipView.frame.origin.x, originY)];
            [superScrollView scrollClipView:clipView toPoint:NSMakePoint(clipView.frame.origin.x, originY)];
        }
        
        [superScrollView reflectScrolledClipView:clipView];
    }
}

- (void)zoomImageToActualSize:(id)sender{
    [super zoomImageToActualSize:sender];
    [self setZoomFactor:self.zoomFactor];
}

- (void)setRotationAngle:(CGFloat)rotationAngle{
    [super setRotationAngle:rotationAngle];
    float zoomValue = self.zoomFactor;
    [self setZoomFactor:zoomValue];
}

- (NSScrollView *)superScrollView{
    NSView *view = self.superview;
    if([view isKindOfClass:[NSClipView class]]){
        view = (NSScrollView *)[view nextResponder];
    }
    return (NSScrollView *)view;
}

- (void)drawRect:(NSRect)dirtyRect
{
    //[super drawRect:dirtyRect];
    
    // Drawing code here.
}


@end
