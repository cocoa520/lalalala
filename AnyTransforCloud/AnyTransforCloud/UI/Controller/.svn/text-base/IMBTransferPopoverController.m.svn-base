//
//  IMBTransferPopoverController.m
//  AnyTransforCloud
//
//  Created by hym on 09/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBTransferPopoverController.h"
#import "IMBSelectedButton.h"
#import "StringHelper.h"
#import "IMBTransferViewController.h"
@implementation IMBTransferPopoverController
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    [_mainTitle setStringValue:CustomLocalizedString(@"TransferControl_Transfer7", nil)];
    [_mainTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:12];
    [_okBtn setEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] downColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] ExitColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] SelectColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] titleFont:font buttonTitle:CustomLocalizedString(@"Button_Yes", nil)];
    [_okBtn setTarget:self];
    [_okBtn setAction:@selector(okButtonClick:)];
    
    [_cancelBtn setEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] downColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] ExitColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] SelectColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] titleFont:font buttonTitle:CustomLocalizedString(@"Button_No", nil)];
    [_cancelBtn setTarget:self];
    [_cancelBtn setAction:@selector(cancelButtonClick:)];
}

- (void)okButtonClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(sureToDeleteAllTask:)]) {
        [_delegate sureToDeleteAllTask:sender];
    }
}

- (void)cancelButtonClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(cancelToDeleteAllTask:)]) {
        [_delegate cancelToDeleteAllTask:sender];
    }
}


@end
