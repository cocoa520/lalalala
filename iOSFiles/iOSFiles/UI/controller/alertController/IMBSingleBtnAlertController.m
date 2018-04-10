//
//  IMBSingleBtnAlertController.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBSingleBtnAlertController.h"
#import "IMBCommonDefine.h"
#import "StringHelper.h"

@interface IMBSingleBtnAlertController ()

@end

@implementation IMBSingleBtnAlertController
#pragma mark - synthesize

@synthesize singleBtnView = _singleBtnView;
@synthesize singleBtnViewMsgLabel = _singleBtnViewMsgLabel;
@synthesize singleBtnViewOKBtn = _singleBtnViewOKBtn;

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView {
    [_singleBtnViewOKBtn WithMouseExitedtextColor:COLOR_View_NORMAL WithMouseUptextColor:COLOR_View_NORMAL WithMouseDowntextColor:COLOR_View_NORMAL withMouseEnteredtextColor:COLOR_View_NORMAL];
    [_singleBtnViewOKBtn WithMouseExitedfillColor:COLOR_OKBTN_NORMAL WithMouseUpfillColor:COLOR_OKBTN_ENTER WithMouseDownfillColor:COLOR_OKBTN_ENTER withMouseEnteredfillColor:COLOR_OKBTN_ENTER];
    [_singleBtnViewOKBtn WithMouseExitedLineColor:COLOR_View_NORMAL WithMouseUpLineColor:COLOR_OKBTN_ENTER WithMouseDownLineColor:COLOR_OKBTN_ENTER withMouseEnteredLineColor:COLOR_OKBTN_ENTER];
    [_singleBtnViewOKBtn setTitleName:CustomLocalizedString(@"Button_Ok", nil) WithDarwRoundRect:4.f WithLineWidth:1.f withFont:[NSFont fontWithName:IMBCommonFont size:14.f]];
}


//根据title的长度，计算位置
- (void)resetMsgPostion {
    if (![StringHelper stringIsNilOrEmpty:_singleBtnViewMsgLabel.stringValue]) {
        NSRect rect = [StringHelper calcuTextBounds:_singleBtnViewMsgLabel.stringValue fontSize:14];
        int lineCount = (int)(rect.size.width / _singleBtnViewMsgLabel.frame.size.width) + 1;
        if (lineCount == 1) {
            [_singleBtnViewMsgLabel setFrameOrigin:NSMakePoint(83, 32)];
        }else if (lineCount == 2) {
            [_singleBtnViewMsgLabel setFrameOrigin:NSMakePoint(83, 40)];
        }else {
            [_singleBtnViewMsgLabel setFrameOrigin:NSMakePoint(83, 48)];
        }
    }
}
#pragma mark - action

- (IBAction)singleBtnViewOKClicked:(id)sender {
    if (self.singleBtnOKClicked) {
        self.singleBtnOKClicked();
    }
}

@end
