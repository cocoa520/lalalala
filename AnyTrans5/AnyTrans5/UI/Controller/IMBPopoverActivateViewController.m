//
//  IMBPopoverActivateViewController.m
//  AnyTrans
//
//  Created by iMobie on 3/27/18.
//  Copyright (c) 2018 imobie. All rights reserved.
//

#import "IMBPopoverActivateViewController.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "IMBSoftWareInfo.h"
#import "ATTracker.h"
#import "IMBAnimation.h"
#import "NSString+Category.h"
#import "IMBNotificationDefine.h"
#import "OperationLImitation.h"

@interface IMBPopoverActivateViewController ()

@end

@implementation IMBPopoverActivateViewController

- (id)initWithDelegate:(id)delegate {
    self = [super initWithNibName:@"IMBPopoverActivateViewController" bundle:nil];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)awakeFromNib {
    [_activateReslutView setHidden:YES];
    [_registerLabel setDelegate:self];
    _loadingLayer = [[CALayer alloc] init];
    
    [_inputTextFiledBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_inputTextFiledBgView setHasCorner:YES];
    NSMutableAttributedString *as = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"xxxx-xxxx-xxxx-xxxx-xxxx", nil)] autorelease];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.string.length)];
    [as setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as.string.length)];
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, as.string.length)];
    [((customTextFieldCell *)_inputTextFiled.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_inputTextFiled.cell setPlaceholderAttributedString:as];
    NSString *OkText = CustomLocalizedString(@"register_window_activateBtn", nil);
    [_activeBtn reSetInit:OkText WithPrefixImageName:@"select_path"];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:OkText]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_activeBtn setAttributedTitle:attributedTitles1];
    
    [_activeBtn setTarget:self];
    [_activeBtn setAction:@selector(startActive)];
    [_activeBtn setNeedsDisplay:YES];
    
    [_inputTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSMutableAttributedString *as3 = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"xxxx-xxxx-xxxx-xxxx-xxxx", nil)] autorelease];
    [as3 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as3.string.length)];
    [as3 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as3.string.length)];
    [as3 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, as3.string.length)];
    [_inputTextFiled.cell setPlaceholderAttributedString:as3];
}

