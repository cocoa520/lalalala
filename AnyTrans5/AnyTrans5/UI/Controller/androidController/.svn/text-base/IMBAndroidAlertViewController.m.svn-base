//
//  IMBAndroidAlertViewController.m
//  AnyTrans
//
//  Created by smz on 17/8/16.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBAndroidAlertViewController.h"
#import "IMBGeneralButton.h"
#import "StringHelper.h"
#import "IMBAnimation.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
#import "IMBHelper.h"
#import "SystemHelper.h"
#import "IMBLackCornerView.h"
#import "NSString+Category.h"
#import "IMBAndroidViewController.h"
#import "IMBTransferError.h"
#import "IMBCenterTextFieldCell.h"

@implementation IMBAndroidAlertViewController
@synthesize android = _android;
@synthesize delegate = _delegate;

#pragma mark - 切换皮肤
- (void)changeSkin:(NSNotification *)notification {
    
    _warningTextFieldInitPoint = _warningTextField.frame.origin;
    [self setupAlertRect:_confirmAlertView];
    [self setupAlertRect:_warningAlertView];
    [self setupAlertRect:_noDataAlertView];
    
}

-(void)awakeFromNib{
    _warningTextFieldInitPoint = _warningTextField.frame.origin;
    [self setupAlertRect:_confirmAlertView];
    [self setupAlertRect:_warningAlertView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doAndriodDeviceDisconnect:) name:Andriod_Device_Disconnect object:nil];
}

#pragma mark - 单个按钮的警告框
- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)okButtonString SuperView:(NSView *)superView {
    [(NSView *)[NSApplication sharedApplication].mainWindow.contentView addSubview:superView];
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_warningAlertView];
    [_warnAlertImage setImage:[StringHelper imageNamed:@"alert_icon"]];
    _endRunloop = NO;
    int result = -1;
    NSSize size;
    //文本样式
    NSMutableAttributedString *alertAttributedStr = [StringHelper measureForStringDrawing:alertText withFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0] withLineSpacing:0 withMaxWidth:294 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]  withAlignment:NSLeftTextAlignment];
    [_warningTextField setAttributedStringValue:alertAttributedStr];
    [_warningTextField setFrameOrigin:_warningTextFieldInitPoint];
    if (size.height >= 34 && size.height < 48) {
        [_warningTextField setFrameOrigin:NSMakePoint(_warningTextField.frame.origin.x, _warningTextField.frame.origin.y-16)];
    }else if(size.height >= 48 && size.height < 68) {
        [_warningTextField setFrameOrigin:NSMakePoint(_warningTextField.frame.origin.x, _warningTextField.frame.origin.y+4)];
    }else if(size.height >= 68) {
        [_warningTextField setFrameOrigin:NSMakePoint(_warningTextField.frame.origin.x, _warningTextField.frame.origin.y+16)];
    }
    //按钮样式
    if ([okButtonString isEqualToString:@""]) {
        [_okBtn setHidden:YES];
    }else {
        [_okBtn setHidden:NO];
        NSSize okBtnRectSize = [IMBHelper calcuTextBounds:okButtonString fontSize:12.0].size;
        int width = 0;
        
        [_okBtn reSetInit:okButtonString WithPrefixImageName:@"pop"];
        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okButtonString]autorelease];
        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okButtonString.length)];
        [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okButtonString.length)];
        [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okButtonString.length)];
        [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
        [_okBtn setAttributedTitle:attributedTitles];
        if (okBtnRectSize.width > 76) {
            width = ceil(okBtnRectSize.width + 20);
            [_okBtn setFrame:NSMakeRect(NSMaxX(_warningAlertView.bounds) - width - 25, NSMinY(_warningAlertView.bounds) + 18, width, _okBtn.frame.size.height)];
        }else {
            [_okBtn setFrame:NSMakeRect(NSMaxX(_warningAlertView.bounds) - _okBtn.frame.size.width - 25, NSMinY(_warningAlertView.bounds) + 18, _okBtn.frame.size.width, _okBtn.frame.size.height)];
        }
    }
    [_okBtn setTarget:self];
    [_okBtn setAction:@selector(okBtnOperation:)];
    return result;
}
- (void)okBtnOperation:(id)sender{
    [self unloadAlertView:_warningAlertView];
}

