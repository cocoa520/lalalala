//
//  IMBPurchaseLeftNumController.m
//  AllFiles
//
//  Created by iMobie on 2018/4/19.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBPurchaseLeftNumController.h"
#import "IMBCommonDefine.h"
#import "IMBPurcahseLeftNumLabel.h"



@interface IMBPurchaseLeftNumController ()

@end

@implementation IMBPurchaseLeftNumController

#pragma mark - synthesize
@synthesize titleLabel = _titleLabel;
@synthesize leftNums = _leftNums;


#pragma mark - setup view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
//    [self setupView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setupView {
    
    _titleLabel.textColor = COLOR_PURCHASE_TITLE_TEXT;
    _titleLabel.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    
    _titleLabel.stringValue = CustomLocalizedString(@"Purchase_left_num_tips", nil);

    
    _firstLabel.leftStirngEnum = IMBPurcahseLeftNumLabelLeftStringToMac;
    _firstLabel.leftNum = [_leftNums[0] integerValue];
    
    _secondLabel.leftStirngEnum = IMBPurcahseLeftNumLabelLeftStringToDevice;
    _secondLabel.leftNum = [_leftNums[1] integerValue];
    
    _thirdLabel.leftStirngEnum = IMBPurcahseLeftNumLabelLeftStringToCloud;
    _thirdLabel.leftNum = [_leftNums[2] integerValue];
}



- (void)setLeftNums:(NSArray *)leftNums {
    _leftNums = leftNums;
    
    [self setupView];
}

@end
