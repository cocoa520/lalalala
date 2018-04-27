//
//  IMBMainBigIcloudView.h
//  iOSFiles
//
//  Created by iMobie on 2018/3/20.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBGridientButton.h"
@class IMBMyDrawCommonly,IMBDrawTextFiledView,customTextFiled,IMBSecireTextField;

@interface IMBMainBigIcloudView : NSView
{
    @private
    
    IBOutlet NSTextField *_titleLabel;
    IBOutlet NSTextField *_messageLabel;
    IBOutlet NSTextField *_rememberMeLabel;
    IBOutlet IMBGridientButton *_loginBtn;
    IBOutlet IMBDrawTextFiledView *_icloudUserView;
    IBOutlet customTextFiled *_icloudUserTF;
    IBOutlet IMBDrawTextFiledView *_icloudLoginPwdView;
    IBOutlet customTextFiled *_icloudLoginPwdTF;
    IBOutlet IMBSecireTextField *_icloudSecireTF;
}
@end
