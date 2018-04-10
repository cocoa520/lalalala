//
//  IMBDoubleVerificationViewController.m
//  AllFiles
//
//  Created by iMobie on 2018/4/2.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBDoubleVerificationViewController.h"
#import "IMBMyDrawCommonly.h"
#import "IMBCommonDefine.h"
#import "StringHelper.h"
#import "IMBCodeTextField.h"
#import "IMBWhiteView.h"


@interface IMBDoubleVerificationViewController ()

@end

@implementation IMBDoubleVerificationViewController

- (void)dealloc {
    
    [self removeNotis];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)awakeFromNib {
    [self setupView];
    [self addNotis];
}

- (void)setupView {
    
    _doubleVerificaTitle.stringValue = CustomLocalizedString(@"iCloudLogin_SecurityView_codeTips", nil);
    _cancelbtn.title = CustomLocalizedString(@"Button_Cancel", nil);
    _okBtn.title = CustomLocalizedString(@"Button_Ok", nil);
    
    [_cancelbtn WithMouseExitedtextColor:COLOR_ALERT_BUTTON_UNSELECTED_TEXT WithMouseUptextColor:COLOR_ALERT_BUTTON_UNSELECTED_TEXT WithMouseDowntextColor:COLOR_ALERT_BUTTON_UNSELECTED_TEXT withMouseEnteredtextColor:COLOR_ALERT_BUTTON_UNSELECTED_TEXT];
    [_cancelbtn WithMouseExitedfillColor:COLOR_View_NORMAL WithMouseUpfillColor:COLOR_CANCELBTN_ENTER WithMouseDownfillColor:COLOR_CANCELBTN_ENTER withMouseEnteredfillColor:COLOR_CANCELBTN_ENTER];
    [_cancelbtn WithMouseExitedLineColor:COLOR_BTNBORDER_NORMAL WithMouseUpLineColor:COLOR_BTNBORDER_NORMAL WithMouseDownLineColor:COLOR_BTNBORDER_NORMAL withMouseEnteredLineColor:COLOR_BTNBORDER_NORMAL];
    [_cancelbtn setTitleName:_cancelbtn.title WithDarwRoundRect:4.f WithLineWidth:1.f withFont:[NSFont fontWithName:IMBCommonFont size:14.f]];
    
    
    [_okBtn WithMouseExitedtextColor:COLOR_View_NORMAL WithMouseUptextColor:COLOR_View_NORMAL WithMouseDowntextColor:COLOR_View_NORMAL withMouseEnteredtextColor:COLOR_View_NORMAL];
    [_okBtn WithMouseExitedfillColor:COLOR_OKBTN_NORMAL WithMouseUpfillColor:COLOR_OKBTN_ENTER WithMouseDownfillColor:COLOR_OKBTN_ENTER withMouseEnteredfillColor:COLOR_OKBTN_ENTER];
    [_okBtn WithMouseExitedLineColor:COLOR_View_NORMAL WithMouseUpLineColor:COLOR_OKBTN_ENTER WithMouseDownLineColor:COLOR_OKBTN_ENTER withMouseEnteredLineColor:COLOR_OKBTN_ENTER];
    [_okBtn setTitleName:_okBtn.title WithDarwRoundRect:4.f WithLineWidth:1.f withFont:[NSFont fontWithName:IMBCommonFont size:14.f]];
    
    [_doubleVerificaFirstNum setCodeTag:1];
    [_doubleVerificaSecondNum setCodeTag:2];
    [_doubleVerificaThirdNum setCodeTag:3];
    [_doubleVerificaFourthNum setCodeTag:4];
    [_doubleVerificaFifthNum setCodeTag:5];
    [_doubleVerificaSixthNum setCodeTag:6];
    [_doubleVerificaFirstNum becomeFirstResponder];
    
    [_numBox1 setBackgroundColor:COLOR_DEVICE_Popover_Btn_Bg_COLOR];
    [_numBox1 setBorderColor:COLOR_BTN_BORDER];
    [_numBox1 setHasCorner:YES];
    
    [_numBox2 setBackgroundColor:COLOR_DEVICE_Popover_Btn_Bg_COLOR];
    [_numBox2 setBorderColor:COLOR_BTN_BORDER];
    [_numBox2 setHasCorner:YES];
    
    [_numBox3 setBackgroundColor:COLOR_DEVICE_Popover_Btn_Bg_COLOR];
    [_numBox3 setBorderColor:COLOR_BTN_BORDER];
    [_numBox3 setHasCorner:YES];
    
    [_numBox4 setBackgroundColor:COLOR_DEVICE_Popover_Btn_Bg_COLOR];
    [_numBox4 setBorderColor:COLOR_BTN_BORDER];
    [_numBox4 setHasCorner:YES];
    
    [_numBox5 setBackgroundColor:COLOR_DEVICE_Popover_Btn_Bg_COLOR];
    [_numBox5 setBorderColor:COLOR_BTN_BORDER];
    [_numBox5 setHasCorner:YES];
    
    [_numBox6 setBackgroundColor:COLOR_DEVICE_Popover_Btn_Bg_COLOR];
    [_numBox6 setBorderColor:COLOR_BTN_BORDER];
    [_numBox6 setHasCorner:YES];
    
}