#pragma mark - 两个按钮的弹框
- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText CancelButton:(NSString *)cancelText SuperView:(NSView *)superView {
    [(NSView *)[NSApplication sharedApplication].mainWindow.contentView addSubview:superView];
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_confirmAlertView];
    _endRunloop = NO;
    int result = -1;
    [_cancelBtn reSetInit:cancelText WithPrefixImageName:@"cancal"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelText]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_cancelBtn setAttributedTitle:attributedTitles];
    
    [_cancelBtn setIsReslutVeiw:YES];
    [_removeBtn reSetInit:OkText WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:OkText]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_removeBtn setAttributedTitle:attributedTitles1];
    
    [_removeBtn setTarget:self];
    [_removeBtn setAction:@selector(removeBtnOperation:)];
    [_removeBtn setNeedsDisplay:YES];

    [_cancelBtn setTarget:self];
    [_cancelBtn setAction:@selector(cancelBtnOperation:)];
    [_cancelBtn setNeedsDisplay:YES];
    NSSize cancelBtnRectSize = [IMBHelper calcuTextBounds:cancelText fontSize:12.0].size;
    NSSize removeBtnRectSize = [IMBHelper calcuTextBounds:cancelText fontSize:12.0].size;
    int width = 0;
    if (cancelBtnRectSize.width > 76 || removeBtnRectSize.width > 76) {
        if (cancelBtnRectSize.width > removeBtnRectSize.width) {
            width = ceil(cancelBtnRectSize.width + 20);
        }else {
            width = ceil(removeBtnRectSize.width + 20);
        }
        [_removeBtn setFrame:NSMakeRect(NSMaxX(_confirmAlertView.bounds) - width - 25, NSMinY(_confirmAlertView.bounds) + 18, width, _removeBtn.frame.size.height)];
        [_cancelBtn setFrame:NSMakeRect(NSMaxX(_confirmAlertView.bounds) - width*2 - 25 - 15, NSMinY(_confirmAlertView.bounds) + 18, width, _cancelBtn.frame.size.height)];
    }else {
        [_removeBtn setFrame:NSMakeRect(NSMaxX(_confirmAlertView.bounds) - _removeBtn.frame.size.width - 25, NSMinY(_confirmAlertView.bounds) + 18, _removeBtn.frame.size.width, _removeBtn.frame.size.height)];
        [_cancelBtn setFrame:NSMakeRect(NSMaxX(_confirmAlertView.bounds) - _removeBtn.frame.size.width - _cancelBtn.frame.size.width - 25 - 15, NSMinY(_confirmAlertView.bounds) + 18, _cancelBtn.frame.size.width, _cancelBtn.frame.size.height)];
    }
    //    //文字样式
    NSSize size;
    
    NSMutableAttributedString *alertAttributedStr = [StringHelper measureForStringDrawing:alertText withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0 withMaxWidth:294 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withAlignment:NSLeftTextAlignment];
    
    [_confirmTextField setAttributedStringValue:alertAttributedStr];
    
    //加一个runloop
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

- (void)removeBtnOperation:(id)sender {
    _endRunloop = YES;
    _result = 1;
    [self unloadAlertView:_confirmAlertView];
}

- (void)cancelBtnOperation:(id)sender {
    _endRunloop = YES;
    _result = 0;
    [self unloadAlertView:_confirmAlertView];
}

