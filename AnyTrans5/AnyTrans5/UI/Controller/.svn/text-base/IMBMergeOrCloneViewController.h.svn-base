//
//  IMBMergeOrCloneViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-8-10.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBackgroundBorderView.h"
#import "IMBMenuPopupButton.h"
#import "IMBiPod.h"
#import "IMBAnimateProgressBar.h"
#import "IMBAlertViewController.h"

#import "IMBMergeCloneAppViewController.h"
#import "HoverButton.h"
#import "IMBBetweenDeviceHandler.h"
#import "IMBBaseViewController.h"
@class IMBBaseTransfer;
@class IMBiCloudManager;
@class IMBiPodMenuItem;
@class CloneAnimationView;
typedef enum Transfer {
    MergeType = 1,
    CloneType = 2,
    ToDeviceType = 3,
    ToiCloudType = 4,
    ToiTunesType = 5,
} TransferType;

@interface IMBMergeOrCloneViewController : IMBBaseViewController<NSTextViewDelegate,TransferDelegate>
{
    IBOutlet NSImageView *_arrowImageVIew;
    IBOutlet NSTextField *_navigationField;
    IBOutlet NSView *_nextbackBgView;
    /**设备选择页面*/
    IBOutlet NSView *_deviceSelectView;
    IBOutlet NSTextField *_deviceSelectTitleField;
    IBOutlet NSTextField *_deviceSelectsubTitleField;
    IBOutlet NSImageView *_sourceDeviceImageView;
    IBOutlet NSImageView *_targetDeviceImageView;
    IBOutlet NSTextField *_sourceDeviceNameField;
    IBOutlet IMBMenuPopupButton *_targetDevicePopButton;
    
    IBOutlet IMBWhiteView *_occlusionView;
    
    IBOutlet NSImageView *_popArrowImageView;
    IBOutlet NSView *_popUpButtonBgView;
    /**文件类型选择页面*/
    IBOutlet NSScrollView *_tipScrollView;
    IBOutlet NSTextView *_tipTextView;
//    IBOutlet NSArrayController *_arrayController;
    IBOutlet NSCollectionView *_connectionView;
    IBOutlet IMBBackgroundBorderView *_connectionBgView;
    IBOutlet NSView *_categorySelectView;
    IBOutlet NSTextField *_categorySelectsubTitleField;
    IBOutlet NSTextField *_categorySelectTitleField;
    NSMutableArray *_bindcategoryArray;
    /**传输页面*/
    IBOutlet NSView *_transferView;
    IBOutlet NSTextField *_transferTitleField;
    IBOutlet NSTextField *_fileNameField;
    IBOutlet IMBAnimateProgressBar *_progressviewBar;
    IBOutlet NSImageView *_warningImageView;
    IBOutlet NSTextField *_warningTipField;
    IBOutlet CloneAnimationView *_cloneAnimationView;
    /**结果页面*/
    
    IBOutlet NSView *_completeView;
    IBOutlet NSTextField *_completetitleFieFld;
    IBOutlet NSTextField *_completeSubTitleField;
    IBOutlet NSImageView *_completeDeviceImageView;
    
    IBOutlet NSImageView *_arrowImageView;
    IBOutlet NSImageView *_bgImageView;
    
    IBOutlet NSImageView *_roseProgressBgImageView;
    IBOutlet IMBBackgroundBorderView *_titleView;
    IBOutlet NSBox *_contentBox;
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
    
    //未注册的结果页面
    IBOutlet NSBox *_unregisteredBox;
    IBOutlet IMBWhiteView *_unregisteredResultView;
    IBOutlet NSTextField *_unregisteredTitle;
    IBOutlet IMBWhiteView *_unregisteredMidView;
    IBOutlet NSTextField *_unregisteredMidPromptLabel;
    IBOutlet NSTextField *_unregisteredMidLabel1;
    IBOutlet NSTextField *_unregisteredMidLabel2;
    IBOutlet NSTextField *_unregisteredMidLabel3;
    IBOutlet NSTextField *_unregisteredMidLabel4;
    IBOutlet IMBWhiteView *_unregisteredLineView;
    IBOutlet IMBWhiteView *_unregisteredThridView;
    IBOutlet NSTextField *_unregisteredThridPromptLabel;
    IBOutlet IMBGridientButton *_unregisteredBuyBtn;
    IBOutlet NSTextField *_unregisteredThridLabel1;
    IBOutlet NSTextField *_unregisteredThridLabel2;
    IBOutlet NSTextField *_unregisteredThridLabel3;
    IBOutlet NSTextField *_unregisteredThridLabel4;
    IBOutlet IMBCanClickText *_unregisteredActiveTextView;
    
    //当天额度用完的结果界面
    IBOutlet IMBWhiteView *_runOutDayCompleteView;
    IBOutlet NSTextField *_runOutDayTitleLable;
    IBOutlet NSTextField *_runOutDaySubTitleLable;
    IBOutlet IMBWhiteView *_runOutDayBgView;
    IBOutlet IMBCanClickText *_runOutDayActiveTextView;
    IBOutlet IMBGridientButton *_runOutDayStartBuyBtn;
    IBOutlet NSTextField *_runOutDayExplainLable1;
    IBOutlet NSTextField *_runOutDayExplainLable2;
    IBOutlet NSTextField *_runOutDayExplainLable3;
    IBOutlet NSTextField *_runOutDayExplainLable4;
    
    NSMutableArray *_categoryArray;
    TransferType _transferType;
    BOOL _isCategorySelect;//是否进入类别选择页面
    IMBiPod *_sourceiPod;
    IMBiPod *_targetiPod;
    NSString *_restoreiPodKey;
    BOOL _hasPhotoBack;
    IMBLogManager *_logManager;
    
    HoverButton *_closebutton;
    BOOL _isTransferComplete;
    IMBBetweenDeviceHandler *_betweenTransfer;
    NSDictionary *_accountDic;
    
    IMBiPodMenuItem *_selectedItem ;
    IBOutlet NSTextView *_textView;
    
    NSPopover *_activatePopover;
    IMBPopoverActivateViewController *_popoverViewController;
}

@property (nonatomic,assign)BOOL hasPhotoBack;
@property (nonatomic,retain)NSString *restoreiPodKey;
@property (nonatomic,retain)NSMutableArray *bindcategoryArray;
- (id)initWithiPod:(IMBiPod *)iPod CategoryInfoModelArrary:(NSMutableArray *)categoryArray TransferType:(TransferType)transferType;
- (id)initWithiCloudManager:(IMBiCloudManager *)iCloudManager CategoryInfoModelArrary:(NSMutableArray *)categoryArray TransferType:(TransferType)transferType AccountDic:(NSDictionary *)accountDic;

- (IBAction)closeWindow:(id)sender;
- (IBAction)clickCheckBox:(id)sender;

- (void)startTransfer:(IMBNewAnnoyViewController *)annoyVC;

@end

@interface IMBToMacCollectionViewItem : NSCollectionViewItem

@end
@class IMBBlankDraggableCollectionView;
@class IMBToMacCollectionViewItem;
@interface IMBToMacCollectionItemView : NSView
{
    IBOutlet IMBToMacCollectionViewItem *_collectionItem;
    IBOutlet IMBBlankDraggableCollectionView *_blankDraggableView;
    BOOL _done;
    BOOL _isSelected;
}
@property (nonatomic,assign) BOOL done;
@property (nonatomic,assign) BOOL isSelected;
@end

