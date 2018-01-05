//
//  IMBSkinSwitchViewController.h
//  AnyTrans
//
//  Created by iMobie on 10/18/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBDownloadFile.h"
#import "IMBSkinButton.h"
#import "IMBiCloudDeleteButton.h"
#import "IMBFilpedView.h"
#import "LoadingView.h"
@class IMBSkinCollectionItemView;
@class IMBSkinEntity;

@interface IMBSkinSwitchViewController : IMBBaseViewController<IMBDownLoadProgress> {
    NSString *_skinPath;
    NSFileManager *fm;
    NSMutableArray *_skinArray;
    int _skinCount;
//    IMBDownloadFile *_downloadFile;
    BOOL _isDownloadPlist;
    NSMutableArray *_downloadArray;
    IMBFilpedView *_filpedView;
    BOOL _isSwitchSkin;
    NSPopover *_loadPopover;
    
    IBOutlet NSTextField *_titleTextField;
    IBOutlet NSView *_contentCustomView;
    IBOutlet NSView *_mainCustomView;
    IBOutlet NSScrollView *_skinScrollView;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    IBOutlet NSBox *_contentBox;
}
@property (nonatomic, retain) NSMutableArray *skinArray;

- (void)downloadFile:(NSString *)downloadUrlPath isDownloadPlist:(BOOL)isDownloadPlist DownloadFileName:(NSString *)downloadFileName;
- (void)removeDownloadArray:(NSString *)fileName;

@end

@interface IMBDownloadSkinProgressView : NSView {
    float _progress;
    float _curProgress;
    BOOL _isDownloadSucess;
//    IMBiCloudDeleteButton *_closeBtn;
}
@property (nonatomic, assign) BOOL isDownloadSucess;

- (void)setProgress:(float)progress;

@end

@interface IMBSkinCollectionItemView : NSView <NSTableViewDelegate> {
    IMBSkinEntity *_skinEntity;
    int _isBigView;
    NSImageView *_bgImageView;
    IMBDownloadSkinProgressView *_progressView;
    NSTextField *_progressField;
    IMBiCloudDeleteButton *_closeBtn;
    NSTextView *_textView;
    NSImageView *_selectImageView;
    NSTextField *_homeNameText;
    id _delegate;
}
@property (nonatomic, assign) int isBigView;
@property (nonatomic, retain) NSImageView *bgImageView;
@property (nonatomic, retain) IMBSkinEntity *skinEntity;
@property (nonatomic, retain) IMBDownloadSkinProgressView *progressView;
@property (nonatomic, retain) NSImageView *selectImageView;

- (id)initWithFrame:(NSRect)frameRect withSkinEntity:(IMBSkinEntity *)skinEntity delegate:(id)delegate;
- (void)addContentView;
- (void)addProgressVeiw;
- (void)reloadProgressValue:(float)value;
- (void)addDownloadErrorField;
- (void)downloadComplete;

@end

@interface IMBSkinEntity : NSObject {
    NSString *_skinName;
    NSAttributedString *_skinNameAs;
    NSString *_downloadPath;
    NSString *_skinImageName;
    NSImage *_skinImage;
    NSString *_thumbDownloadPath;
    BOOL _isNoSelect;
    BOOL _isDownload;
    NSString *_skinPackName;
    IMBSkinButton *_skinBtn;
    BOOL _isNew;
    NSString *_skinVersion;
    
    NSString *_enSkinName;
    NSString *_frSkinName;
    NSString *_jaSkinName;
    NSString *_geSkinName;
    NSString *_esSkinName;
    NSString *_arSkinName;
    NSString *_chSkinName;
}

@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, retain) NSString *skinVersion;
@property (nonatomic, retain) IMBSkinButton *skinBtn;
@property (nonatomic, retain) NSString *skinPackName;
@property (nonatomic, retain) NSAttributedString *skinNameAs;
@property (nonatomic, retain) NSString *skinName;
@property (nonatomic, retain) NSString *downloadPath;
@property (nonatomic, retain) NSString *skinImageName;
@property (nonatomic, retain) NSImage *skinImage;
@property (nonatomic, assign) BOOL isNoSelect;
@property (nonatomic, assign) BOOL isDownload;
@property (nonatomic, retain) NSString *thumbDownloadPath;
@property (nonatomic, retain) NSString *enSkinName;
@property (nonatomic, retain) NSString *frSkinName;
@property (nonatomic, retain) NSString *jaSkinName;
@property (nonatomic, retain) NSString *geSkinName;
@property (nonatomic, retain) NSString *esSkinName;
@property (nonatomic, retain) NSString *arSkinName;
@property (nonatomic, retain) NSString *chSkinName;
- (void)setSkinNameAttributedString;

@end