#pragma mark - 信任窗口
//显示信任窗口
- (int)showAlertTrustView:(NSView *)superView withDic:(NSDictionary *)dic withEnum:(int)enumCount{
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setWantsLayer:YES];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_trustAlertView];
    [_trustAlertView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _trustAlertView.frame.size.width) / 2), superView.frame.size.height, _trustAlertView.frame.size.width, _trustAlertView.frame.size.height)];
    [self.view setWantsLayer:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(bView.frame.origin.x + floor((bView.frame.size.width - _trustAlertView.frame.size.width) / 2), bView.frame.size.height - _trustAlertView.frame.size.height + 8, _trustAlertView.frame.size.width, _trustAlertView.frame.size.height);
        [context setDuration:0.3];
        [[_trustAlertView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
    }];
    [_trustAlertView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
        if (enumCount == 1) {
            NSImage *image = [StringHelper imageNamed:@"other_allowdebugging_s"];
            [_trustAlertSubTitle setStringValue:CustomLocalizedString(@"TrustUsbDebug_Tips2", nil)];
            [_trustAlertImgView setImage:image];
        }else if (enumCount == 2){
            [_trustAlertImgView setImage:[StringHelper imageNamed:@"other_superuser"]];
            [_trustAlertSubTitle setStringValue:CustomLocalizedString(@"TrustUsbDebug_Tips2", nil)];
        }
        
        NSMutableAttributedString *mainAs = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"TrustUsbDebug_Tips1", nil)];
        NSRange mainRange = NSMakeRange(0, mainAs.length);
        [mainAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:26] range:mainRange];
        [mainAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:mainRange];
        [mainAs setAlignment:NSCenterTextAlignment range:mainRange];
        [_trustAlertMainTitle setAttributedStringValue:mainAs];
        [mainAs release], mainAs = nil;
    
    
    
    [_trustAlertSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];

    //按钮样式
    NSString *okButtonString = CustomLocalizedString(@"TrustView_id_2", nil);
    [_trustAlertOkBtn setHidden:NO];
    [_trustAlertOkBtn reSetInit:okButtonString WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okButtonString]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_trustAlertOkBtn setAttributedTitle:attributedTitles];
    [_trustAlertOkBtn setTarget:self];
    [_trustAlertOkBtn setAction:@selector(trustOperation:)];
    _trustAlertOkBtn.dic = (NSMutableDictionary *)dic;
    [_trustAlertOkBtn setNeedsDisplay:YES];
    return 1;
}
//点击信任OK按钮
- (void)trustOperation:(id )sender {
    if ([_trustAlertView superview]) {
        IMBGeneralButton *btn = (IMBGeneralButton *)sender;
        NSDictionary *dic = btn.dic;
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [_trustAlertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:456] repeatCount:1] forKey:@"moveY"];
        } completionHandler:^{
            [_trustAlertView.layer removeAnimationForKey:@"moveY"];
            [_trustAlertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - _trustAlertView.frame.size.width) / 2), NSMaxY(self.view.bounds), _trustAlertView.frame.size.width, _trustAlertView.frame.size.height)];
            [self.view removeFromSuperview];
            if (_delegate != nil && [_delegate respondsToSelector:@selector(trustBtnOperation:)])
            {
                    [_delegate trustBtnOperation:dic];
                }
            
        }];
    }
}

