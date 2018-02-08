//
//  IMBBackupContactViewController.h
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "IMBEditButton.h"
#import "IMBFilpedView.h"
#import "IMBAddressBookDataEntity.h"
#import "IMBScrollView.h"
#import "LoadingView.h"
#import "SimpleNode.h"
@interface IMBBackupContactViewController : IMBBaseViewController
{
    IBOutlet NSImageView *_nodataImageView;
    NSTextField *_companyTextField;
    NSTextField *_nameTextField;
    NSString *_backUpPath;
    NSString *_iOSProductVersion;
    IMBEditButton *_editButton;
    IMBEditButton *_cancelButton;
    NSMutableArray *_blockArray;
    NSMutableArray *_unAddedArr;
    IBOutlet IMBWhiteView *_rightLineView;
    IBOutlet NSImageView *_headBgImgView;
    IBOutlet NSImageView *_headImgView;
    IMBFilpedView *_contentCustomView;
    IBOutlet NSBox *_contactBox;
    IBOutlet NSView *_noDataView;
    IBOutlet NSView *_dataView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSTextField *_noDataTitle;
//    SimpleNode *_simpleNode;
    IMBBackupDecryptAbove4 *_decryptAbove4;
    IMBiCloudBackup *_iCloudBackUp;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    IBOutlet IMBWhiteView *_rightBgView;
}
@property (assign) IBOutlet NSTextField *nameTextField;
@property (assign) IBOutlet NSTextField *companyTextField;
@property (assign) IBOutlet IMBFilpedView *contentCustomView;
@end