- (void)startActive {
     if ([_inputTextFiled.stringValue isEqualToString:@""] || _inputTextFiled.stringValue.length == 0) {
         NSDictionary *dimensionDict = nil;
         @autoreleasepool {
             NSMutableDictionary *dimensionMutDict = [[[NSMutableDictionary alloc] init] autorelease];
             OperationLImitation *limit = [OperationLImitation singleton];
             if (limit.remainderCount <= 0) {
                 [limit setLimitStatus:@"noquote"];
             }else {
                 [limit setLimitStatus:@"completed"];
             }
             dimensionMutDict = [TempHelper customDimension];
             [dimensionMutDict setObject:[IMBSoftWareInfo singleton].selectModular forKey:@"cd7"];
             dimensionDict = [dimensionMutDict copy];
         }
         [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:@"Registration code is empty" label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
         if (dimensionDict) {
             [dimensionDict release];
             dimensionDict = nil;
        }
         return;
     }
     _loadingLayer.contents = [NSImage imageNamed:@"registedLoading"];
     
     [_inputTextFiled setWantsLayer:YES];
     [_loadingLayer setFrame:CGRectMake(_inputTextFiled.frame.size.width  -10 -8  , (_inputTextFiled.frame.size.height - 14)/2 +2 , 14,14)];
     [_inputTextFiled.layer addSublayer:_loadingLayer];
     [_loadingLayer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
     
     //JXCV-JJKS-SEXE-EIEA-KDIT
     if (![_inputTextFiled.stringValue contains:@"-"] || _inputTextFiled.stringValue.length < 18) {
         [_inputTextFiledBgView setHidden:YES];
         [_activateReslutView setHidden:NO];
         [_activateRelustImageView setImage:[StringHelper imageNamed:@"registFailure"]];
         [self showReslutView:CustomLocalizedString(@"activate_error_discorrect", nil)];
         NSDictionary *dimensionDict = nil;
         @autoreleasepool {
             NSMutableDictionary *dimensionMutDict = [[[NSMutableDictionary alloc] init] autorelease];
             OperationLImitation *limit = [OperationLImitation singleton];
             if (limit.remainderCount <= 0) {
                 [limit setLimitStatus:@"noquote"];
             }else {
                 [limit setLimitStatus:@"completed"];
             }
             dimensionMutDict = [TempHelper customDimension];
             [dimensionMutDict setObject:[IMBSoftWareInfo singleton].selectModular forKey:@"cd7"];
             dimensionDict = [dimensionMutDict copy];
         }
         [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:False",_inputTextFiled.stringValue] label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
         if (dimensionDict) {
             [dimensionDict release];
             dimensionDict = nil;
         }
         return;
     }
    
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
         if (![TempHelper isInternetAvail]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_inputTextFiledBgView setHidden:YES];
                [_activateReslutView setHidden:NO];
                [_activateRelustImageView setImage:[StringHelper imageNamed:@"registFailure"]];
                [self showReslutView:CustomLocalizedString(@"activate_error_disinternet", nil)];
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    NSMutableDictionary *dimensionMutDict = [[[NSMutableDictionary alloc] init] autorelease];
                    OperationLImitation *limit = [OperationLImitation singleton];
                    if (limit.remainderCount <= 0) {
                        [limit setLimitStatus:@"noquote"];
                    }else {
                        [limit setLimitStatus:@"completed"];
                    }
                    dimensionMutDict = [TempHelper customDimension];
                    [dimensionMutDict setObject:[IMBSoftWareInfo singleton].selectModular forKey:@"cd7"];
                    dimensionDict = [dimensionMutDict copy];
                }
                [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:False",CustomLocalizedString(@"activate_error_disinternet", nil)] label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                return;
            });
         }
         IMBSoftWareInfo *software = [IMBSoftWareInfo singleton];
         [software setIsIllegal:NO];
         _isSucess = [software registerSoftware:_inputTextFiled.stringValue];
         dispatch_sync(dispatch_get_main_queue(), ^{
             [_loadingLayer removeFromSuperlayer];
             [_inputTextFiledBgView setHidden:YES];
             [_activateReslutView setHidden:NO];
             if (_isSucess) {
                 NSDictionary *dimensionDict = nil;
                 @autoreleasepool {
                     NSMutableDictionary *dimensionMutDict = [[[NSMutableDictionary alloc] init] autorelease];
                     OperationLImitation *limit = [OperationLImitation singleton];
                     if (limit.remainderCount <= 0) {
                         [limit setLimitStatus:@"noquote"];
                     }else {
                         [limit setLimitStatus:@"completed"];
                     }
                     dimensionMutDict = [TempHelper customDimension];
                     [dimensionMutDict setObject:software.selectModular forKey:@"cd7"];
                     dimensionDict = [dimensionMutDict copy];
                 }
                 [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:True",_inputTextFiled.stringValue] label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                 if (dimensionDict) {
                     [dimensionDict release];
                     dimensionDict = nil;
                 }
                 [_activateRelustImageView setImage:[StringHelper imageNamed:@"registSuccess"]];
                 [self showReslutView:CustomLocalizedString(@"activate_success", nil)];
     
                 double delayInSeconds = 0.5;
                 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                     //跳转到设备连接页面
                     [self performSelector:@selector(toRegistSuccess) withObject:self afterDelay:0.2];
                 });
             }else{
                 if (software.isIllegal) {
                     NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"https://www.imobie.com/landing/anytrans-official-xmas-offer.htm?%@", nil),[_inputTextFiled.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""]];
                     NSURL *url = [NSURL URLWithString:str];
     
                     NSWorkspace *ws = [NSWorkspace sharedWorkspace];
                     [ws openURL:url];
                 }
     
                 NSString *errorStr = @"";
                 if (![TempHelper stringIsNilOrEmpty:software.rigisterErrorCode]) {
                     if ([software.rigisterErrorCode isEqualToString:@"002"]) {
                         errorStr = CustomLocalizedString(@"activate_error_expired", nil);
                     }else if ([software.rigisterErrorCode isEqualToString:@"003"]) {
                         errorStr = CustomLocalizedString(@"activate_error_overPC", nil);
                     }else if ([software.rigisterErrorCode isEqualToString:@"012"]) {
                         errorStr = CustomLocalizedString(@"activate_error_timeOutofPeriod", nil);
                     }else {
                         errorStr = [NSString stringWithFormat:CustomLocalizedString(@"activate_error_registerFailed", nil),[software.rigisterErrorCode intValue]];
                     }
                 }else {
                     errorStr = [NSString stringWithFormat:CustomLocalizedString(@"activate_error_registerFailed", nil),-1];
                 }
                 NSDictionary *dimensionDict = nil;
                 @autoreleasepool {
                     NSMutableDictionary *dimensionMutDict = [[[NSMutableDictionary alloc] init] autorelease];
                     OperationLImitation *limit = [OperationLImitation singleton];
                     if (limit.remainderCount <= 0) {
                         [limit setLimitStatus:@"noquote"];
                     }else {
                         [limit setLimitStatus:@"completed"];
                     }
                     dimensionMutDict = [TempHelper customDimension];
                     [dimensionMutDict setObject:software.selectModular forKey:@"cd7"];
                     dimensionDict = [dimensionMutDict copy];
                 }
                 [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:False",_inputTextFiled.stringValue] label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                 if (dimensionDict) {
                     [dimensionDict release];
                     dimensionDict = nil;
                 }
                 [_activateRelustImageView setImage:[StringHelper imageNamed:@"registFailure"]];
                 [self showReslutView:errorStr];
             }
         });
     });
}

