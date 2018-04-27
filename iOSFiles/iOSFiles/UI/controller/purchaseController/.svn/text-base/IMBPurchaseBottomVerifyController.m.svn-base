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


@interface IMBPurchaseBottomVerifyController ()
{
    BOOL _isBackspaseDown;
}
@end

@implementation IMBPurchaseBottomVerifyController
- (void)dealloc {
    [super dealloc];
    
    [IMBNotiCenter removeObserver:self name:NOTIFY_REGISTER_TEXTFILED_INPUT_CHANGE object:nil];
    [IMBNotiCenter removeObserver:self name:INSERT_BACKSPASE object:nil];
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
    [IMBNotiCenter addObserver:self selector:@selector(inputTFDidChanges:) name:NOTIFY_REGISTER_TEXTFILED_INPUT_CHANGE object:nil];
    [IMBNotiCenter addObserver:self selector:@selector(backspaseDown) name:INSERT_BACKSPASE object:nil];
}


- (void)inputTFDidChanges:(NSNotification *)tf {
    NSTextField *dic = tf.object;
    NSString *str = dic.stringValue;
    [self addLineInKey:str];
    NSLog(@"%@",dic);
}

- (void)addLineInKey:(NSString *)string {
    if (!_isBackspaseDown) {
        if (string.length == 4 || string.length == 9 || string.length == 14 || string.length == 19) {
            _secondViewInputTextFiled.stringValue = [string stringByAppendingString:@"-"];
        }
        if (_secondViewInputTextFiled.stringValue.length == 24) {
            _secondViewActiveBtn.enabled = YES;
        }else if (_secondViewInputTextFiled.stringValue.length > 24){
            _secondViewInputTextFiled.stringValue = [_secondViewInputTextFiled.stringValue substringWithRange:NSMakeRange(0, 24)];
        }
    }
    if (_secondViewInputTextFiled.stringValue.length != 24) {
        _secondViewActiveBtn.enabled = NO;
    }
    _isBackspaseDown = NO;
    
}

- (void)backspaseDown {
    _isBackspaseDown = YES;
    NSInteger len = _secondViewInputTextFiled.stringValue.length;
    if (len == 6 || len == 11 || len == 16 || len == 21) {
        _secondViewInputTextFiled.stringValue = [_secondViewInputTextFiled.stringValue substringWithRange:NSMakeRange(0, len -1)];
    }
}
- (void)startActive {
    
}

@end
