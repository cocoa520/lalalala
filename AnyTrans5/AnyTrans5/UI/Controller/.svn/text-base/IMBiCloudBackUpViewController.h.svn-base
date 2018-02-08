//
//  IMBiCloudBackUpViewController.h
//  AnyTrans
//
//  Created by long on 16-7-29.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "IMBiPod.h"
#import "IMBiCloudClient.h"
#import "IMBBackUpTableView.h"
#import "IMBQueue.h"
#import "IMBiCloudTableView.h"
#import "LoadingView.h"
#import "IMBiCloudNetClient.h"
@interface IMBiCloudBackUpViewController : IMBBaseViewController
{
    IMBiCloudClient *_iCloudClient;
    BOOL _isComplete;
    NSFileManager *fm;
    NSNotificationCenter *nc;
    BOOL _isDisable;
    float _downloadedTotalSize;
    float _totalSize;
    BOOL _isFirstLoad;
    IMBQueue *_downLoadQueue;
    NSMutableDictionary *_downloadAtrribute;
//    IMBiCloudTableView *_itemIcloudTableView;
    IBOutlet NSBox *_iCloudBox;
    
    IBOutlet IMBiCloudTableView *_itemIcloudTableView;
    IBOutlet IMBWhiteView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    
    NSOperationQueue *_processingQueue;
    
    IBOutlet NSView *_icloudView;
    
    IBOutlet NSTextField *_titleStr;
//    IBOutlet NSBox *_noDataBoxView;
    IBOutlet LoadingView *_loadingAnimationView;
    IBOutlet IMBWhiteView *_loadingView;
    BOOL _loadEnd;
    IBOutlet IMBWhiteView *_loading;

    NSString *_appleId;
    NSMutableArray *bindingSource;
    IMBiCloudNetLoginInfo *_icloudLogInfo;
    BOOL _isError;

}

@property (nonatomic,assign) IMBiCloudTableView *itemIcloudTableView;
//进入扫描页面
-(void)jumpScanView:(IMBiCloudBackupBindingEntity*)bindingEntity WithuserPath:(NSString *)userPath;
- (id)initWithClient:(IMBiCloudClient *)icloudClient withDownloadComplete:(BOOL)isComplete withDelegate:(id)delegate withIpod:(IMBiPod *)ipod with:(NSString*)nibName  withappleId:(IMBiCloudNetLoginInfo *)loginInfo;
-(void)backBackUpView;
- (void)loadingData;
- (void)roladData;
-(void)secireOkBtnOperation:(id)sender with:(NSString *)pass;
- (void)downloadiCloudFailed:(int)downloadError;
- (void)loginNotification:(NSString *)islogin;
- (void)loadicloudnetWorkFail;
- (void)isTwoStepAuth;
- (void)analysisFail;
- (void)loadICloudDataComple;
//- (void)loadicloudDownProess:(NSDictionary *)dic;
//- (void)loadicloudDownProessComplete;
- (void)loadToolbar;
- (void)stopDownloadWithUserpath:(NSString *)userPath;
@end
