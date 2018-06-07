//
//  IMBMainWindowLoginSuccessView.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/20.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBMainWindowLoginSuccessView.h"
#import "IMBCommonDefine.h"
#import "IMBViewAnimation.h"


@implementation IMBMainWindowLoginSuccessView

#pragma mark - @synthesize

@synthesize imageView = _imageView;
@synthesize nameLabel = _nameLabel;
@synthesize sizeLabel = _sizeLabel;
@synthesize logoutBtn = _logoutBtn;

#pragma mark - initialize


- (void)awakeFromNib {
    [super awakeFromNib];
    [_sizeLabel setTextColor:COLOR_TEXT_EXPLAIN];
    [_sizeLabel setFont:[NSFont fontWithName:IMBCommonFont size:12.f]];
    
    [_nameLabel setTextColor:COLOR_TEXT_ORDINARY];
    [_nameLabel setFont:[NSFont fontWithName:IMBCommonFont size:18.f]];
    
    [_logoutBtn setHoverImage:@"mod_icon_signout_hover" withSelfImage:[NSImage imageNamed:@"mod_icon_signout"]];
    _logoutBtn.alphaValue = 0;
}

#pragma mark - action 

- (IBAction)quitClicked:(id)sender {
    if (self.quitBtnClicked) {
        self.quitBtnClicked();
    }
}


@end