#pragma mark - 添加删除通知
- (void)addNotis {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editDoubleVerificationCode:) name:IMBCodeTextFieldCodeEditCodeNotifation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDoubleVerificationCode:) name:IMBCodeTextFieldDeleteCodeNotification object:nil];
}

- (void)removeNotis {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBCodeTextFieldDeleteCodeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBCodeTextFieldCodeEditCodeNotifation object:nil];
}



#pragma mark -
//显示sendCode、Text Me、Help的View
- (void)showSendCodeMessageHelpView {
    [_doubleVerificaTextView setHidden:YES];
    [_doubleVerificaSendCodeScrollView setHidden:NO];
    [_doubleVerificaSendmsgScrollView setHidden:NO];
    [_doubleVerificaHelpScrollView setHidden:NO];
    
}

- (void)editDoubleVerificationCode:(NSNotification *)notification {
    if (![StringHelper stringIsNilOrEmpty:_doubleVerificaFirstNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaSecondNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaThirdNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaFourthNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaFifthNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaSixthNum.stringValue]) {
        [_okBtn setEnabled:YES];
    }else {
        [_okBtn setEnabled:NO];
    }
    
    NSDictionary *dic = notification.object;
    int codeTag = [[dic objectForKey:IMBCodeTextFieldCodeTagKey] intValue];
    switch (codeTag) {
        case 1:
        {
            [_doubleVerificaSecondNum becomeFirstResponder];
        }
            break;
        case 2:
        {
            [_doubleVerificaThirdNum becomeFirstResponder];
        }
            break;
        case 3:
        {
            [_doubleVerificaFourthNum becomeFirstResponder];
        }
            break;
        case 4:
        {
            [_doubleVerificaFifthNum becomeFirstResponder];
        }
            break;
        case 5:
        {
            [_doubleVerificaSixthNum becomeFirstResponder];
        }
            break;
            
        default:
            break;
    }
}

- (void)deleteDoubleVerificationCode:(NSNotification *)notification {
    if (![StringHelper stringIsNilOrEmpty:_doubleVerificaFirstNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaSecondNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaThirdNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaFourthNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaFifthNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaSixthNum.stringValue]) {
        [_okBtn setEnabled:YES];
    }else {
        [_okBtn setEnabled:NO];
    }
    
    NSDictionary *dic = notification.object;
    int codeTag = [[dic objectForKey:IMBCodeTextFieldCodeTagKey] intValue];
    switch (codeTag) {
        case 2:
        {
            [_doubleVerificaFirstNum becomeFirstResponder];
        }
            break;
        case 3:
        {
            [_doubleVerificaSecondNum becomeFirstResponder];
        }
            break;
        case 4:
        {
            [_doubleVerificaThirdNum becomeFirstResponder];
        }
            break;
        case 5:
        {
            [_doubleVerificaFourthNum becomeFirstResponder];
        }
            break;
        case 6:
        {
            [_doubleVerificaFifthNum becomeFirstResponder];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 按钮点击


- (IBAction)okClicked:(id)sender {
    NSString *codeId = [NSString stringWithFormat:@"%@%@%@%@%@%@",_doubleVerificaFirstNum.stringValue,_doubleVerificaSecondNum.stringValue,_doubleVerificaThirdNum.stringValue,_doubleVerificaFourthNum.stringValue,_doubleVerificaFifthNum.stringValue,_doubleVerificaSixthNum.stringValue];
    if (self.okClicked) {
        self.okClicked(codeId);
    }
    
}

- (IBAction)cancelClicked:(id)sender {
    
    if (self.cancelClicked) {
        self.cancelClicked();
    }
}

@end
