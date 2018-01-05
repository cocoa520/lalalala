//
//  IMBTransferViewController.h
//  AnyTrans
//
//  Created by iMobie on 8/1/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBAnimateProgressBar.h"
#import "IMBAndroidTransfer.h"
#import "IMBCommonEnum.h"
#import "TransferAnimationView.h"
#import "BoatAnimationView.h"
#import "CarAnimationView.h"
#import "MediaTransferAnimationView.h"
#import "HoverButton.h"
#import "IMBAlertViewController.h"
#import "CommonEnum.h"
#import "IMBTransferViewController.h"
#import "IMBAndroid.h"
#import "IMBBackAndRestore.h"
#import "IMBBaseTransfer.h"
#import "IMBAndroidAlertViewController.h"
@class IMBiCloudManager;

@interface IMBAndroidTransferViewController : NSViewController<TransferDelegate,NSTextViewDelegate> {
    IBOutlet NSTextField *_backUpProgressLable;
    IBOutlet IMBAnimateProgressBar *_animateProgressView;
    IBOutlet NSTextField *_titleStr;
    IBOutlet NSTextField *_promptLabel;
    IBOutlet NSImageView *_noteImageView;
    IBOutlet IMBWhiteView *_contentProView;
    IBOutlet NSBox *_contentBox;
    IBOutlet TransferAnimationView *_customAnimationView;
    IBOutlet BoatAnimationView *_boatAnimationView;
    IBOutlet CarAnimationView *_carAnimationView;
    IBOutlet MediaTransferAnimationView *_mediaAnimationView;
    IBOutlet NSView *_proContentView;
    IBOutlet NSView *_contentView;
    IBOutlet NSView *_resultContentView;
    
    IBOutlet NSTextView *_resultSubTextView;
    IBOutlet NSTextField *_resultMainStr;
    IBOutlet NSTextView *_textView;
    IBOutlet NSImageView *_roseProgressBgImageView;
    IBOutlet NSImageView *_bellImgView;
    
    //move to iOS完成活动界面
    IBOutlet IMBWhiteView *_moveToiOSCompleteView;
    IBOutlet NSView *_atContentView;
    IBOutlet NSImageView *_moveToiOSCompleteImageView;
    
    IBOutlet NSTextView *_moveToiOSCompleteTitle;
    IBOutlet NSTextField *_moveToiOSCompleteSubTitle;
    IBOutlet NSTextView *_moveToiOSCompleteDetailStr;
    IBOutlet IMBGridientButton *_moveToiOSCompleteBtn;
    
    //move to iOS完成活动界面- 英语版
    IBOutlet IMBWhiteView *_enmoveToiOSCompleteView;
    IBOutlet NSView *_enAtContentView;
    IBOutlet NSImageView *_enmoveToiOSCompleteImageView;
    
    IBOutlet NSTextView *_enmoveToiOSCompleteTitle;
    IBOutlet NSTextField *_enmoveToiOSCompleteSubTitle;
    IBOutlet NSTextView *_enmoveToiOSCompleteDetailStr;
    IBOutlet IMBGridientButton *_enmoveToiOSCompleteBtn;
    int _successCount;
    int _totalCount;
    
    CategoryNodesEnum _category;
    NSMutableArray *_selectedItems;
    IMBAndroidTransfer *_baseTransfer;
    NSDictionary *_selectDic;
    TransferAnimationType _animationType;
    TransferModeType _transferType;
    id _delegate;
    HoverButton *_closebutton;
    BOOL _isTransferComplete;
    IMBAlertViewController *_alertViewController;
    IMBAndroidAlertViewController *_androidAlertViewController;
    EventCategory _eventCategory;
    BOOL _isStop;
    NSTimer *_annoyTimer;
    BOOL _isPause;
    NSCondition *_condition;
    IMBiCloudManager *_iCloudManager;
    IMBAndroid *_android;
    NSArray *_dataAry;
    IMBiPod *_iPod;
    IMBBackAndRestore *_backRestore;
    IMBBaseTransfer *_calendarsBaseTransfer;
    
    NSURL *_hostUrl;
}
@property (nonatomic,assign) BOOL isStop;
@property (nonatomic,assign) id delegate;

/**
 *  设备到设备初始化
 *
 *  @param ipod
 *
 *  @param android
 *
 *  @param selectedDic 选择的数据
 *
 *  @param categoryNodeEnum 传输的类别
 */
- (id)initWithIpodKey:(IMBiPod *)ipod withAndroid:(IMBAndroid *)android SelectDic:(NSDictionary *)selectedDic withCategoryNodesEnum:(CategoryNodesEnum)categoryNodeEnum ;
/**
 *  to iCloud
 *
 *  @param iCloudManager
 *
 *  @param android
 *
 *  @param selectedDic 选择的数据封装过
 *
 *  @param dataAry 选择的数据
 *
 *  @param categoryNodeEnum 传输的类别
 */
- (id)initWithAndroidToiCloud:(IMBiCloudManager *)iCloudManager withAndroid:(IMBAndroid *)android SelectDic:(NSDictionary *)selectedDic withDataAry:(NSArray*)dataAry withCategoryNodesEnum:(CategoryNodesEnum)categoryNodeEnum;
/**
 *  to iTunes
 *
 *  @param android
 *
 *  @param selectedDic 选择的数据
 *
 *  @param categoryNodeEnum 传输的类别
 */
- (id)initWithAndroidToiTunesAndroid:(IMBAndroid *)android SelectDic:(NSDictionary *)selectedDic withCategoryNodesEnum:(CategoryNodesEnum)categoryNodeEnum;
- (void)moveBellImageView:(int)moveX;
- (void)startTransAnimation;
@end
