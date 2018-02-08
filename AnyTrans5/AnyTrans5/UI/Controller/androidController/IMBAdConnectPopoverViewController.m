//
//  IMBAdConnectPopoverViewController.m
//  AnyTrans
//
//  Created by smz on 17/8/22.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBAdConnectPopoverViewController.h"
#import "StringHelper.h"

@interface IMBAdConnectPopoverViewController ()

@end

@implementation IMBAdConnectPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"IMBAdConnectPopoverViewController" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    NSString *promptStr = CustomLocalizedString(@"NavButton_MoveToiOS_Tips", nil);
    NSRect strRect = [StringHelper calcuTextBounds:promptStr fontSize:12.0];
    if (strRect.size.width >= 327) {
        self.view.frame = NSMakeRect(0, 0, self.view.frame.size.width, self.view.frame.size.height + 10);
    }
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [_adDeviceConnectStr setSelectable:NO];
    [[_adDeviceConnectStr textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
}

@end
