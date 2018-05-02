//
//  IMBRegisterResultView.m
//  AllFiles
//
//  Created by iMobie on 2018/4/28.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBRegisterResultView.h"


@implementation IMBRegisterResultView
#pragma mark - synthesize
@synthesize iconImageView = _iconImageView;
@synthesize msgTextfield = _msgTextfield;

@synthesize restToMacNum = _restToMacNum;
@synthesize restToDeviceNum = _restToDeviceNum;
@synthesize restToCloudNum = _restToCloudNum;


#pragma mark - set up view
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    _iconImageView = [[NSImageView alloc] init];
    _iconImageView.imb_width = 20.f;
    _iconImageView.imb_height = 20.f;
    _iconImageView.imb_center = NSMakePoint(10.f, self.imb_height/2.f);
    [self addSubview:_iconImageView];
    
    _msgTextfield = [[NSTextField alloc] init];
    _msgTextfield.imb_width = self.imb_width - 5.f - NSMaxX(_iconImageView.frame);
    _msgTextfield.imb_height = 16.f;
    _msgTextfield.imb_x = 5.f + NSMaxX(_iconImageView.frame);
    _msgTextfield.imb_centerY = self.imb_height/2.f + 3.f;
    _msgTextfield.bordered = NO;
    [self addSubview:_msgTextfield];
    
    _msgTextfield.font = [NSFont fontWithName:IMBCommonFont size:12.f];
}

- (void)dealloc {
    [super dealloc];
    
    [_iconImageView release];
    _iconImageView = nil;
    
    [_msgTextfield release];
    _msgTextfield = nil;
}
@end
