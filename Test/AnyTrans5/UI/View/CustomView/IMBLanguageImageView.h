//
//  IMBLanguageImageView.h
//  iMobieTrans
//
//  Created by iMobie on 8/29/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBLanguageImageView : NSImageView {
    NSImage *_mouseEnteredImage;
    NSImage *_mouseDownImage;
    BOOL _isEntered;
    BOOL _isClicked;
    NSTrackingArea *_trackingArea;
    NSString *_category;
}

@property (nonatomic, assign) BOOL isClicked;

- (void)setChangeEnteredImageAndDownImage:(NSString *)imageName withCategory:(NSString *)category;
- (void)setIsEntered:(BOOL)isEntered;
- (void)setIsClicked:(BOOL)isClicked;

@end
