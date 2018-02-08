//
//  IMBToMacViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-8-16.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseTransfer.h"
#import "IMBBackgroundBorderView.h"
#import "IMBAlertViewController.h"
#import "ToMacAnimationView.h"
#import "IMBAnimateProgressBar.h"
#import "IMBMonitorBtn.h"
#import "IMBCustomShapeView.h"
#import "HoverButton.h"
#import "IMBBaseViewController.h"
@class IMBiCloudManager;
@interface IMBToMacViewController : IMBBaseViewController<TransferDelegate,NSTextViewDelegate>
{
    IBOutlet NSTextField *_navigationField;
    IBOutlet NSView *_nextbackBgView;
    IBOutlet IMBBackgroundBorderView *_titleView;
    IBOutlet NSBox *_contentBox;
    IBOutlet NSCollectionView *_connectionView;
    IBOutlet IMBBackgroundBorderView *_connectionBgView;
    IBOutlet NSView *_categorySelectView;
    IBOutlet NSTextField *_categorySelectsubTitleField;
    IBOutlet NSTextField *_categorySelectTitleField;
    IBOutlet IMBMonitorBtn *_selectPathButton;
    IBOutlet NSTextField *_pathTextField;
    IBOutlet IMBCustomShapeView *_cusShapeView;
    IBOutlet NSTextField *_exportLabel;
    NSMutableArray *_bindcategoryArray;
    /**传输页面*/
    IBOutlet NSView *_transferView;
    IBOutlet NSTextField *_transferTitleField;
    IBOutlet NSTextField *_fileNameField;
    IBOutlet IMBAnimateProgressBar *_progressviewBar;
    IBOutlet NSTextField *_warningTipField;
    IBOutlet ToMacAnimationView *_toMacAnimationView;
    IBOutlet NSTextField *_transferPromptLabel;
    IBOutlet NSImageView *_noteImageView;
    /**结果页面*/
    IBOutlet NSView *_completeView;
    IBOutlet NSTextField *_completetitleField;
    IBOutlet NSTextView *_completeSubTitleField;
    IBOutlet NSTextView *_textView;
    IBOutlet NSImageView *_completeImageView;
    IBOutlet NSImageView *_completeBGImageView;
    IBOutlet NSView *_pathBGView;
    IBOutlet NSImageView *_roseProgressBgImageView;
    IBOutlet NSImageView *_bellImgView;
    int _successCount;
    int _totalCount;
    
    //icloud传输完成界面(活动)- 英语版
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
    
    //除英语外的icloud 完成界面
    IBOutlet IMBWhiteView *_muicloudCompleteView;
    IBOutlet NSTextView *_muicloudCompleteMainTitle;
    IBOutlet NSTextField *_muicloudCompleteSubTitle;
    
    IBOutlet IMBTextBoxView *_muicloudCompleteDetailView;
    IBOutlet IMBDrawOneImageBtn *_muicloudCompleteBtnView1;
    IBOutlet NSTextField *_muicloudCompleteLable1;
    IBOutlet IMBDrawOneImageBtn *_muicloudCompleteBtnView2;
    IBOutlet NSTextField *_muicloudCompleteLable2;
    IBOutlet IMBDrawOneImageBtn *_muicloudCompleteBtnView3;
    IBOutlet NSTextField *_muicloudCompleteLable3;
    IBOutlet IMBDrawOneImageBtn *_muicloudCompleteBtnView4;
    IBOutlet NSTextField *_muicloudCompleteLable4;
    IBOutlet IMBDrawOneImageBtn *_muicloudCompleteBtnView5;
    IBOutlet NSTextField *_muicloudCompleteLable5;
    
    IBOutlet NSTextField *_muicloudCompleteMiddleTitle;
    IBOutlet IMBGridientButton *_muicloudCompleteButton;
    
    
    IMBBaseTransfer *_baseTransfer;
    NSString *_exportFolder;
    NSArray *_exportArray;
    BOOL _isToMac;  //_isToMac为YES表示为传输到mac 为NO表示传输到itunes
    
    HoverButton *_closebutton;
    BOOL _isTransferComplete;
    IMBiCloudManager *_icloudManager;
    BOOL _isNextBtnDown;
}
@property (nonatomic,assign)IMBiCloudManager *icloudManager;
@property (nonatomic,retain)NSMutableArray *bindcategoryArray;
- (id)initWithiPod:(IMBiPod *)iPod  CategoryInfoModelArrary:(NSMutableArray *)categoryArray isToMac:(BOOL)isToMac WithIsiCoudView:(BOOL)isiCloudView;
- (IBAction)selectFolder:(id)sender;
- (IBAction)clickCheckBox:(id)sender;

@end
