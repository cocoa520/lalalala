//
//  IMBPurchaseTopVerifyController.m
//  AllFiles
//
//  Created by iMobie on 2018/4/19.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBPurchaseTopVerifyController.h"
#import "IMBGridientButton.h"
#import "customTextFiled.h"
#import "IMBWhiteView.h"
#import "IMBCommonDefine.h"


@interface IMBPurchaseTopVerifyController ()

@end

@implementation IMBPurchaseTopVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView {
    [_secondViewInputTextFiledBgView setBackgroundColor:COLOR_DEVICE_Popover_Btn_Bg_COLOR];
    [_secondViewInputTextFiledBgView setHasCorner:YES];
    NSMutableAttributedString *as5 = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"xxxx-xxxx-xxxx-xxxx-xxxx", nil)] autorelease];
    [as5 addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_EXPLAIN range:NSMakeRange(0, as5.string.length)];
    [as5 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as5.string.length)];
    [as5 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as5.string.length)];
    [((customTextFieldCell *)_secondViewInputTextFiled.cell) setCursorColor:COLOR_ALERT_BUTTON_UNSELECTED_TEXT];
    [_secondViewInputTextFiled.cell setPlaceholderAttributedString:as5];
    
//    NSString *OkText = CustomLocalizedString(@"register_window_activateBtn", nil);
//    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:OkText]autorelease];
//    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, OkText.length)];
//    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, OkText.length)];
//    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, OkText.length)];
//    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
//    [_secondViewActiveBtn setAttributedTitle:attributedTitles1];
    
    [_secondViewActiveBtn setTarget:self];
    [_secondViewActiveBtn setAction:@selector(startActive)];
    [_secondViewActiveBtn setNeedsDisplay:YES];
    
    [_secondViewInputTextFiled setTextColor:COLOR_ALERT_BUTTON_UNSELECTED_TEXT];
    NSMutableAttributedString *as3 = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"xxxx-xxxx-xxxx-xxxx-xxxx", nil)] autorelease];
    [as3 addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_EXPLAIN range:NSMakeRange(0, as3.string.length)];
    [as3 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as3.string.length)];
    [as3 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, as3.string.length)];
    [_secondViewInputTextFiled.cell setPlaceholderAttributedString:as3];
    
    [_secondViewActiveBtn setIsLeftRightGridient:YES withLeftNormalBgColor:COLOR_PURCHASE_LEFT_FORBIDDENCOLOR withRightNormalBgColor:COLOR_PURCHASE_RIGHT_FORBIDDENCOLOR withLeftEnterBgColor:COLOR_PURCHASE_LEFT_FORBIDDENCOLOR withRightEnterBgColor:COLOR_PURCHASE_RIGHT_FORBIDDENCOLOR withLeftDownBgColor:COLOR_PURCHASE_LEFT_FORBIDDENCOLOR withRightDownBgColor:COLOR_PURCHASE_RIGHT_FORBIDDENCOLOR withLeftForbiddenBgColor:COLOR_LOGIN_LEFT_FORBIDDENCOLOR withRightForbiddenBgColor:COLOR_LOGIN_RIGHT_FORBIDDENCOLOR];
    
    [_secondViewActiveBtn setBordered:NO];
    
    [_secondViewActiveBtn setButtonTitle:CustomLocalizedString(@"register_window_title" , nil) withNormalTitleColor:COLOR_View_NORMAL withEnterTitleColor:COLOR_View_NORMAL withDownTitleColor:COLOR_View_NORMAL withForbiddenTitleColor:COLOR_View_NORMAL withTitleSize:14 WithLightAnimation:NO];
    [_secondViewActiveBtn setEnabled:NO];
}

- (void)startActive {
    
}
@end
