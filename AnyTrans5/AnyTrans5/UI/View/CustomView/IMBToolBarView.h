//
//  IMBToolBarView.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-14.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class HoverButton;
@class IMBBaseViewController;
@class IMBSegmentedBtn;
typedef NS_ENUM(int, OperationFunctionType) {
    ReloadFunctionType= 0,
    AddFunctionType = 1,
    DeleteFunctionType = 2,
    ToiTunesFunctionType = 3,
    ToMacFunctionType = 4,
    ToDeviceFunctionType = 5,
    DeviceDatailFunctionType = 6,
    SettingFunctionType = 7,
    ExitFunctionType = 8,
    EditFunctionType = 9,
    BackupFunctionType = 10,
    ExitiCloudFunctionType = 11,
    SwitchFunctionType = 12,
    BackFunctionType = 13,
    FindFunctionType = 14,
    ContactImportFunction = 15,
    ToContactFunction = 16,
    
    UpLoadFunction = 17,
    DownLoadFunction = 18,
    MovePictureFuntion = 19,
    CreateAlbumFuntion = 20,
    NewGroupFuntion = 21,
    SyncTransferFuntion = 22,
};

@interface IMBToolBarView : NSView
{
    HoverButton *_reload;
    HoverButton *_add;
    HoverButton *_iCloudAdd;
    HoverButton *_delete;
    HoverButton *_toiTunes;
    HoverButton *_toMac;
    HoverButton *_toDevice;
    HoverButton *_deviceDatail;
    HoverButton *_setting;
    HoverButton *_exit;
    HoverButton *_edit;
    HoverButton *_backup;
    HoverButton *_icloud;
    IMBSegmentedBtn *_segmentedControl;
    HoverButton *_back;
    HoverButton *_find;
    HoverButton *_contactImport;
    HoverButton *_toContact;
    
    HoverButton *_upload;
    HoverButton *_download;
    HoverButton *_movePicture;
    HoverButton *_createAlbum;
    HoverButton *_newgroup;
    HoverButton *_syncTransfer;
    HoverButton *_androidtoiOS;
}
@property (nonatomic, retain)HoverButton *toDevice;
//屏蔽 toolBar 上button点击按钮
- (void)toolBarButtonIsEnabled:(BOOL) isenabled;
- (void)loadButtons:(NSArray *)FunctionTypeArray Target:(IMBBaseViewController *)Target DisplayMode:(BOOL)displayMode;
- (void)loadiCloudButtons:(NSArray *)FunctionTypeArray Target:(IMBBaseViewController *)Target DisplayMode:(BOOL)displayMode;
- (void)loadAndriodButtons:(NSArray *)FunctionTypeArray Target:(IMBBaseViewController *)Target DisplayMode:(BOOL)displayMode;
- (void)changeBtnTooltipStr;
- (void)icloudPhotoEnabledReload:(BOOL)isEnable;
@end
