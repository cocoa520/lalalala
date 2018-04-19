
//
//  IMBPurchaseBottomButtonController.m
//  AllFiles
//
//  Created by iMobie on 2018/4/19.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBPurchaseBottomButtonController.h"
#import "IMBGridientButton.h"
#import "IMBCommonDefine.h"


@interface IMBPurchaseBottomButtonController ()

@end

@implementation IMBPurchaseBottomButtonController
#pragma mark - synthesize
@synthesize topView = _topView;
@synthesize purchaseButton = _purchaseButton;
@synthesize msgLabel = _msgLabel;
@synthesize titleLabel = _titleLabel;

#pragma mark - setup view

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView {
    [_purchaseButton setIsLeftRightGridient:YES withLeftNormalBgColor:COLOR_PURCHASE_LEFT_FORBIDDENCOLOR withRightNormalBgColor:COLOR_PURCHASE_RIGHT_FORBIDDENCOLOR withLeftEnterBgColor:COLOR_PURCHASE_LEFT_FORBIDDENCOLOR withRightEnterBgColor:COLOR_PURCHASE_RIGHT_FORBIDDENCOLOR withLeftDownBgColor:COLOR_PURCHASE_LEFT_FORBIDDENCOLOR withRightDownBgColor:COLOR_PURCHASE_RIGHT_FORBIDDENCOLOR withLeftForbiddenBgColor:COLOR_LOGIN_LEFT_FORBIDDENCOLOR withRightForbiddenBgColor:COLOR_LOGIN_RIGHT_FORBIDDENCOLOR];
    
    [_purchaseButton setBordered:NO];
    
    [_purchaseButton setButtonTitle:CustomLocalizedString(@"Purchase_Button_text" , nil) withNormalTitleColor:COLOR_View_NORMAL withEnterTitleColor:COLOR_View_NORMAL withDownTitleColor:COLOR_View_NORMAL withForbiddenTitleColor:COLOR_View_NORMAL withTitleSize:14 WithLightAnimation:NO];
}
@end
