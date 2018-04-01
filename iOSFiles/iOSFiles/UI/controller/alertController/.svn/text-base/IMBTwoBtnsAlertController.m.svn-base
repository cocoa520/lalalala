//
//  IMBTwoBtnsAlertController.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBTwoBtnsAlertController.h"
#import "IMBCommonDefine.h"


@interface IMBTwoBtnsAlertController ()

@end

@implementation IMBTwoBtnsAlertController
#pragma mark - @synthesize
@synthesize twoBtnsView = _twoBtnsView;
@synthesize twoBtnsViewMsgView = _twoBtnsViewMsgView;
@synthesize twoBtnsViewCancelBtn = _twoBtnsViewCancelBtn;
@synthesize twoBtnsViewOKBtn = _twoBtnsViewOKBtn;

#pragma mark - 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupView];
}

- (void)awakeFromNib {
    [self setupView];
}

- (void)setupView {
    [_twoBtnsViewCancelBtn WithMouseExitedtextColor:COLOR_ALERT_BUTTON_UNSELECTED_TEXT WithMouseUptextColor:COLOR_ALERT_BUTTON_UNSELECTED_TEXT WithMouseDowntextColor:COLOR_ALERT_BUTTON_UNSELECTED_TEXT withMouseEnteredtextColor:COLOR_ALERT_BUTTON_UNSELECTED_TEXT];
    [_twoBtnsViewCancelBtn WithMouseExitedfillColor:COLOR_View_NORMAL WithMouseUpfillColor:COLOR_CANCELBTN_ENTER WithMouseDownfillColor:COLOR_CANCELBTN_ENTER withMouseEnteredfillColor:COLOR_CANCELBTN_ENTER];
    [_twoBtnsViewCancelBtn WithMouseExitedLineColor:COLOR_BTNBORDER_NORMAL WithMouseUpLineColor:COLOR_BTNBORDER_NORMAL WithMouseDownLineColor:COLOR_BTNBORDER_NORMAL withMouseEnteredLineColor:COLOR_BTNBORDER_NORMAL];
    [_twoBtnsViewCancelBtn setTitleName:CustomLocalizedString(@"Button_Cancel", nil) WithDarwRoundRect:2.f WithLineWidth:1.f withFont:[NSFont fontWithName:IMBCommonFont size:14.f]];
    
    [_twoBtnsViewOKBtn WithMouseExitedtextColor:COLOR_View_NORMAL WithMouseUptextColor:COLOR_View_NORMAL WithMouseDowntextColor:COLOR_View_NORMAL withMouseEnteredtextColor:COLOR_View_NORMAL];
    [_twoBtnsViewOKBtn WithMouseExitedfillColor:COLOR_OKBTN_NORMAL WithMouseUpfillColor:COLOR_OKBTN_ENTER WithMouseDownfillColor:COLOR_OKBTN_ENTER withMouseEnteredfillColor:COLOR_OKBTN_ENTER];
    [_twoBtnsViewOKBtn WithMouseExitedLineColor:COLOR_View_NORMAL WithMouseUpLineColor:COLOR_OKBTN_ENTER WithMouseDownLineColor:COLOR_OKBTN_ENTER withMouseEnteredLineColor:COLOR_OKBTN_ENTER];
    [_twoBtnsViewOKBtn setTitleName:CustomLocalizedString(@"Button_Ok", nil) WithDarwRoundRect:2.f WithLineWidth:1.f withFont:[NSFont fontWithName:IMBCommonFont size:14.f]];
}
#pragma mark - action

- (IBAction)twoBtnsViewCancelClicked:(id)sender {
    if (self.twoBtnsViewCancelClicked) {
        self.twoBtnsViewCancelClicked();
    }
}
- (IBAction)rwoBtnsViewOKClicked:(id)sender {
    if (self.twoBtnsViewOKClicked) {
        self.twoBtnsViewOKClicked();
    }
}
@end
