//
//  IMBVideoDownloadViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-12-19.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBCustomPopupButton.h"
#import "IMBBackgroundBorderView.h"
#import "IMBDownloadButton.h"
#import "IMBBasedViewTableView.h"
#import "DownLoadView.h"
@class IMBDownloadListViewController;
#import "VDLManager.h"
#import "IMBTextButtonView.h"
@interface IMBVideoDownloadViewController : IMBBaseViewController<NSTextFieldDelegate>
{
    IBOutlet IMBBasedViewTableView *preViewTableView;
    IBOutlet IMBCustomPopupButton *_popUpButton;
    IBOutlet NSImageView *_bgImageView;
    IBOutlet NSView *_urlView;
    IBOutlet NSBox *_contentBox;
    IBOutlet IMBBackgroundBorderView *_urlBorderView;
    IBOutlet IMBDownloadButton *_downloadButton;
    IBOutlet NSTextField *_downloadTitle;
    IBOutlet NSTextField *_downloadsubTitle;
    IBOutlet NSTextField *_wheretosaveText;
    IBOutlet customTextFiled *_urlTextField;
    IMBDownloadListViewController *_downloadlist;
    IBOutlet IMBBackgroundBorderView *preView;
    NSMutableArray *_preViewDataSource;
    VDLManager *_vdlManager;
    IBOutlet IMBTextButtonView *_cancelButton;

    IBOutlet NSView *_contentView;
    IBOutlet NSView *_mainView;
    int _downloadSuccessCount;
@public
    DownLoadView *_rightUpDownbgView;
}
- (IBAction)clickPopupButton:(id)sender;
- (IBAction)clickUrl:(id)sender;
- (IBAction)downLoad:(id)sender;
- (void)showReslutView;
@end