#pragma mark - 设备提权窗口
//提示设备提权窗口窗口
- (int)showImproveAuthorityAlertView:(NSView *)superView isVersionHighThan6:(BOOL)higher{
    _rootChooseResult = 0;
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setWantsLayer:YES];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_rootAlertView];
    if (higher) {
        NSImage *image = [StringHelper imageNamed:@"other_allowcontact_s"];
        [_rootAlertImageView setImage:image];
    }else {
        [_rootAlertImageView setImage:[StringHelper imageNamed:@"other_allowcontact5.0"]];
    }
    
    [_rootAlertView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _rootAlertView.frame.size.width) / 2), superView.frame.size.height, _rootAlertView.frame.size.width, _rootAlertView.frame.size.height)];
    [self.view setWantsLayer:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(bView.frame.origin.x + floor((bView.frame.size.width - _rootAlertView.frame.size.width) / 2), bView.frame.size.height - _rootAlertView.frame.size.height + 8, _rootAlertView.frame.size.width, _rootAlertView.frame.size.height);
        [context setDuration:0.3];
        [[_rootAlertView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
    }];
    [_rootAlertView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"MG_GetPermission_txt", nil)];
    NSRange range = NSMakeRange(0, as.length);
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Thin" size:25] range:range];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:25] range:range];
    }
    [as setAlignment:NSCenterTextAlignment range:range];
    [_rootAlertMainTitle setAttributedStringValue:as];
    [as release], as = nil;
    [_rootAlertMainTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_rootAlertSubTitle setStringValue:CustomLocalizedString(@"RequestPermisson_Txt", nil)];
    [_rootAlertSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    [_rootWarningTextView setDelegate:self];
    NSString *promptStr = CustomLocalizedString(@"SET_APK_PERMSISION_VIEW", nil);
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_rootWarningTextView setLinkTextAttributes:linkAttributes];
    NSMutableAttributedString *promptAs = [[NSMutableAttributedString alloc] initWithString:promptStr];
    NSRange promRange = NSMakeRange(0, promptAs.length);
    [promptAs addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0,promRange.length)];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:NSMakeRange(0,promRange.length)];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0,promRange.length)];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:promRange];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:3.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,promptAs.length)];
    [promptAs addAttribute:NSLinkAttributeName value:promptStr range:promRange];
    [[_rootWarningTextView textStorage] setAttributedString:promptAs];
    [promptAs release], promptAs = nil;
    [mutParaStyle release],  mutParaStyle = nil;
    
    _waitTime = 10;
    //按钮样式
    NSString *okButtonString = [CustomLocalizedString(@"Button_Ok", nil) stringByAppendingString:[NSString stringWithFormat:@" (%ld)",(long)_waitTime]];
    [_rootAlertOkBtn setHidden:NO];
    [_rootAlertOkBtn reSetInit:okButtonString WithPrefixImageName:@"pop"];
    [_rootAlertOkBtn setFontSize:14.0];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okButtonString]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_rootAlertOkBtn setAttributedTitle:attributedTitles];
    [_rootAlertOkBtn setEnabled:NO];
    [_rootAlertOkBtn setTarget:self];
    [_rootAlertOkBtn setTag:2];
    [_rootAlertOkBtn setAction:@selector(improveAuthorityOkOperation:)];
    [_rootAlertOkBtn setNeedsDisplay:YES];
    
    NSString *cancelText = CustomLocalizedString(@"Button_Cancel", nil);
    [_rootAlertCalcelBtn reSetInit:cancelText WithPrefixImageName:@"cancal"];
    [_rootAlertCalcelBtn setFontSize:14.0];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:cancelText]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_rootAlertCalcelBtn setAttributedTitle:attributedTitles1];
    [_rootAlertCalcelBtn setIsReslutVeiw:YES];
    [_rootAlertCalcelBtn setTarget:self];
    [_rootAlertCalcelBtn setAction:@selector(improveAuthorityCancelOperation:)];
    [_rootAlertCalcelBtn setNeedsDisplay:YES];
    if ([_rootAlertTimer isValid]) {
        [_rootAlertTimer invalidate];
        _rootAlertTimer = nil;
    }
    _rootAlertTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(decreaseSecond) userInfo:nil repeats:YES];
    //加一个runloop
    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
    NSInteger result1 = NSRunContinuesResponse;
    _endRunloop = NO;
    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [NSApp endModalSession:session];
    return _rootChooseResult;
}
//点击设备提权窗口OK按钮
- (void)improveAuthorityOkOperation:(id)sender {
    _rootChooseResult = 1;
    _endRunloop = YES;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_rootAlertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:456] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [_rootAlertView.layer removeAnimationForKey:@"moveY"];
        [_rootAlertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - _rootAlertView.frame.size.width) / 2), NSMaxY(self.view.bounds), _rootAlertView.frame.size.width, _rootAlertView.frame.size.height)];
        [self.view removeFromSuperview];
    }];
}
//点击设备提权窗口Cancel按钮
- (void)improveAuthorityCancelOperation:(id)sender {
    _rootChooseResult = 0;
    _endRunloop = YES;
    if ([_rootAlertTimer isValid]) {
        [_rootAlertTimer invalidate];
        _rootAlertTimer = nil;
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_rootAlertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:456] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [_rootAlertView.layer removeAnimationForKey:@"moveY"];
        [_rootAlertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - _rootAlertView.frame.size.width) / 2), NSMaxY(self.view.bounds), _rootAlertView.frame.size.width, _rootAlertView.frame.size.height)];
        [self.view removeFromSuperview];
    }];
}

#pragma mark - textView delegete
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex{
    NSString *overStr = CustomLocalizedString(@"SET_APK_PERMSISION_VIEW", nil);
    NSString *promptStr = CustomLocalizedString(@"MoveToIOSNoData_OpenAppLinkTips", nil);
    if ([link isEqualToString:overStr] || [link isEqualToString:promptStr]) {
        if (_android != nil) {
            [_android.adPermisson promptToDeviceSetPermisson];
        }
    }
    return YES;
}
//提权时间
- (void)decreaseSecond {
    _waitTime --;
    NSString *okButtonString = [CustomLocalizedString(@"Button_Ok", nil) stringByAppendingString:[NSString stringWithFormat:@" (%ld)",(long)_waitTime]];
    [_rootAlertOkBtn setHidden:NO];
    [_rootAlertOkBtn reSetInit:okButtonString WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okButtonString]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_rootAlertOkBtn setEnabled:NO];
    [_rootAlertOkBtn setAttributedTitle:attributedTitles];
    if (_waitTime == 0) {
        if ([_rootAlertTimer isValid]) {
            [_rootAlertTimer invalidate];
            _rootAlertTimer = nil;
        }
        NSString *okButtonString = CustomLocalizedString(@"Button_Ok", nil);
        [_rootAlertOkBtn setHidden:NO];
        [_rootAlertOkBtn reSetInit:okButtonString WithPrefixImageName:@"pop"];
        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okButtonString]autorelease];
        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okButtonString.length)];
        [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okButtonString.length)];
        [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okButtonString.length)];
        [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
        [_rootAlertOkBtn setAttributedTitle:attributedTitles];
        [_rootAlertOkBtn setEnabled:YES];
        [_rootAlertOkBtn setTarget:self];
        [_rootAlertOkBtn setTag:2];
        [_rootAlertOkBtn setAction:@selector(improveAuthorityOkOperation:)];
        [_rootAlertOkBtn setNeedsDisplay:YES];
    }
}

