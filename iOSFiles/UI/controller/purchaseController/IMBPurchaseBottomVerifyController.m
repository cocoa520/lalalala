//
//  IMBPurchaseBottomVerifyController.m
//  AllFiles
//
//  Created by iMobie on 2018/4/19.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBPurchaseBottomVerifyController.h"
#import "IMBGridientButton.h"
#import "customTextFiled.h"
#import "IMBWhiteView.h"
#import "IMBCommonDefine.h"


@interface IMBPurchaseBottomVerifyController ()<customTextFiledDelegate>

@end

@implementation IMBPurchaseBottomVerifyController
- (void)dealloc {
    [super dealloc];
    
    [IMBNotiCenter removeObserver:self name:NOTIFY_REGISTER_TEXTFILED_INPUT_CHANGE object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
    [self addNotis];
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
    
    [_secondViewActiveBtn setTarget:self];
    [_secondViewActiveBtn setAction:@selector(startActive)];
    [_secondViewActiveBtn setNeedsDisplay:YES];
    
    _secondViewInputTextFiled.dlg = self;
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
    
    NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"Purchase_to_active", nil) attributes:@{NSForegroundColorAttributeName : COLOR_BTN_BLUE_BG, NSUnderlineStyleAttributeName :@(NSUnderlineStyleSingle)}];
    [_toActiveViewBtn setAttributedTitle:titleAttr];
}

- (void)addNotis {
    [IMBNotiCenter addObserver:self selector:@selector(inputTFDidChange:) name:NOTIFY_REGISTER_TEXTFILED_INPUT_CHANGE object:nil];
}

- (void)startActive {
    
}




- (void)inputTFDidChange:(NSTextField *)tf {
    IMBFLog(@"%@",tf.stringValue);
    if (tf.stringValue.length == 24) {
        [_secondViewActiveBtn setEnabled:YES];
    }else {
        [_secondViewActiveBtn setEnabled:NO];
    }
}


@end