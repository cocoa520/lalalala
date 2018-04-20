//
//  IMBHoverChangeImageBtn.h
//  iOSFiles
//
//  Created by iMobie on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBHoverChangeImageBtn : NSButton
{
    @private
    NSImage *_normalImage;
    NSImage *_hoverImage;
    NSImage *_outerImage;
    NSImage *_normalAnimationImage;
    CALayer *_loadLayer;
    BOOL _istranferBtn;
    NSImage *_selfImage;
    
    BOOL _selected;
}

@property(nonatomic, assign)BOOL selected;


- (void)setHoverImage:(NSString *)hoverImage withSelfImage:(NSImage *)image;


- (void)startTranfering;
- (void)endTranfering;
@end
