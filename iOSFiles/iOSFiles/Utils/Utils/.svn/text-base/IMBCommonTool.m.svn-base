//
//  IMBCommonTool.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/14.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBCommonTool.h"
#import "IMBSingleBtnAlertController.h"
#import "IMBTwoBtnsAlertController.h"
#import "IMBBorderRectAndColorView.h"
#import "IMBViewAnimation.h"
#import "IMBGeneralButton.h"
#import "IMBAlertSupeView.h"

#import <objc/runtime.h>

static CGFloat IMBAlertShowInterval = 0.2f;

@implementation IMBCommonTool

+ (void)setViewBgWithView:(NSView *)view color:(NSColor *)bgColor delta:(CGFloat)delta radius:(CGFloat)radius dirtyRect:(NSRect)dirtyRect {
    dirtyRect.origin.x = 0;
    dirtyRect.origin.y = 0;
    dirtyRect.size.width = view.frame.size.width;
    dirtyRect.size.height = view.frame.size.height;
    NSRect newRect = NSMakeRect(dirtyRect.origin.x+delta, dirtyRect.origin.y+delta, dirtyRect.size.width-delta*2, dirtyRect.size.height - delta*2);
    NSBezierPath *bgPath = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:radius yRadius:radius];
    [bgColor set];
    [bgPath fill];
}

+ (void)showSingleBtnAlertInMainWindow:(BOOL)isMainWindow btnTitle:(NSString *)btnTitle msgText:(NSString *)msgText btnClickedBlock:(void(^)(void))btnClickedBlock {
    [self showSingleBtnAlertInMainWindow:isMainWindow alertTitle:@"" btnTitle:btnTitle msgText:msgText btnClickedBlock:btnClickedBlock];
}
+ (void)showSingleBtnAlertInMainWindow:(BOOL)isMainWindow  alertTitle:(NSString *)alertTitle btnTitle:(NSString *)btnTitle msgText:(NSString *)msgText btnClickedBlock:(void (^)(void))btnClickedBlock {
    IMBAlertSupeView *inView;
    __block IMBSingleBtnAlertController *alert = [[IMBSingleBtnAlertController alloc] initWithNibName:@"IMBSingleBtnAlertController" bundle:nil];
    if (!isMainWindow) {
        inView = objc_getAssociatedObject([NSApplication sharedApplication], &kIMBMainPageWindowAlertView);
    }else {
        inView = objc_getAssociatedObject([NSApplication sharedApplication], &kIMBMainWindowAlertView);
    }
    [inView addSubview:alert.view];
    [inView setHidden:NO];
    [alert.singleBtnViewMsgLabel setStringValue:msgText];
    if (btnTitle) {
        [alert.singleBtnViewOKBtn setTitle:btnTitle];
    }else {
        [alert.singleBtnViewOKBtn setTitle:@"OK"];
    }
    
    [alert.view setFrameOrigin:NSMakePoint((inView.frame.size.width - alert.view.frame.size.width)/2.f, inView.frame.size.height)];
    NSRect newF = alert.view.frame;
    newF.origin.y = inView.frame.size.height - newF.size.height + 10.f;
//    alert.view.frame = newF;
    [alert.view setWantsLayer:YES];
    [IMBViewAnimation animationWithView:alert.view frame:newF timeInterval:IMBAlertShowInterval disable:NO completion:^{
        
    }];
    alert.singleBtnOKClicked = ^ {
        if (btnClickedBlock) {
            btnClickedBlock();
        }
        NSRect newF = alert.view.frame;
        newF.origin.y = inView.frame.size.height;
        [IMBViewAnimation animationWithView:alert.view frame:newF timeInterval:IMBAlertShowInterval disable:NO completion:^{
            [alert.view removeFromSuperview];
            [inView setHidden:YES];
            [alert release];
            alert = nil;
            
        }];
        
    };
    
    
}

+ (void)showTwoBtnsAlertInMainWindow:(BOOL)isMainWindow firstBtnTitle:(NSString *)firstTitle secondBtnTitle:(NSString *)secondTitle msgText:(NSString *)msgText firstBtnClickedBlock:(void(^)(void))firstBtnClickedBlock secondBtnClickedBlock:(void(^)(void))secondBtnClickedBlock {
    [self showTwoBtnsAlertInMainWindow:isMainWindow alertTitle:@"" firstBtnTitle:firstTitle secondBtnTitle:secondTitle msgText:msgText firstBtnClickedBlock:firstBtnClickedBlock secondBtnClickedBlock:secondBtnClickedBlock];
}
+ (void)showTwoBtnsAlertInMainWindow:(BOOL)isMainWindow  alertTitle:(NSString *)alertTitle firstBtnTitle:(NSString *)firstTitle secondBtnTitle:(NSString *)secondTitle msgText:(NSString *)msgText firstBtnClickedBlock:(void (^)(void))firstBtnClickedBlock secondBtnClickedBlock:(void (^)(void))secondBtnClickedBlock {
    IMBAlertSupeView *inView;
    __block IMBTwoBtnsAlertController *alert = [[IMBTwoBtnsAlertController alloc] initWithNibName:@"IMBTwoBtnsAlertController" bundle:nil];
    if (!isMainWindow) {
        inView = objc_getAssociatedObject([NSApplication sharedApplication], &kIMBMainPageWindowAlertView);
    }else {
        inView = objc_getAssociatedObject([NSApplication sharedApplication], &kIMBMainWindowAlertView);
    }
    [inView addSubview:alert.view];
    [inView setHidden:NO];
    [alert.twoBtnsViewMsgView setStringValue:msgText];
    if (secondTitle) {
        [alert.twoBtnsViewOKBtn setTitle:secondTitle];
    }else {
        [alert.twoBtnsViewOKBtn setTitle:@"OK"];
    }
    if (firstTitle) {
        [alert.twoBtnsViewCancelBtn setTitle:firstTitle];
    }else {
        [alert.twoBtnsViewCancelBtn setTitle:@"Cancel"];
    }
    [alert.view setFrameOrigin:NSMakePoint((inView.frame.size.width - alert.view.frame.size.width)/2.f, inView.frame.size.height)];
    NSRect newF = alert.view.frame;
    newF.origin.y = inView.frame.size.height - newF.size.height + 10.f;
    [alert.view setWantsLayer:YES];
    [IMBViewAnimation animationWithView:alert.view frame:newF timeInterval:IMBAlertShowInterval disable:NO completion:^{
        
    }];
    
    alert.twoBtnsViewOKClicked = ^ {
        if (secondBtnClickedBlock) {
            secondBtnClickedBlock();
        }
        
        NSRect newF = alert.view.frame;
        newF.origin.y = inView.frame.size.height;
        [IMBViewAnimation animationWithView:alert.view frame:newF timeInterval:IMBAlertShowInterval disable:NO completion:^{
            [alert.view removeFromSuperview];
            [inView setHidden:YES];
            [alert release];
            alert = nil;
            
        }];
        
    };
    
    alert.twoBtnsViewCancelClicked = ^ {
        if (firstBtnClickedBlock) {
            firstBtnClickedBlock();
        }
        
        NSRect newF = alert.view.frame;
        newF.origin.y = inView.frame.size.height;
        [IMBViewAnimation animationWithView:alert.view frame:newF timeInterval:IMBAlertShowInterval disable:NO completion:^{
            [alert.view removeFromSuperview];
            [inView setHidden:YES];
            [alert release];
            alert = nil;
        }];
        
    };
    
}

@end
