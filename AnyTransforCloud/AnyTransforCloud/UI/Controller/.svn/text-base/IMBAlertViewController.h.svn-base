//
//  IMBAlertViewController.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/5/6.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBorderRectAndColorView.h"
#import "IMBGridientButton.h"

@interface IMBAlertViewController : NSViewController {
    
    //单个按钮的下拉窗
    IBOutlet IMBBorderRectAndColorView *_promptAlertView;
    IBOutlet NSImageView *_promptAlertImage;
    IBOutlet NSTextField *_promptAlertTitle;
    IBOutlet IMBGridientButton *_promptAlertButton;
    
    //两个按钮的下拉窗
    IBOutlet IMBBorderRectAndColorView *_promptAlertView2;
    IBOutlet NSImageView *_promptAlertImage2;
    IBOutlet NSTextField *_promptAlertTitle2;
    IBOutlet IMBGridientButton *_promptAlertCancelBtn;
    IBOutlet IMBGridientButton *_promptAlertOKBtn;
    
    NSView *_mainView;
    BOOL _endRunloop;
    int _result;
}
@property (nonatomic, assign) id delegate;

/**
 *  单个按钮的警告框
 *
 *  @param alertText      下拉框标题
 *  @param alertButtonStr 按钮文字
 *  @param superView      当前视图
 */
- (void)showAlertText:(NSString *)alertText withAlertButton:(NSString *)alertButtonStr withSuperView:(NSView *)superView;
/**
 *  两个按钮的下拉窗
 *
 *  @param alertText       下拉框标题
 *  @param cancelButtonStr 取消按钮文字
 *  @param okButtonStr     确定按钮文字
 *  @param superView       当前视图
 *
 *  @return 返回值为0 则取消；为1 则确定
 */
- (int)showAlertText:(NSString *)alertText withCancelButton:(NSString *)cancelButtonStr withOKButton:(NSString *)okButtonStr withSuperView:(NSView *)superView;

@end