- (void)showReslutView:(NSString *)errorStr {
     [_registerLabel setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"", nil)]];
     NSString *overStr = CustomLocalizedString(@"register_window_tryagainBtn", nil);
     NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_registerLabel setLinkTextAttributes:linkAttributes];
    NSString *str = nil;
    if (_isSucess) {
        str = [errorStr retain];
    }else {
        str = [[[errorStr stringByAppendingString:@"    "]stringByAppendingString:overStr] retain];;
    }
    
     NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:str withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
     [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
     NSRange infoRange = [str rangeOfString:overStr];
     [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
     [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
     [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14.0] range:infoRange];
     [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
     
     NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
     [mutParaStyle setAlignment:NSLeftTextAlignment];
    [mutParaStyle setLineSpacing:2.0];
     [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
     [[_registerLabel textStorage] setAttributedString:promptAs];
     [mutParaStyle release];
     mutParaStyle = nil;
     
//     NSRect LableRect = [TempHelper calcuTextBounds:errorStr fontSize:14];
//     
//     [_activateRelustScrollview setFrameSize:NSMakeSize(LableRect.size.width + 150, _activateRelustScrollview.frame.size.height)];
//     
//     float ox = (_reslutView.frame.size.width - _relustImageView.frame.size.width - _textScroview.frame.size.width )/2;
//     
//     if (_isSucess) {
//         [_relustImageView setFrameOrigin:NSMakePoint(ox + 40, _relustImageView.frame.origin.y)];
//         [_textScroview setFrameOrigin:NSMakePoint(ox+ 70, -6)];
//     }else {
//         [_relustImageView setFrameOrigin:NSMakePoint(ox+40, _relustImageView.frame.origin.y)];
//         [_textScroview setFrameOrigin:NSMakePoint(ox+ 70, -6)];
//     }xxxx-xxxx-xxxx-xxxx-xxxx
    
     [str autorelease];
}

- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex{
    NSString *overStr = CustomLocalizedString(@"register_window_tryagainBtn", nil);
    
    if ([link isEqualToString:overStr]) {
        [_activateReslutView setHidden:YES];
        [_inputTextFiledBgView setHidden:NO];
        [_inputTextFiled setStringValue:@""];
        [_loadingLayer removeAllAnimations];
        [_loadingLayer removeFromSuperlayer];
    }
    return YES;
}

- (void)toRegistSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:ANNOY_REGIST_SUCCESS object:nil];
    if ([_delegate respondsToSelector:@selector(activateSuccess)]) {
        [_delegate activateSuccess];
    }
}

- (void)dealloc {
    if (_loadingLayer != nil) {
        [_loadingLayer release];
        _loadingLayer = nil;
    }
    [super dealloc];
}

@end
