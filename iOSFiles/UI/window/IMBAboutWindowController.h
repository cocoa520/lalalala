//
//  IMBAboutWindowController.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-31.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBLinkButton.h"
#import "IMBWhiteView.h"
@interface IMBAboutWindowController : NSWindowController
{
    IBOutlet NSTextField *_titleStr;
    IBOutlet NSTextField *_subTitleVersion;
    IBOutlet NSTextField *_supportStr;
    IBOutlet NSTextField *_honePageStr;
    IBOutlet NSTextField *_bottomLable;
    IBOutlet IMBLinkButton *_suportUrlBtn;
    IBOutlet IMBLinkButton *_homePageUrlBtn;
    IBOutlet IMBWhiteView *_lineView;
    IBOutlet NSImageView *_titleCustomView;
}
@end
