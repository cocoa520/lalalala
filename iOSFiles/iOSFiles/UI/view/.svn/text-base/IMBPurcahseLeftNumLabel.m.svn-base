//
//  IMBPurcahseLeftNumLabel.m
//  AllFiles
//
//  Created by iMobie on 2018/4/24.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBPurcahseLeftNumLabel.h"
#import "IMBCommonDefine.h"


@implementation IMBPurcahseLeftNumLabel

@synthesize leftNum = _leftNum;
@synthesize leftStirngEnum = _leftStirngEnum;

#pragma mark - setup view
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    
}
- (void)setupView {
    //设置文字居中
//    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
//    ps.alignment = NSCenterTextAlignment;
    
    NSDictionary *textAttrDic = @{NSForegroundColorAttributeName : COLOR_PURCHASE_TEXT,NSFontNameAttribute : [NSFont fontWithName:IMBCommonFont size:12.f]};
    NSMutableAttributedString *labelAttrString = nil;
    switch (_leftStirngEnum) {
        case IMBPurcahseLeftNumLabelLeftStringToMac:
        {
            labelAttrString = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"Purchase_left_toMac_num", nil) attributes:textAttrDic];
        }
            break;
        case IMBPurcahseLeftNumLabelLeftStringToDevice:
        {
            labelAttrString = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"Purchase_left_toDevice_num", nil) attributes:textAttrDic];
        }
            break;
        case IMBPurcahseLeftNumLabelLeftStringToCloud:
        {
            labelAttrString = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"Purchase_left_toCloud_num", nil) attributes:textAttrDic];
        }
            break;
            
        default:
            break;
    }
    
    NSDictionary *leftAttrDic = @{NSForegroundColorAttributeName : [self getTextColorWithLeftNum:_leftNum],NSFontAttributeName : [NSFont fontWithName:IMBCommonFont size:18.f]};
    [labelAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",_leftNum] attributes:leftAttrDic]];
    [labelAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:CustomLocalizedString(@"Purchase_left_num", nil) attributes:textAttrDic]];
    [self setAttributedStringValue:labelAttrString];
}

- (NSColor *)getTextColorWithLeftNum:(NSInteger)leftNum {
    if (leftNum == 0) {
        return COLOR_PURCHASE_LEFTNUM_RED;
    }else if (leftNum > 0 && leftNum <= 50) {
        return COLOR_PURCHASE_LEFTNUM_ORANGE;
    }else {
        return COLOR_PURCHASE_LEFTNUM_GREEN;
    }
}

- (void)setLeftNum:(NSUInteger)leftNum {
    _leftNum = leftNum;
    
    [self setupView];
}
@end
