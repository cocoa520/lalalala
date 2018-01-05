//
//  IMBMergeCloneAppViewController.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/26.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBMergeCloneAppViewController.h"
#import "IMBAnimation.h"
#import "StringHelper.h"
#import "NSColor+Category.h"

@implementation IMBMergeCloneAppViewController
@synthesize itemArray = _itemArray;
@synthesize isToDevice = _isToDevice;
@synthesize sourceApps = _sourceApps;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (int)showTitleString:(NSString *)title OkButton:(NSString *)OkText CancelButton:(NSString *)cancelText TargetiPod:(IMBiPod *)targetiPod sourceiPod:(IMBiPod *)sourceiPod SuperView:(NSView *)superView {
    [_arrayController removeObjects:_itemArray];
    self.itemArray = [NSMutableArray array];
    _mainView = superView;
    [superView setWantsLayer:YES];
    _endRunloop = NO;
    int result = -1;
    _sourceiPod = [sourceiPod retain];
    _targetiPod = [targetiPod retain];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_alertView];
    [_cancelBtn reSetInit:cancelText WithPrefixImageName:@"cancal"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelText]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor blackColor] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_cancelBtn setAttributedTitle:attributedTitles];
    [_cancelBtn setIsReslutVeiw:YES];
    
    NSMutableAttributedString *attributedTitles2 = [[[NSMutableAttributedString alloc]initWithString:title]autorelease];
    [attributedTitles2 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, title.length)];
    [attributedTitles2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, title.length)];
    [attributedTitles2 addAttribute:NSForegroundColorAttributeName value:[NSColor blackColor] range:NSMakeRange(0, title.length)];

    [_okBtn reSetInit:OkText WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:OkText]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_okBtn setAttributedTitle:attributedTitles1];
    
    [_okBtn setTarget:self];
    [_okBtn setAction:@selector(OkBtnClick:)];
    [_cancelBtn setTarget:self];
    [_cancelBtn setAction:@selector(cancelBtnClick:)];
    [_mainTitle setStringValue:title];
    [_mainTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_bgView setWantsLayer:YES];
    [_bgView.layer setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)].toCGColor];
    [_bgView.layer setCornerRadius:5];
    [_bgView.layer setBorderWidth:1.0];
    [self configCollectionView];
    
    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
    NSInteger result1 = NSRunContinuesResponse;
    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [NSApp endModalSession:session];
    result = _result;
    return result;
}

- (void)loadAlertView:(NSView *)view alertView:(IMBBorderRectAndColorView *)alertView {
    [self setupAlertRect:alertView];
    if (![self.view.subviews containsObject:alertView]) {
        [self.view addSubview:alertView];
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [alertView.layer addAnimation:[IMBAnimation moveY:0.2 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-400] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(view.bounds) - NSWidth(alertView.frame)) / 2), NSMaxY(view.bounds) - NSHeight(alertView.frame) + 10, NSWidth(alertView.frame), NSHeight(alertView.frame))];
    }];
}

- (void)setupAlertRect:(IMBBorderRectAndColorView *)alertView {
    [alertView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    NSRect rect = [alertView frame];
    [alertView setWantsLayer:YES];
    [alertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - NSWidth(rect)) / 2), NSMaxY(self.view.bounds), NSWidth(rect), NSHeight(rect))];
}

- (void)unloadAlertView:(IMBBorderRectAndColorView *)alertView {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [alertView.layer addAnimation:[IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:400] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - alertView.frame.size.width) / 2), NSMaxY(self.view.bounds), alertView.frame.size.width, alertView.frame.size.height)];
        [self.view removeFromSuperview];
    }];
}

- (void)OkBtnClick:(id)sender {
    _endRunloop = YES;
    _result = 1;
    [self unloadAlertView:_alertView];
}

- (void)cancelBtnClick:(id)sender {
    _endRunloop = YES;
    _result = 0;
    [self unloadAlertView:_alertView];
}

- (void)configCollectionView {
    [_collectionView setMaxNumberOfColumns:8];
    NSMutableArray *sourceAppArray = nil;
    if (_isToDevice) {
        sourceAppArray = [_sourceApps retain];
    }else {
        sourceAppArray = [_sourceiPod.applicationManager.appEntityArray mutableCopy];
    }
    NSArray *targetAppArray = _targetiPod.applicationManager.appEntityArray;
    NSMutableArray *importAppM = [[NSMutableArray alloc]init];
    for (IMBAppEntity *app in sourceAppArray) {
        [app setAppNameAttributedString];
        int i = 0;
        for (IMBAppEntity *targetApp in targetAppArray) {
            if ([targetApp.appKey isEqualToString:app.appKey]) {
                i = 1;
                break;
            }
        }
        if (i == 0) {
            [importAppM addObject:app];
        }
    }
//    [self setItemArray:importAppM];
    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"_itemArray:%d",importAppM.count]];
    [_arrayController addObjects:importAppM];
    [_collectionView setNeedsDisplay:YES];

    [sourceAppArray release];
}


-(void)dealloc {
    if (_sourceiPod != nil) {
        [_sourceiPod release];
        [_sourceiPod release];
    }
    if (_targetiPod != nil) {
        [_targetiPod release];
        _targetiPod = nil;
    }

    [super dealloc];
}

@end
