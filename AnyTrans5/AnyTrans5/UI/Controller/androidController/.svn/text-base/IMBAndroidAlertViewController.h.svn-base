//
//  IMBAndroidAlertViewController.h
//  AnyTrans
//
//  Created by smz on 17/8/16.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBorderRectAndColorView.h"
#import "IMBWhiteView.h"
//#import <IMBAndroidDevice/IMBAndroidDevice.h>
#import "IMBAndroidDevice.h"
#import "IMBAndroid.h"
#import "IMBCustomHeaderTableView.h"
#import "IMBScrollView.h"
#import "IMBBackgroundBorderView.h"

@class IMBLackCornerView;
@class IMBGeneralButton;
@interface IMBAndroidAlertViewController : NSViewController<NSTextViewDelegate,NSTableViewDataSource,NSTabViewDelegate>
{
    BOOL _endRunloop;
    id _delegate;
    //信任窗口
    IBOutlet IMBBorderRectAndColorView *_trustAlertView;
    IBOutlet NSTextField *_trustAlertMainTitle;
    IBOutlet NSTextField *_trustAlertSubTitle;
    IBOutlet NSImageView *_trustAlertImgView;
    IBOutlet IMBGeneralButton *_trustAlertOkBtn;
    
    //提权窗口
    IBOutlet IMBBorderRectAndColorView *_rootAlertView;
    IBOutlet NSTextField *_rootAlertMainTitle;
    IBOutlet IMBGeneralButton *_rootAlertCalcelBtn;
    IBOutlet IMBGeneralButton *_rootAlertOkBtn;
    int _rootChooseResult;
    NSInteger _waitTime;
    IBOutlet NSTextField *_rootAlertSubTitle;
    IBOutlet NSImageView *_rootAlertImageView;
    IBOutlet NSTextView *_rootWarningTextView;
    NSTimer *_rootAlertTimer;
    
    //MTP提示框
    IBOutlet IMBBorderRectAndColorView *_openMTPAlertView;
    IBOutlet NSTextField *_openMTPAlertMainTitle;
    IBOutlet IMBWhiteView *_openMTPInnerView;
    IBOutlet NSImageView *_openMTPFirstImgView;
    IBOutlet NSTextField *_openMTPFirstLabel;
    IBOutlet NSImageView *_openMTPSecondImgView;
    IBOutlet NSTextField *_openMTPSecondLabel;
    IBOutlet NSImageView *_openMTPThirdImgView;
    IBOutlet NSTextField *_openMTPThirdLabel;
    IBOutlet IMBGeneralButton *_openMTPAlertOkBtn;
    
    //单按钮警告框
    NSView *_mainView;
    IBOutlet IMBBorderRectAndColorView *_warningAlertView;
    IBOutlet NSImageView *_warnAlertImage;
    IBOutlet NSTextField *_warningTextField;
    IBOutlet IMBGeneralButton *_okBtn;
    NSPoint _warningTextFieldInitPoint;
    
    //两个按钮的弹窗
    IBOutlet IMBBorderRectAndColorView *_confirmAlertView;
    IBOutlet NSImageView *_confirmAlertImage;
    IBOutlet IMBGeneralButton *_cancelBtn;
    IBOutlet IMBGeneralButton *_removeBtn;
    IBOutlet NSTextField *_confirmTextField;
    
    //noData界面的点击文字弹框
    IBOutlet IMBBorderRectAndColorView *_noDataAlertView;
    IBOutlet NSTextField *_noDataAlertTitle;
    IBOutlet NSTextField *_number1;
    IBOutlet NSTextField *_number2;
    IBOutlet NSTextField *_promptStr1;
    IBOutlet NSTextField *_promptStr2;
    IBOutlet NSTextView *_noDataClickText;
    IBOutlet NSImageView *_promptImageView1;
    IBOutlet NSImageView *_promptImageView2;
    IBOutlet IMBGeneralButton *_noDataOkBtn;
    
    //传输失败弹框
    IBOutlet IMBBorderRectAndColorView *_transferFailAlertView;
    IBOutlet NSTextField *_transferFailAlertTitle;
    IBOutlet IMBScrollView *_scrollView;
    IBOutlet IMBCustomHeaderTableView *_transferFailAlertDetailView;
    IBOutlet IMBGeneralButton *_transferFailAlertBtn1;
    IBOutlet IMBGeneralButton *_transferFailAlertBtn2;
    IBOutlet IMBBackgroundBorderView *_backgroundBorderView;
    NSMutableArray *_reasonArray;
    
    int _result;
    IMBAndroid *_android;
}
@property (nonatomic, assign)id delegate;
@property (nonatomic, retain) IMBAndroid *android;
//一个按钮的下拉窗口
- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)okButtonString SuperView:(NSView *)superView;
//两个按钮
- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText CancelButton:(NSString *)cancelText SuperView:(NSView *)superView;
//显示信任窗口
- (int)showAlertTrustView:(NSView *)superView withDic:(NSDictionary *)dic withEnum:(int)enumCount;
//点击信任OK按钮
- (void)trustOperation:(id )sender;
//提示设备提权窗口
- (int)showImproveAuthorityAlertView:(NSView *)superView isVersionHighThan6:(BOOL)higher;
//显示媒体设备MTP模式窗口
- (int)showMediaDeviceMTPAlertView:(NSView *)superView withDic:(NSDictionary *)dic;
- (void)mediaDeviceMTPOkOperation:(id)sender;
- (void)cancelBtnOperation:(id)sender;
////noData界面的点击文字弹框
- (void)showNoDataAlertViewWithSuperView:(NSView *)superView;

//活动界面传输失败的详情-弹框
- (void)showATtransferFailAlertViewWithSuperView:(NSView *)superView WithFailReasonArray:(NSMutableArray *)reasonArray;

@end
