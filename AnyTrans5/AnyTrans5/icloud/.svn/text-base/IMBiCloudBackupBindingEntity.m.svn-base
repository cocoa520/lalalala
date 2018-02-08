//
//  IMBiCloudBackupBindingEntity.m
//  PhoneRescue
//
//  Created by 肖体华 on 14-9-26.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBiCloudBackupBindingEntity.h"
#import "IMBiCloudClient.h"
//#import "IMBHelper.h"
//#import "IMBiCloudButton.h"
#import "IMBiCloudDownloadProgressView.h"
#import "IMBiCloudDeleteButton.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "IMBNotificationDefine.h"
@implementation IMBiCloudBackupBindingEntity
@synthesize delegate = _delegate;
@synthesize size = _size;
@synthesize backupItem = _backupItem;
@synthesize btniCloudCommon = _btniCloudCommon;
@synthesize loadType = _loadType;
@synthesize showText = _showText;
@synthesize progressView = _progressView;
@synthesize deleteButton = _deleteButton;
@synthesize userPtath = _userPath;
@synthesize isMouseEntered = _isMouseEntered;
@synthesize findPathBtn = _findPathBtn;
@synthesize closeDownBtn = _closeDownBtn;

- (id)init {
    if (self = [super init]) {
        _btniCloudCommon = [[IMBMyDrawCommonly alloc] init];
        [_btniCloudCommon setBezelStyle:NSRoundedBezelStyle];
        [_btniCloudCommon.cell setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
        _size = @"";
        _showText  = [[NSTextField alloc] init];
        [_showText setBordered:NO];
        [_showText setEditable:NO];
        [_showText setBackgroundColor:[NSColor clearColor]];
        [_showText setAlignment:NSLeftTextAlignment];
        _progressView = [[IMBiCloudDownloadProgressView alloc] init];
        _deleteButton = [[IMBiCloudDeleteButton alloc] init];
        [_deleteButton setImageWithWithPrefixImageName:@"icloud_delete"];
        
        _closeDownBtn = [[IMBiCloudDeleteButton alloc] init];
        [_closeDownBtn setImageWithWithPrefixImageName:@"icloudClose"];
        
        _findPathBtn = [[IMBiCloudDeleteButton alloc] init];
        [_findPathBtn setImageWithWithPrefixImageName:@"icloud_ser"];
//        [self.progressView addSubview:_btniCloudCommon];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
        _isMouseEntered = NO;
    }
    return self;
}

- (void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (_loadType) {
            case iCloudDataDownLoad:{
                NSString *string = CustomLocalizedString(@"iCloudBackup_View_Tips2", nil);
                NSRect rect = [StringHelper calcuTextBounds:string fontSize:12];
                [(IMBMyDrawCommonly *)_btniCloudCommon setTitleName:string WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                [_btniCloudCommon setFrame:NSMakeRect(_btniCloudCommon.frame.origin.x, _btniCloudCommon.frame.origin.y, (int)rect.size.width + 40, 20)];
                break;
            }
            case iCLoudDataContinue:{
                NSString *string = CustomLocalizedString(@"iCloudBackup_View_Tips3", nil);
                NSRect rect = [StringHelper calcuTextBounds:string fontSize:12];
                [(IMBMyDrawCommonly *)_btniCloudCommon setTitleName:string WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                [_btniCloudCommon setFrame:NSMakeRect(_btniCloudCommon.frame.origin.x, _btniCloudCommon.frame.origin.y, (int)rect.size.width + 40, 20)];
                break;
            }
            case iCloudDataWaitingDownLoad:{
                NSString *string = CustomLocalizedString(@"iCloudBackup_View_Tips5", nil);
                [_showText setStringValue:string];
                break;
            }
                
            case iCloudDataCancelDownLoad:{
                NSString *string = CustomLocalizedString(@"iCloudBackup_View_CancelBtn", nil);
                NSRect rect = [StringHelper calcuTextBounds:string fontSize:12];
                [(IMBMyDrawCommonly *)_btniCloudCommon setTitleName:string WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                [_btniCloudCommon setFrame:NSMakeRect(_btniCloudCommon.frame.origin.x, _btniCloudCommon.frame.origin.y, (int)rect.size.width + 40, 20)];
                break;
            }
            case iCloudDataDownLoading:{
                [_closeDownBtn setImageWithWithPrefixImageName:@"icloudClose"];
                
                [_progressView setFrame:NSMakeRect(_progressView.frame.origin.x, _progressView.frame.origin.y, 84, 8)];
                break;
            }
            case iCloudDataComplete:{
                NSString *string = CustomLocalizedString(@"iCloudBackup_View_Tips6", nil);
                NSRect rect = [StringHelper calcuTextBounds:string fontSize:12];
                [(IMBMyDrawCommonly *)_btniCloudCommon setTitleName:string WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                [_btniCloudCommon setFrame:NSMakeRect(_btniCloudCommon.frame.origin.x, _btniCloudCommon.frame.origin.y, (int)rect.size.width + 40, 20)];
                break;
            }
            case iCloudDataDelete:{
                NSString *string = CustomLocalizedString(@"Menu_Delete", nil);
                NSRect rect = [StringHelper calcuTextBounds:string fontSize:12];
                [(IMBMyDrawCommonly *)_btniCloudCommon setTitleName:string WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                [_btniCloudCommon setFrame:NSMakeRect(_btniCloudCommon.frame.origin.x, _btniCloudCommon.frame.origin.y, (int)rect.size.width + 40, 20)];
                break;
            }
            case iCloudDataFail:{
                NSString *string = CustomLocalizedString(@"iCloudBackup_View_Tips1", nil);
                [_showText setStringValue:string];
                break;
            }
            default:
                break;
        }

    });
    
}

- (void)setLoadType:(iCLoudLoadType)loadType {
    _loadType = loadType;
    switch (loadType) {
        case iCloudDataDownLoad:{
            NSString *string = CustomLocalizedString(@"iCloudBackup_View_Tips2", nil);
            [_btniCloudCommon setTitle:string];
            [(IMBMyDrawCommonly *)_btniCloudCommon setTitleName:string WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
            NSRect rect = [StringHelper calcuTextBounds:string fontSize:12];
            [_btniCloudCommon setFrame:NSMakeRect(_btniCloudCommon.frame.origin.x, _btniCloudCommon.frame.origin.y,(int)rect.size.width + 40, 20)];
            [_btniCloudCommon setTarget:self];
            [_btniCloudCommon setAction:@selector(downloadData:)];
            break;
        }
        case iCLoudDataContinue:{
            NSString *string = CustomLocalizedString(@"iCloudBackup_View_Tips3", nil);
            [(IMBMyDrawCommonly *)_btniCloudCommon setTitleName:string WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
            [_btniCloudCommon setTitle:string];
            NSRect rect = [StringHelper calcuTextBounds:string fontSize:12];
            [_btniCloudCommon setFrame:NSMakeRect(_btniCloudCommon.frame.origin.x, _btniCloudCommon.frame.origin.y, (int)rect.size.width + 40, 20)];
            [_btniCloudCommon setTarget:self];
            [_btniCloudCommon setAction:@selector(downloadData:)];
            break;
        }
        case iCloudDataWaitingDownLoad:{
            NSString *string = CustomLocalizedString(@"iCloudBackup_View_Tips5", nil);
            [_showText setStringValue:string];
            break;
        }
           
        case iCloudDataCancelDownLoad:{
            NSString *string = CustomLocalizedString(@"iCloudBackup_View_CancelBtn_Tips", nil);
            NSRect rect = [StringHelper calcuTextBounds:string fontSize:12];
            [(IMBMyDrawCommonly *)_btniCloudCommon setTitleName:string WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
            [_btniCloudCommon setTitle:string];
            [_btniCloudCommon setFrame:NSMakeRect(_btniCloudCommon.frame.origin.x, _btniCloudCommon.frame.origin.y,(int)rect.size.width + 40, 20)];
            [_btniCloudCommon setTarget:self];
            [_btniCloudCommon setAction:@selector(cancelDownload:WithUserPath:)];
            break;
        }
        case iCloudDataDownLoading:{
            [_closeDownBtn setImageWithWithPrefixImageName:@"icloudClose"];
            
            [_progressView setFrame:NSMakeRect(_progressView.frame.origin.x, _progressView.frame.origin.y, 84, 6)];
            [_closeDownBtn setTarget:self];
            [_closeDownBtn setAction:@selector(stopDownloadWithUserpath:)];
            break;
        }
        case iCloudDataComplete:{
            NSString *string = CustomLocalizedString(@"iCloudBackup_View_Tips6", nil);
            NSRect rect = [StringHelper calcuTextBounds:string fontSize:12];
            [_btniCloudCommon setTitle:string];
            [(IMBMyDrawCommonly *)_btniCloudCommon setTitleName:string WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
            [_btniCloudCommon setFrame:NSMakeRect(_btniCloudCommon.frame.origin.x, _btniCloudCommon.frame.origin.y,(int)rect.size.width + 40, 20)];
            [_btniCloudCommon setTarget:self];
            [_btniCloudCommon setAction:@selector(jumpScanView:)];
            break;
        }
        case iCloudDataDelete:{
            [_deleteButton setImageWithWithPrefixImageName:@"icloud_delete"];
            [_deleteButton setTarget:self];
            [_deleteButton setAction:@selector(deletefile:)];
            
            [_findPathBtn setTarget:self];
            [_findPathBtn setAction:@selector(selectedfindPathBtn:)];
            NSString *string = CustomLocalizedString(@"Menu_Delete", nil);
            NSRect rect = [StringHelper calcuTextBounds:string fontSize:12];
            [(IMBMyDrawCommonly *)_btniCloudCommon setTitleName:string WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
            [_btniCloudCommon setFrame:NSMakeRect(_btniCloudCommon.frame.origin.x, _btniCloudCommon.frame.origin.y, (int)rect.size.width + 40, 20)];
            [_btniCloudCommon setTarget:self];
            [_btniCloudCommon setAction:@selector(deletefile:)];
            break;
        }
        case iCloudDataFail:{
            NSString *string = CustomLocalizedString(@"iCloudBackup_View_Tips1", nil);
            [_showText setStringValue:string];
            break;
        }
        default:
            break;
    }
    
}

- (iCLoudLoadType)loadType {
    return _loadType;
}

- (void)downloadData:(id)sender{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(handleBackup:withUserPath:)]) {
        [_delegate handleBackup:self withUserPath:_userPath];
    }
}
- (void)cancelDownload:(IMBiCloudBackupBindingEntity*)bindingEntity WithUserPath:(NSString *)userPath{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(cancelDownload:WithUserPath:)]) {
        [_delegate cancelDownload:self WithUserPath:_userPath];
    }
}

- (void)stopDownloadWithUserpath:(NSString *)userPath{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(stopDownloadWithUserpath:)]) {
        [_delegate stopDownloadWithUserpath:_userPath];
    }
}
- (void)deletefile:(id)sender{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(deleteDownloadFile:WithUserPath:)]) {
        [_delegate deleteDownloadFile:self WithUserPath:_userPath];
    }
}

- (void)jumpScanView:(id)sender{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(jumpScanView:WithuserPath:)]) {
        [_delegate jumpScanView:self WithuserPath:_userPath];
    }
}

-(void)selectedfindPathBtn:(id)sender{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(findDownloadFile:WithUserPath:)]) {
        [_delegate findDownloadFile:self WithUserPath:_userPath];
    }
}
- (void)removeAllView{
//    dispatch_async(dispatch_get_main_queue(), ^{
        [_showText removeFromSuperview];
        [_deleteButton removeFromSuperview];
        [_btniCloudCommon removeFromSuperview];
        [_progressView removeFromSuperview];
        [_findPathBtn removeFromSuperview];
        [_closeDownBtn removeFromSuperview];
//    });
}

- (void)dealloc{
    [super dealloc];
    if (_btniCloudCommon != nil) {
        [_btniCloudCommon release];
        _btniCloudCommon = nil;
    }
    if (_progressView != nil) {
        [_progressView release];
        _progressView = nil;
    }
    if (_deleteButton != nil) {
        [_deleteButton release];
        _deleteButton = nil;
    }
    if (_closeDownBtn != nil) {
        [_closeDownBtn release];
        _closeDownBtn = nil;
    }
    if (_showText != nil) {
        [_showText release];
        _showText = nil;
    }
    if (_findPathBtn != nil) {
        [_findPathBtn release];
        _findPathBtn = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
}
@end
