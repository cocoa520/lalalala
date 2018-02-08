//
//  IMBDownloadListViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-12-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBackgroundBorderView.h"
#import "IMBBasedViewTableView.h"
#import "DownLoadView.h"
@class IMBCustomPopupButton;
#import "IMBBaseViewController.h"
@class VideoBaseInfoEntity;
@class VDLManager;
#import "IMBTextButtonView.h"
#import "IMBGridientButton.h"

@interface IMBDownloadListViewController : IMBBaseViewController<NSTableViewDataSource,NSTableViewDelegate,NSTextViewDelegate>
{
    
    IBOutlet IMBWhiteView *mainBgView;
    IBOutlet IMBTextButtonView *_cleanList;
    IBOutlet IMBBasedViewTableView *_tableView;
    IBOutlet IMBBackgroundBorderView *_titleView;
    IBOutlet NSTextField *_titleTextField;
    NSMutableArray *_downloadDataSource;
    NSOperationQueue *_operationQueue;
    IBOutlet NSBox *_contentBox;
    IBOutlet NSImageView *_nodataImageView;
    IBOutlet NSTextField *_noTipTextField;
    IBOutlet NSScrollView *_scrollView;
    IBOutlet NSView *_nodataView;
    
    //视频下载完成界面(活动)
    IBOutlet NSTextView *_resultTitle;
    IBOutlet NSTextField *_resultSubTitle;
    IBOutlet IMBWhiteView *_resultView;
    
    IBOutlet IMBWhiteView *_lineViewOne;
    IBOutlet IMBWhiteView *_lineViewTwo;
    IBOutlet IMBWhiteView *_lineViewThree;
    IBOutlet IMBWhiteView *_lineViewFour;
    IBOutlet IMBWhiteView *_lineViewFive;
    
    IBOutlet IMBGridientButton *_buttonOne;
    IBOutlet IMBGridientButton *_buttonTwo;
    IBOutlet IMBGridientButton *_buttonThree;
    IBOutlet IMBGridientButton *_buttonFour;
    
    IBOutlet NSImageView *_imageViewOne;
    IBOutlet NSImageView *_imageViewTwo;
    IBOutlet NSImageView *_imageViewThree;
    IBOutlet NSImageView *_imageViewFour;
    
    IBOutlet NSTextField *_imageTitleOne;
    IBOutlet NSTextField *_imageTitleTwo;
    IBOutlet NSTextField *_imageTitleThree;
    IBOutlet NSTextField *_imageTitleFour;
    
    IBOutlet NSTextView *_imageSubTitleOne;
    IBOutlet NSTextView *_imageSubTitleTwo;
    IBOutlet NSTextView *_imageSubTitleThree;
    IBOutlet NSTextView *_imageSubTitleFour;
    
    IBOutlet NSTextView *_bottomTitle;
    
     //视频下载完成活动界面(除英语外)
    IBOutlet NSTextView *_muresultTitle;
    IBOutlet NSTextField *_muresultSubTitle;
    IBOutlet IMBWhiteView *_muresultView;
    
    IBOutlet IMBWhiteView *_mulineViewOne;
    IBOutlet IMBWhiteView *_mulineViewTwo;
    
    IBOutlet NSImageView *_muimageViewOne;
    IBOutlet NSImageView *_muimageViewTwo;
    IBOutlet NSImageView *_muimageViewThree;
    IBOutlet NSImageView *_muimageViewFour;
    
    IBOutlet NSTextField *_muimageTitleOne;
    IBOutlet NSTextField *_muimageTitleTwo;
    IBOutlet NSTextField *_muimageTitleThree;
    IBOutlet NSTextField *_muimageTitleFour;
    
    IBOutlet NSTextView *_muimageSubTitleOne;
    IBOutlet NSTextView *_muimageSubTitleTwo;
    IBOutlet NSTextView *_muimageSubTitleThree;
    IBOutlet NSTextView *_muimageSubTitleFour;
    IBOutlet IMBGridientButton *_muDownloadBtn;
    IBOutlet NSView *_reslutSuperView;
    
    int successCount;
    int _tempCount;
@public
    DownLoadView *_rightUpDownbgView;
    IMBCustomPopupButton *_popUpButton;
    VDLManager *_vdlManager;

}
@property (nonatomic,retain)NSMutableArray *downloadDataSource;
- (void)addDataSource:(NSMutableArray *)addDataSource;
- (void)reloadData:(BOOL)isAdd;
- (void)transferDownload:(IMBiPod *)iPod Video:(VideoBaseInfoEntity *)video;
- (void)addResultView;//英语版
- (void)addMuResultView;//其它语言版
- (void)adSuccessCount;
- (void)reloadBgview;
@end
