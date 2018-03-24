//
//  IMBGeneralBtnCell.m
//  PhoneClean
//
//  Created by iMobie on 6/17/15.
//  Copyright (c) 2015 imobie.com. All rights reserved.
//

#import "IMBGeneralBtnCell.h"
#import "StringHelper.h"
#import "IMBSoftWareInfo.h"
@implementation IMBGeneralBtnCell
@synthesize leftImage = _leftImage;
@synthesize rightImage = _rightImage;
@synthesize middleImage = _middleImage;
@synthesize applyImage = _applyImage;
@synthesize downloadEnterImage = _downloadEnterImage;
@synthesize downloadImage = _downloadImage;
@synthesize isChange = _isChange;
@synthesize isBigBtn = _isBigBtn;
@synthesize isDrawBg = _isDrawBg;
@synthesize isApply = _isApply;
@synthesize downloadState = _downloadState;
@synthesize isSkin = _isSkin;
@synthesize isSkip = _isSkip;
- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView  {
    if (_isChange) {
        if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
            frame.origin.x = (controlView.frame.size.width - title.size.width - 12) / 2  - 90;
        }else {
            frame.origin.x = (controlView.frame.size.width - title.size.width - 12) / 2 ;
        }
        frame.origin.y -= 2;
    }else if (_isBigBtn){
        frame.origin.x = (controlView.frame.size.width - title.size.width) / 2;
        frame.origin.y -= 1;
    }else if (_isSkin) {
        if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
            frame.origin.x = (controlView.frame.size.width - title.size.width) / 2 - 80;
        }else if (_isApply) {
            frame.origin.x = (controlView.frame.size.width - title.size.width) / 2 + 6;
        }else {
            frame.origin.x = (controlView.frame.size.width - title.size.width) / 2 + 10;
        }
        frame.origin.y -= 2;
    }else if (_isSkip) {
        frame.origin.x = controlView.frame.size.width - title.size.width - 40;
        frame.origin.y -= 2;
    }else{
//        frame.origin.x = (controlView.frame.size.width - title.size.width) / 2;
        frame.origin.y -= 2;
    }
    return [super drawTitle:[self attributedTitle] withFrame:frame inView:controlView];
}

- (void)dealloc
{
    if (_leftImage != nil) {
        [_leftImage release];
        _leftImage = nil;
    }
    if (_rightImage != nil) {
        [_rightImage release];
        _rightImage = nil;
    }
    if (_middleImage != nil) {
        [_middleImage release];
        _middleImage = nil;
    }
    [super dealloc];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
//    if (!_isDrawBg) {
//        NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:cellFrame];
//        [clipPath setWindingRule:NSEvenOddWindingRule];
//        [clipPath addClip];
//        [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
//        [clipPath fill];
//        [clipPath closePath];
//    }
    if (_leftImage != nil && _middleImage != nil) {
        float xPos = 0;
        float yPos = 0;
        NSRect drawingRect;
        NSRect imageRect;
        // 开始绘制左边的部分
        imageRect.origin = NSZeroPoint;
        imageRect.size = _leftImage.size;
        drawingRect.origin.x = xPos;
        drawingRect.origin.y = yPos;
        drawingRect.size = imageRect.size;
        xPos += imageRect.size.width;
        
        if (drawingRect.size.width > 0) {
            [_leftImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }
        
        // 开始绘制中间的部分
        imageRect.size = _middleImage.size;
        int drawCount = ceil((cellFrame.size.width - _leftImage.size.width - _rightImage.size.width) / imageRect.size.width);
        for (int i = 0; i < drawCount; i++) {
            drawingRect.origin.x = xPos;
            drawingRect.origin.y = yPos;
            drawingRect.size = imageRect.size;
            xPos += imageRect.size.width;
            
            if (drawingRect.size.width > 0) {
                [_middleImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            }
        }
        if (_rightImage != nil) {
            // 开始绘制右边的部分
            imageRect.size = _rightImage.size;
            drawingRect.origin.x = cellFrame.size.width - imageRect.size.width;
            drawingRect.origin.y = yPos;
            drawingRect.size = imageRect.size;
            
            if (drawingRect.size.width > 0) {
                [_rightImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            }
        }
        
        if (_isSkin) {
            if (_isApply) {
                if (_applyImage != nil) {
                    imageRect.origin = NSZeroPoint;
                    imageRect.size = _applyImage.size;
                    
                    drawingRect.origin = NSMakePoint(20, (cellFrame.size.height - _applyImage.size.height) / 2);
                    drawingRect.size = _applyImage.size;
                    
                    [_applyImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                }
            }else {
                if (_downloadState) {
                    if (_downloadEnterImage != nil) {
                        imageRect.origin = NSZeroPoint;
                        imageRect.size = _downloadEnterImage.size;
                        
                        drawingRect.origin = NSMakePoint(24, (cellFrame.size.height - _downloadEnterImage.size.height) / 2);
                        drawingRect.size = _downloadEnterImage.size;
                        
                        [_downloadEnterImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                    }
                }else {
                    if (_downloadImage != nil) {
                        imageRect.origin = NSZeroPoint;
                        imageRect.size = _downloadImage.size;
                        
                        drawingRect.origin = NSMakePoint(24, (cellFrame.size.height - _downloadImage.size.height) / 2);
                        drawingRect.size = _downloadImage.size;
                        
                        [_downloadImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                    }
                }
            }
        }
    }
    [super drawWithFrame:cellFrame inView:controlView];
}

@end