#pragma mark - 窗口上拉和收回
- (void)setupAlertRect:(IMBBorderRectAndColorView *)alertView {
    [alertView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    NSRect rect = [alertView frame];
    [alertView setWantsLayer:YES];
    [alertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - NSWidth(rect)) / 2), NSMaxY(self.view.bounds), NSWidth(rect), NSHeight(rect))];
}
//窗口下拉
- (void)loadAlertView:(NSView *)view alertView:(IMBBorderRectAndColorView *)alertView
{
    [self setupAlertRect:alertView];
    if (![self.view.subviews containsObject:alertView]) {
        [self.view addSubview:alertView];
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [alertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-alertView.bounds.size.height + 10]  repeatCount:0] forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(view.bounds) - NSWidth(alertView.frame)) / 2), NSMaxY(view.bounds) - NSHeight(alertView.frame) + 10, NSWidth(alertView.frame), NSHeight(alertView.frame))];
    }];
}
//窗口收回
- (void)unloadAlertView:(IMBBorderRectAndColorView *)alertView {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [alertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:alertView.frame.size.height] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(_mainView.bounds) - alertView.frame.size.width) / 2), NSMaxY(_mainView.bounds), alertView.frame.size.width, alertView.frame.size.height)];
        [alertView removeFromSuperview];
        [self.view removeFromSuperview];
    }];
}

