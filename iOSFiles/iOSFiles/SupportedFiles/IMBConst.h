//
//  IMBConst.h
//  iOSFiles
//
//  Created by iMobie on 18/1/25.
//  Copyright © 2018年 iMobie. All rights reserved.
//  字符串常量之间可以直接用 == 来进行判断两个字符串是否一样，这样的效率远比  isEqualToString:  高多了

#import <AppKit/AppKit.h>

#pragma mark - notifications

APPKIT_EXTERN NSString * const IMBSelectedDeviceDidChangeNotiWithParams;
APPKIT_EXTERN NSString * const IMBSelectedDeviceDidChangeNoti;
APPKIT_EXTERN NSString * const IMBDevicePageRefreshClickedNoti;
APPKIT_EXTERN NSString * const IMBDevicePageToMacClickedNoti;
APPKIT_EXTERN NSString * const IMBDevicePageAddToDeviceClickedNoti;
APPKIT_EXTERN NSString * const IMBDevicePageDeleteClickedNoti;
APPKIT_EXTERN NSString * const IMBDevicePageToDeviceClicxkedNoti;

APPKIT_EXTERN NSString * const IMBDevicePageStartLoadingAnimNoti;
APPKIT_EXTERN NSString * const IMBDevicePageStopLoadingAnimNoti;

APPKIT_EXTERN NSString * const IMBDevicePageShowToolbarNoti;
APPKIT_EXTERN NSString * const IMBDevicePageHideToolbarNoti;

APPKIT_EXTERN NSString * const IMBGridViewCommandANoti;
//设备数据加载完成
APPKIT_EXTERN NSString * const DeviceDataLoadCompletePhoto;
APPKIT_EXTERN NSString * const deviceDataLoadCompleteBooks;
APPKIT_EXTERN NSString * const DeviceDataLoadCompleteApp;
APPKIT_EXTERN NSString * const deviceDataLoadCompleteMedia;
APPKIT_EXTERN NSString * const DeviceDataLoadCompleteVideo;
APPKIT_EXTERN NSString * const DeviceDataLoadCompleteAppDoucment;
#pragma mark - plists
APPKIT_EXTERN NSString * const IMBDevicePageHeaderTitleNamesPlist;
APPKIT_EXTERN NSString * const IMBDevicePageFolderNamesPlist;
APPKIT_EXTERN NSString * const IMBDetailVCHeaderTitleTrackNamesPlist;
APPKIT_EXTERN NSString * const DetailVCHeaderTitleAppNamesPlist;
APPKIT_EXTERN NSString * const DetailVCHeaderTitleBookNamesPlist;
APPKIT_EXTERN NSString * const DetailVCHeaderTitlePhotoNamesPlist;
APPKIT_EXTERN NSString * const DetailVCHeaderTitleSubPhotoNamesPlist;

APPKIT_EXTERN NSString * const IMBiCloudUserName;

#pragma mark - 全局关联key
APPKIT_EXTERN char kIMBDevicePageRootBoxKey;
APPKIT_EXTERN char kIMBDevicePageToolBarViewKey;
APPKIT_EXTERN char kIMBPhotoCategoryControllerKey;
APPKIT_EXTERN char kIMBDevicePageWindowKey;
APPKIT_EXTERN char kIMBMainWindowAlertView;
APPKIT_EXTERN char kIMBMainPageWindowAlertView;


#pragma mark - font
APPKIT_EXTERN NSString * const IMBCommonFont;
