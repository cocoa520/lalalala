//
//  IMBAndroidDisconnectViewController.h
//  AnyTrans
//
//  Created by iMobie on 7/10/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"

@interface IMBAndroidDisconnectViewController : IMBBaseViewController
{
    
    IBOutlet NSTextField *_titleTextField;
    IBOutlet NSTextField *_promptTextField;
    IBOutlet NSView *_noconnectView;
    IBOutlet NSImageView *_nonectimageView1;
    NSTimer *_timer;
    int count;
}

- (void)addTimer;
- (void)killTimer;
- (void)setTimerNil;
//配置连接流程文字（一般）
- (void)setPromptTextString:(NSString *)textStr;
//正在连接和链接完成的文字
- (void)loadingConnectingAndConnectedCompeleteLaguages:(NSString *)deviceName;

@end