#pragma mark - 媒体设备MTP模式窗口
- (int)showMediaDeviceMTPAlertView:(NSView *)superView withDic:(NSDictionary *)dic {
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setWantsLayer:YES];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_openMTPAlertView];
    [_openMTPAlertView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _openMTPAlertView.frame.size.width) / 2), superView.frame.size.height, _openMTPAlertView.frame.size.width, _openMTPAlertView.frame.size.height)];
    [self.view setWantsLayer:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(bView.frame.origin.x + floor((bView.frame.size.width - _openMTPAlertView.frame.size.width) / 2), bView.frame.size.height - _openMTPAlertView.frame.size.height + 8, _openMTPAlertView.frame.size.width, _openMTPAlertView.frame.size.height);
        [context setDuration:0.3];
        [[_openMTPAlertView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
    }];
    [_openMTPAlertView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_openMTPInnerView setIsDrawFrame:YES];
    [_openMTPInnerView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)]];
    [_openMTPAlertMainTitle setStringValue:CustomLocalizedString(@"OpenMTPModelHeader", nil)];
    [_openMTPAlertMainTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_openMTPFirstLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_openMTPFirstLabel setStringValue:CustomLocalizedString(@"OpenMTPModel_1", nil)];
    [_openMTPSecondLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_openMTPSecondLabel setStringValue:CustomLocalizedString(@"OpenMTPModel_2", nil)];
    [_openMTPThirdLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_openMTPThirdLabel setStringValue:CustomLocalizedString(@"OpenMTPModel_3", nil)];
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {
        [_openMTPFirstImgView setImage:[StringHelper imageNamed:@"other_MTP1"]];
        [_openMTPSecondImgView setImage:[StringHelper imageNamed:@"other_MTP2"]];
        [_openMTPThirdImgView setImage:[StringHelper imageNamed:@"other_MTP3"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        [_openMTPFirstImgView setImage:[StringHelper imageNamed:@"other_MTP1_ar"]];
        [_openMTPSecondImgView setImage:[StringHelper imageNamed:@"other_MTP2_ar"]];
        [_openMTPThirdImgView setImage:[StringHelper imageNamed:@"other_MTP3_ar"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        [_openMTPFirstImgView setImage:[StringHelper imageNamed:@"other_MTP1_ch"]];
        [_openMTPSecondImgView setImage:[StringHelper imageNamed:@"other_MTP2_ch"]];
        [_openMTPThirdImgView setImage:[StringHelper imageNamed:@"other_MTP3_ch"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
        [_openMTPFirstImgView setImage:[StringHelper imageNamed:@"other_MTP1_de"]];
        [_openMTPSecondImgView setImage:[StringHelper imageNamed:@"other_MTP2_de"]];
        [_openMTPThirdImgView setImage:[StringHelper imageNamed:@"other_MTP3_de"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == FrenchLanguage) {
        [_openMTPFirstImgView setImage:[StringHelper imageNamed:@"other_MTP1_fr"]];
        [_openMTPSecondImgView setImage:[StringHelper imageNamed:@"other_MTP2_fr"]];
        [_openMTPThirdImgView setImage:[StringHelper imageNamed:@"other_MTP3_fr"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        [_openMTPFirstImgView setImage:[StringHelper imageNamed:@"other_MTP1_jp"]];
        [_openMTPSecondImgView setImage:[StringHelper imageNamed:@"other_MTP2_jp"]];
        [_openMTPThirdImgView setImage:[StringHelper imageNamed:@"other_MTP3_jp"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == SpanishLanguage) {
        [_openMTPFirstImgView setImage:[StringHelper imageNamed:@"other_MTP1_sp"]];
        [_openMTPSecondImgView setImage:[StringHelper imageNamed:@"other_MTP2_sp"]];
        [_openMTPThirdImgView setImage:[StringHelper imageNamed:@"other_MTP3_sp"]];
    }
    
    //按钮样式
    NSString *okButtonString = CustomLocalizedString(@"TrustView_id_2", nil);
    [_openMTPAlertOkBtn setHidden:NO];
    [_openMTPAlertOkBtn reSetInit:okButtonString WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okButtonString]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_openMTPAlertOkBtn setAttributedTitle:attributedTitles];
    [_openMTPAlertOkBtn setTarget:self];
    _openMTPAlertOkBtn.dic = (NSMutableDictionary *)dic;
    [_openMTPAlertOkBtn setAction:@selector(mediaDeviceMTPOkOperation:)];
    [_openMTPAlertOkBtn setNeedsDisplay:YES];
    return 1;
}

- (void)mediaDeviceMTPOkOperation:(id)sender {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_openMTPAlertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:456] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [_openMTPAlertView.layer removeAnimationForKey:@"moveY"];
        [_openMTPAlertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - _openMTPAlertView.frame.size.width) / 2), NSMaxY(self.view.bounds), _openMTPAlertView.frame.size.width, _openMTPAlertView.frame.size.height)];
        [self.view removeFromSuperview];
    }];
}

#pragma mark - 设备断开时,弹框全部消失
- (void)doAndriodDeviceDisconnect:(NSNotification *)notification
{
    _rootChooseResult = 0;
    _endRunloop = YES;
    if ([_warningAlertView superview]) {
        [self unloadAlertView:_warningAlertView];
    }else if ([_confirmAlertView superview]){
        [self unloadAlertView:_confirmAlertView];
    }else if ([_trustAlertView superview]){
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [_trustAlertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:456] repeatCount:1] forKey:@"moveY"];
        } completionHandler:^{
            [_trustAlertView.layer removeAnimationForKey:@"moveY"];
            [_trustAlertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - _trustAlertView.frame.size.width) / 2), NSMaxY(self.view.bounds), _trustAlertView.frame.size.width, _trustAlertView.frame.size.height)];
            [self.view removeFromSuperview];
        }];
    }else if ([_rootAlertView superview]){
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [_rootAlertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:456] repeatCount:1] forKey:@"moveY"];
        } completionHandler:^{
            [_rootAlertView.layer removeAnimationForKey:@"moveY"];
            [_rootAlertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - _rootAlertView.frame.size.width) / 2), NSMaxY(self.view.bounds), _rootAlertView.frame.size.width, _rootAlertView.frame.size.height)];
            [self.view removeFromSuperview];
        }];
        
    }else if ([_openMTPAlertView superview]){
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [_openMTPAlertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:456] repeatCount:1] forKey:@"moveY"];
        } completionHandler:^{
            [_openMTPAlertView.layer removeAnimationForKey:@"moveY"];
            [_openMTPAlertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - _openMTPAlertView.frame.size.width) / 2), NSMaxY(self.view.bounds), _openMTPAlertView.frame.size.width, _openMTPAlertView.frame.size.height)];
            [self.view removeFromSuperview];
            
        }];
        
    }
}

