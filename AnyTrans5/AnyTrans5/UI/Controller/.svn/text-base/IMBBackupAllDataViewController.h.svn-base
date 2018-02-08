//
//  IMBBackupAllDataViewController.h
//  AnyTrans
//
//  Created by long on 16-7-26.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "SimpleNode.h"
#import "IMBBoxView.h"
#import "HoverButton.h"
#import "IMBiCloudClient.h"
#import "IMBMenuPopupButton.h"
@interface IMBBackupAllDataViewController : IMBBaseViewController
{
    IBOutlet NSImageView *_arrowwhiteImageView;
    NSOperationQueue *operationQueue;
    SimpleNode *node;
    NSMutableDictionary *_containerDic;
    IBOutlet IMBBoxView *_boxContainer;
    NSMutableArray *_dataAry;
    IBOutlet IMBWhiteView *_lineView;
    IBOutlet NSProgressIndicator *indicatorView;
    IBOutlet IMBWhiteView *progressView;
    BOOL _exporerLoading;
    BOOL _notesLoading;
    BOOL _contactsLoading;
    BOOL _bookMarksLoading;
    BOOL _calendarLoading;
    BOOL _voiceMailLoading;
    BOOL _messageLoading;
    BOOL _callHistoryLoading;
    BOOL _historyLoading;
    IMBBackupDecryptAbove4 *_backUpDecrypt;
    IMBiCloudBackup *_icloudbackUp;
    IBOutlet NSTextField *_titleLable;
@public
    IBOutlet IMBMenuPopupButton *_popUpButton;
    IBOutlet IMBWhiteView *_arrowWhiteView;

}

-(id)initWithIMBiCloudBackup:(IMBiCloudBackup *)icloudBackup WithDelegate:(id)delegate;
-(id)initWithSimpleNode:(SimpleNode *)simpNode withDelegate:(id)delegate withAcove4:(IMBBackupDecryptAbove4 *)dAbove4;
@end
