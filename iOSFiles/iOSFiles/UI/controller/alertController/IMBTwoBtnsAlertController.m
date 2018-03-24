//
//  IMBTwoBtnsAlertController.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBTwoBtnsAlertController.h"

@interface IMBTwoBtnsAlertController ()

@end

@implementation IMBTwoBtnsAlertController
#pragma mark - @synthesize
@synthesize twoBtnsView = _twoBtnsView;
@synthesize twoBtnsViewMsgView = _twoBtnsViewMsgView;
@synthesize twoBtnsViewCancelBtn = _twoBtnsViewCancelBtn;
@synthesize twoBtnsViewOKBtn = _twoBtnsViewOKBtn;

#pragma mark - 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

#pragma mark - action

- (IBAction)twoBtnsViewCancelClicked:(id)sender {
    if (self.twoBtnsViewCancelClicked) {
        self.twoBtnsViewCancelClicked();
    }
}
- (IBAction)rwoBtnsViewOKClicked:(id)sender {
    if (self.twoBtnsViewOKClicked) {
        self.twoBtnsViewOKClicked();
    }
}
@end
