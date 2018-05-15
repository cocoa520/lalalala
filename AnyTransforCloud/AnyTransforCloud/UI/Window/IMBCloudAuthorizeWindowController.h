//
//  IMBCloudAuthorizeWindowController.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/5/6.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBGridientButton.h"
#import "IMBNoTitleBarContentView.h"
#import "IMBCloudEntity.h"

@interface IMBCloudAuthorizeWindowController : NSWindowController {
    
    IMBCloudEntity *_cloudEntity;
    id _delegate;
    IBOutlet NSImageView *_bgImageView;
    IBOutlet NSImageView *_cloudImageView;
    IBOutlet NSImageView *_failedImageView;
    IBOutlet NSTextField *_titleLabel;
    IBOutlet NSTextField *_promptLabel;
    IBOutlet IMBGridientButton *_reauthorizeBtn;
    IBOutlet IMBGridientButton *_authorizedBtn;
    IBOutlet IMBNoTitleBarContentView *_contentView;
}
- (id)initWithCloudEntity:(IMBCloudEntity *)cloudEntity withDelegate:(id)delegate;

- (void)onlyCloseWindow:(id)sender;

//授权失败 视图配置
- (void)configAuthorizedFailedView;

@end
