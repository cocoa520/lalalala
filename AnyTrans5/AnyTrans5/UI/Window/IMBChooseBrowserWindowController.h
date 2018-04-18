//
//  IMBChooseLanguagesWindowController.h
//  PhoneClean
//
//  Created by iMobie023 on 15-7-24.
//  Copyright (c) 2015年 imobie.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBGridientButton.h"
#import "IMBWhiteView.h"
#import "IMBChooseBrowserView.h"
@interface IMBChooseBrowserWindowController : NSWindowController
{
    IBOutlet IMBWhiteView *conView;
    IBOutlet IMBChooseBrowserView *_googleView;
    IBOutlet IMBChooseBrowserView *_safariView;
    IBOutlet IMBChooseBrowserView *_firfoxView;
    IBOutlet IMBChooseBrowserView *_operaView;
    
    IBOutlet NSTextField *optTextField;
    NSMutableArray *_installBrowsers;
    
    BOOL _isDisCountBuy;//是否为折扣购买链接
    BOOL _isActive;//是通过Active过来的链接
    BOOL _isNeedAnalytics;//是否需要添加跟踪
}

@property (nonatomic, assign) BOOL isDisCountBuy;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isNeedAnalytics;
@property (nonatomic, retain) NSMutableArray *installBrowsers;

- (id)initWithWindowNibName:(NSString *)windowNibName withIsNeedAnalytics:(BOOL)isNeed;

@end
