//
//  IMBiCloudBackupBindingEntity.h
//  PhoneRescue
//
//  Created by 肖体华 on 14-9-26.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"
#import "IMBiCloudDownloadProgressView.h"
#import "IMBMyDrawCommonly.h"

@class IMBiCloudBackup;
//@class IMBiCloudButton;
@class IMBiCloudDeleteButton;
@class IMBiCloudBackupBindingEntity;

@protocol downloadProtocol
- (void)handleBackup:(IMBiCloudBackupBindingEntity*)bindingEntity withUserPath:(NSString *)userPath;
- (void)deleteDownloadFile:(IMBiCloudBackupBindingEntity*)bindingEntity WithUserPath:(NSString *)userPath;
- (void)findDownloadFile:(IMBiCloudBackupBindingEntity*)bindingEntity WithUserPath:(NSString *)userPath;
- (void)stopDownloadWithUserpath:(NSString *)userPath;
- (void)cancelDownload:(IMBiCloudBackupBindingEntity*)bindingEntity WithUserPath:(NSString *)userPath;
- (void)jumpScanView:(IMBiCloudBackupBindingEntity*)bindingEntity WithuserPath:(NSString *)userPath;

@end

@interface IMBiCloudBackupBindingEntity : NSObject {
@private
    id _delegate;
    NSString *_size;
    IMBiCloudBackup *_backupItem;
    IMBMyDrawCommonly *_btniCloudCommon;
    NSTextField *_showText;
    iCLoudLoadType _loadType;
    IMBiCloudDownloadProgressView *_progressView;
    IMBiCloudDeleteButton *_deleteButton;
    IMBiCloudDeleteButton *_findPathBtn;
    NSString *_userPath;
    BOOL _isMouseEntered;
    IMBiCloudDeleteButton *_closeDownBtn;
   
}
@property (nonatomic, readwrite, retain) IMBiCloudDeleteButton *closeDownBtn;
@property (nonatomic, readwrite, assign) id delegate;
@property (nonatomic, readwrite, retain) NSString *size;
@property (nonatomic, readwrite, retain) IMBiCloudBackup *backupItem;

@property (nonatomic, readwrite, retain) IMBMyDrawCommonly *btniCloudCommon;
@property (nonatomic, readwrite, retain) IMBiCloudDeleteButton *deleteButton;
@property (nonatomic, readwrite, retain) IMBiCloudDeleteButton *findPathBtn;
@property (nonatomic, setter = setLoadType:, getter = loadType, assign) iCLoudLoadType loadType;
@property (nonatomic, readwrite, retain) NSTextField *showText;
@property (nonatomic, readwrite, retain) IMBiCloudDownloadProgressView *progressView;
@property (nonatomic, readwrite, retain) NSString *userPtath;
@property (nonatomic, readwrite, assign) BOOL isMouseEntered;

- (void)removeAllView;

- (void)setLoadType:(iCLoudLoadType)loadType;
- (iCLoudLoadType)loadType;

@end
