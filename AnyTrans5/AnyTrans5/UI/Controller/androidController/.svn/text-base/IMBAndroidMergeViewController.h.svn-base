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
#import "CloneAnimationView.h"
#import "IMBAndroidMergeViewController.h"
#import "HoverButton.h"
#import "IMBBaseViewController.h"
#import "IMBMergeOrCloneViewController.h"
#import "IMBTransferToiOS.h"
#import "IMBTextButtonView.h"
@class IMBBaseTransfer;
@class IMBiPodMenuItem;

@interface IMBAndroidMergeViewController : IMBBaseViewController<NSTextViewDelegate,TransferDelegate>
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
    //move to iOS完成活动界面
    IBOutlet IMBWhiteView *_moveToiOSCompleteView;
    IBOutlet NSImageView *_moveToiOSCompleteImageView;
    IBOutlet NSTextView *_moveToiOSCompleteTitle;
    IBOutlet NSTextField *_moveToiOSCompleteSubTitle;
    IBOutlet NSTextView *_moveToiOSCompleteDetailStr;
    IBOutlet IMBGridientButton *_moveToiOSCompleteBtn;
    //move to iOS完成活动界面- 英语版
    IBOutlet IMBWhiteView *_enmoveToiOSCompleteView;
    IBOutlet NSImageView *_enmoveToiOSCompleteImageView;
    IBOutlet NSTextView *_enmoveToiOSCompleteTitle;
    IBOutlet NSTextField *_enmoveToiOSCompleteSubTitle;
    IBOutlet NSTextView *_enmoveToiOSCompleteDetailStr;
    IBOutlet IMBGridientButton *_enmoveToiOSCompleteBtn;
    int _successCount;
    int _totalCount;
    NSMutableArray *_categoryArray;
    TransferType _transferType;
    BOOL _isCategorySelect;//是否进入类别选择页面
    NSURL *_hostUrl;
    IMBiPod *_targetiPod;
    NSString *_restoreiPodKey;
    BOOL _hasPhotoBack;
    IMBLogManager *_logManager;
    HoverButton *_closebutton;
    BOOL _isTransferComplete;
    IMBBetweenDeviceHandler *_betweenTransfer;
    NSDictionary *_accountDic;
    IMBiPodMenuItem *_selectedItem ;
    IMBAndroidTransfer *_baseTransfer;
    BOOL _isNoDevice;
    IBOutlet NSTextView *_textView;
}

@property (nonatomic,assign)BOOL hasPhotoBack;
@property (nonatomic,retain)NSString *restoreiPodKey;
@property (nonatomic,retain)NSMutableArray *bindcategoryArray;

/**to devcie 初始化
 * @param IMBiPod ios设备句柄
 *
 * @param categoryArray 需要传输的类型
 *
 * @param transferType  传输的方式
 *
 * @param android  android设备的句柄
 */
- (id)initWithiPod:(IMBiPod *)iPod CategoryInfoModelArrary:(NSMutableArray *)categoryArray TransferType:(TransferType)transferType WithAndroid:(IMBAndroid *)android;

/**to icloud 初始化
 * @param iCloudManager 管理类
 *
 * @param categoryArray 需要传输的类型
 *
 * @param accountDic  登陆的icloud账号
 *
 * @param android  android设备的句柄
 */
- (id)initWithiCloudManager:(IMBiCloudManager *)iCloudManager WithAndroid:(IMBAndroid *)android AccountDic:(NSDictionary *)accountDic CategoryInfoModelArrary:(NSMutableArray *)categoryArray;

/**to itunes 初始化
 * @param categoryArray 需要传输的类型
 *
 * @param android  android设备的句柄
 */
- (id)initToiTunesAndroid:(IMBAndroid *)android CategoryInfoModelArrary:(NSMutableArray *)categoryArray;

- (IBAction)closeWindow:(id)sender;

//选择类型的checkbox
- (IBAction)clickCheckBox:(id)sender;

@end