#pragma mark - noDataAlertView
- (void)showNoDataAlertViewWithSuperView:(NSView *)superView {
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setWantsLayer:YES];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_noDataAlertView];
    [_noDataAlertView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _noDataAlertView.frame.size.width) / 2), superView.frame.size.height, _noDataAlertView.frame.size.width, _noDataAlertView.frame.size.height)];
    [self.view setWantsLayer:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(bView.frame.origin.x + floor((bView.frame.size.width - _noDataAlertView.frame.size.width) / 2), bView.frame.size.height - _noDataAlertView.frame.size.height + 8, _noDataAlertView.frame.size.width, _noDataAlertView.frame.size.height);
        [context setDuration:0.3];
        [[_noDataAlertView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
    }];
    
    [_noDataAlertView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_noDataAlertTitle setStringValue:CustomLocalizedString(@"MoveToIOSNoData_Title", nil)];
    [_promptStr1 setStringValue:CustomLocalizedString(@"MoveToIOSNoData_Title_1", nil)];
    [_promptStr2 setStringValue:CustomLocalizedString(@"MoveToIOSNoData_Title_2", nil)];
    [_number1 setStringValue:@"1."];
    [_number2 setStringValue:@"2."];
    [_promptImageView1 setImage:[StringHelper imageNamed:@"nodata_step1"]];
    [_promptImageView2 setImage:[StringHelper imageNamed:@"nodata_step2"]];
    
    [_noDataClickText setDelegate:self];
    [_noDataClickText setSelectable:YES];
    NSString *promptStr = CustomLocalizedString(@"MoveToIOSNoData_OpenAppLinkTips", nil);
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_noDataClickText setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:promptStr];
    [promptAs addAttribute:NSLinkAttributeName value:promptStr range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14.0] range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_noDataClickText textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    
    [_number1 setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_number2 setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_promptStr1 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_promptStr2 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_noDataAlertTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    //配置按钮
    NSString *okBtnStr = CustomLocalizedString(@"TrustView_id_2", nil);
    [_noDataOkBtn reSetInit:okBtnStr WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okBtnStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_noDataOkBtn setAttributedTitle:attributedTitles];
    [_noDataOkBtn setTarget:self];
    [_noDataOkBtn setAction:@selector(closeNoDataAlertViewOperation:)];
    
}

#pragma mark - 关闭 noDataAlertView
- (void)closeNoDataAlertViewOperation:(id)sender{
    if ([_noDataAlertView superview]) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [_noDataAlertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:456] repeatCount:1] forKey:@"moveY"];
        } completionHandler:^{
            [_noDataAlertView.layer removeAnimationForKey:@"moveY"];
            [_noDataAlertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - _noDataAlertView.frame.size.width) / 2), NSMaxY(self.view.bounds), _noDataAlertView.frame.size.width, _noDataAlertView.frame.size.height)];
            [self.view removeFromSuperview];
        }];
    }
}


#pragma mark - 传输失败的详情-弹框
- (void)showATtransferFailAlertViewWithSuperView:(NSView *)superView WithFailReasonArray:(NSMutableArray *)reasonArray {
    if (_reasonArray != nil) {
        [_reasonArray release];
        _reasonArray = nil;
    }
    _reasonArray = [[NSMutableArray alloc] initWithArray:reasonArray];
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setWantsLayer:YES];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_transferFailAlertView];
    [_transferFailAlertView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _transferFailAlertView.frame.size.width) / 2), superView.frame.size.height, _transferFailAlertView.frame.size.width, _transferFailAlertView.frame.size.height)];
    [self.view setWantsLayer:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(bView.frame.origin.x + floor((bView.frame.size.width - _transferFailAlertView.frame.size.width) / 2), bView.frame.size.height - _transferFailAlertView.frame.size.height + 8, _transferFailAlertView.frame.size.width, _transferFailAlertView.frame.size.height);
        [context setDuration:0.3];
        [[_transferFailAlertView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
    }];
    [_transferFailAlertDetailView setBackgroundColor:[NSColor clearColor]];
    [_transferFailAlertDetailView setFocusRingType:NSFocusRingTypeNone];
    [_transferFailAlertDetailView reloadData];

    [_backgroundBorderView setHasTopBorder:YES];
    [_backgroundBorderView setHasLeftBorder:YES];
    [_backgroundBorderView setHasBottomBorder:YES];
    [_backgroundBorderView setHasRightBorder:YES];
    [_backgroundBorderView setTopBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_backgroundBorderView setLeftBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_backgroundBorderView setBottomBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_backgroundBorderView setRightBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    [_transferFailAlertView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_transferFailAlertTitle setStringValue:CustomLocalizedString(@"ResultWindow_Title", nil)];
    [_transferFailAlertTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
   
    //配置按钮
    NSString *str1 = CustomLocalizedString(@"DeviceDetailed_id_2", nil);
    NSString *str2 = CustomLocalizedString(@"tip_id_2", nil);
    NSRect strRect1 = [StringHelper calcuTextBounds:str1 fontSize:12];
    NSRect strRect2 = [StringHelper calcuTextBounds:str2 fontSize:12];
    [_transferFailAlertBtn1 setFrame:NSMakeRect((_transferFailAlertView.frame.size.width)/2.0 - 5 - strRect1.size.width - 22, _transferFailAlertBtn1.frame.origin.y, strRect1.size.width + 22, _transferFailAlertBtn1.frame.size.height)];
    [_transferFailAlertBtn2 setFrame:NSMakeRect(_transferFailAlertBtn1.frame.origin.x + _transferFailAlertBtn1.frame.size.width + 10, _transferFailAlertBtn1.frame.origin.y, strRect2.size.width + 22, _transferFailAlertBtn2.frame.size.height)];
    [_transferFailAlertBtn1 setFontSize:12.0];
    [_transferFailAlertBtn2 setFontSize:12.0];
    
    [_transferFailAlertBtn1 reSetInit:str1 WithPrefixImageName:@"cancal"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:str1]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, str1.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:NSMakeRange(0, str1.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, str1.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_transferFailAlertBtn1 setIsReslutVeiw:YES];
    [_transferFailAlertBtn1 setAttributedTitle:attributedTitles];
    [_transferFailAlertBtn1 setTarget:self];
    [_transferFailAlertBtn1 setAction:@selector(clickTransferFailAlertBtn1)];
    
    
    [_transferFailAlertBtn2 reSetInit:str2 WithPrefixImageName:@"cancal"];
    NSMutableAttributedString *attributedTitles2 = [[[NSMutableAttributedString alloc]initWithString:str2]autorelease];
    [attributedTitles2 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, str2.length)];
    [attributedTitles2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:NSMakeRange(0, str2.length)];
    [attributedTitles2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, str2.length)];
    [attributedTitles2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles2.length)];
    [_transferFailAlertBtn2 setIsReslutVeiw:YES];
    [_transferFailAlertBtn2 setAttributedTitle:attributedTitles2];
    [_transferFailAlertBtn2 setTarget:self];
    [_transferFailAlertBtn2 setAction:@selector(closeTransferFailAlertViewOperation:)];
}

