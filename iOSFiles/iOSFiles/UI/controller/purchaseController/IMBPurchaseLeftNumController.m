//
//  IMBPurchaseLeftNumController.m
//  AllFiles
//
//  Created by iMobie on 2018/4/19.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBPurchaseLeftNumController.h"
#import "IMBCommonDefine.h"


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
    [self setupView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView {
//    _firstLabel.textColor = COLOR_PURCHASE_TEXT;
//    _firstLabel.font = [NSFont fontWithName:IMBCommonFont size:12.f];
//    
//    _secondLabel.textColor = COLOR_PURCHASE_TEXT;
//    _secondLabel.font = [NSFont fontWithName:IMBCommonFont size:12.f];
//    
//    _thirdLabel.textColor = COLOR_PURCHASE_TEXT;
//    _thirdLabel.font = [NSFont fontWithName:IMBCommonFont size:12.f];
    
    _titleLabel.textColor = COLOR_PURCHASE_TITLE_TEXT;
    _titleLabel.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    
    _titleLabel.stringValue = CustomLocalizedString(@"Purchase_left_num_tips", nil);
    
    NSDictionary *textAttrDic = @{NSForegroundColorAttributeName : COLOR_PURCHASE_TEXT,NSFontNameAttribute : [NSFont fontWithName:IMBCommonFont size:12.f]};
    
    
    NSMutableAttributedString *firstLabelAttrString = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"Purchase_left_toMac_num", nil) attributes:textAttrDic];
    NSDictionary *toMacLeftAttrDic = @{NSForegroundColorAttributeName : [self getTextColorWithLeftNum:[_leftNums[0] integerValue]]};
    [firstLabelAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",[_leftNums[0] integerValue]] attributes:toMacLeftAttrDic]];
    [firstLabelAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:CustomLocalizedString(@"Purchase_left_num", nil) attributes:toMacLeftAttrDic]];
    [_firstLabel setAttributedStringValue:firstLabelAttrString];
    
    
    NSMutableAttributedString *secondLabelAttrString = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"Purchase_left_toDevice_num", nil) attributes:textAttrDic];
    NSDictionary *toDeviceLeftAttrDic = @{NSForegroundColorAttributeName : [self getTextColorWithLeftNum:[_leftNums[1] integerValue]]};
    [secondLabelAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",[_leftNums[1] integerValue]] attributes:toMacLeftAttrDic]];
    [secondLabelAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:CustomLocalizedString(@"Purchase_left_num", nil) attributes:toDeviceLeftAttrDic]];
    [_firstLabel setAttributedStringValue:secondLabelAttrString];
    
    
    NSMutableAttributedString *thirdLabelAttrString = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"Purchase_left_toCloud_num", nil) attributes:textAttrDic];
    NSDictionary *toCloudLeftAttrDic = @{NSForegroundColorAttributeName : [self getTextColorWithLeftNum:[_leftNums[0] integerValue]]};
    [thirdLabelAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",[_leftNums[0] integerValue]] attributes:toMacLeftAttrDic]];
    [thirdLabelAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:CustomLocalizedString(@"Purchase_left_num", nil) attributes:toCloudLeftAttrDic]];
    [_firstLabel setAttributedStringValue:thirdLabelAttrString];
}

- (NSColor *)getTextColorWithLeftNum:(NSInteger)leftNum {
    if (leftNum == 0) {
        return COLOR_PURCHASE_LEFTNUM_RED;
    }else if (leftNum > 0 && leftNum <= 50) {
        return COLOR_PURCHASE_LEFTNUM_GREEN;
    }else {
        return COLOR_PURCHASE_LEFTNUM_ORANGE;
    }
}

@end
