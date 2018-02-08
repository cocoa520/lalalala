//
//  IMBShoppingCarViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import <WebKit/WebKit.h>
#import "ShopLineView.h"
@class IMBGeneralButton;
@class IMBMonitorBtn;
@interface IMBShoppingCarViewController : IMBBaseViewController<NSTextViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    IBOutlet NSImageView *_shlogoImageView;
    IBOutlet NSImageView *_imageView;
    IBOutlet NSTextField *_mainTitle;
    IBOutlet NSTextField *_subTitle;
    IBOutlet IMBGeneralButton *_buyBtn;
    IBOutlet IMBWhiteView *_activeBgView;
    IBOutlet IMBWhiteView *_inputTextFiledBgView;
    IBOutlet customTextFiled *_inputTextFiled;
    IBOutlet NSTextField *_enterLicenseTitle;
    IBOutlet IMBGeneralButton *_activeBtn;
    IBOutlet ShopLineView *_lineView;
    IBOutlet NSTextView *_registerLabel;
    IBOutlet NSView *_reslutView;
    IBOutlet NSImageView *_relustImageView;
    NSNotificationCenter *_nc;
    IBOutlet NSScrollView *_textScroview;
    BOOL _isSucess;
    IBOutlet WebView *_likeWebView;
    NSURL *_url;
    CALayer *_loadingLayer;
}
- (void)closeWindow:(id)sender;


@end
