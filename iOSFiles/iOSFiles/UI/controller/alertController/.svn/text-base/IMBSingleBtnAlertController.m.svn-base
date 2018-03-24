//
//  IMBSingleBtnAlertController.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBSingleBtnAlertController.h"

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
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
#pragma mark - action

- (IBAction)singleBtnViewOKClicked:(id)sender {
    if (self.singleBtnOKClicked) {
        self.singleBtnOKClicked();
    }
}

@end