#pragma mark - 关闭 TransferFailAlertView
- (void)closeTransferFailAlertViewOperation:(id)sender{
    if ([_transferFailAlertView superview]) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [_transferFailAlertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:414] repeatCount:1] forKey:@"moveY"];
        } completionHandler:^{
            [_transferFailAlertView.layer removeAnimationForKey:@"moveY"];
            [_transferFailAlertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - _transferFailAlertView.frame.size.width) / 2), NSMaxY(self.view.bounds), _transferFailAlertView.frame.size.width, _transferFailAlertView.frame.size.height)];
            [self.view removeFromSuperview];
        }];
    }
}

#pragma mark - 点击在TextEdit上查看失败详情
- (void)clickTransferFailAlertBtn1 {
    
    NSString *result = [self stringFromTransactions];
    NSString *expath = [NSHomeDirectory() stringByAppendingString:@"/Document"];;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:expath]) {
        [fm createDirectoryAtPath:expath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path = [expath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",CustomLocalizedString(@"transfer_Fail_Reason", nil)]];
    if ([fm fileExistsAtPath:path]) {
        path = [TempHelper getFilePathAlias:path];
    }
    [result writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if ([fm fileExistsAtPath:path]) {
        NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
        [workSpace openFile:path withApplication:@"TextEdit"];
    }
    
}

#pragma mark - 配置TextEdit显示内容
- (NSString *)stringFromTransactions {
    
    NSMutableString *result = [NSMutableString string];
    for (IMBError *entity in _reasonArray) {
        [result appendString:[NSString stringWithFormat:@"%@ %@\n%@: %@\n\n",CustomLocalizedString(@"iCloud_greateFile_FileName", nil),entity.name,CustomLocalizedString(@"List_Header_id_Reason", nil),entity.reson]];
    }
    
    return result;
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_reasonArray.count > 0) {
        return _reasonArray.count;
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
        IMBError *errorEntity = [_reasonArray objectAtIndex:row];
        if ([tableColumn.identifier isEqualToString:@"Name"]) {
            return errorEntity.name;
        }else if ([tableColumn.identifier isEqualToString:@"Reason"]){
            return errorEntity.reson;
        }
        return @"";
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
        if ([[tableColumn identifier] isEqualToString:@"Name"]) {
            IMBCenterTextFieldCell *boxCell = (IMBCenterTextFieldCell *)cell;
            IMBError *errorEntity = [_reasonArray objectAtIndex:row];
            boxCell.entity = errorEntity;
        }
    
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 38;
}

- (void)dealloc {
    if (_reasonArray != nil) {
        [_reasonArray release];
        _reasonArray = nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:Andriod_Device_Disconnect object:nil];
    [super dealloc];
}

@end

