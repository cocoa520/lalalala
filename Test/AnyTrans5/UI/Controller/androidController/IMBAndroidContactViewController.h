//
//  IMBContactViewController.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-27.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBCustomHeaderTableView.h"
#import "IMBWhiteView.h"
#import "IMBPopUpBtn.h"
#import "IMBFilpedView.h"
#import "LoadingView.h"

@class IMBContactEntity;
@interface IMBAndroidContactViewController : IMBBaseViewController<NSTableViewDelegate,NSTableViewDataSource,IMBImageRefreshListListener, TransferDelegate>
{
    
    IBOutlet IMBWhiteView *_rightLineView;
    IBOutlet NSBox *_mainBox;
    IBOutlet NSView *_detailView;
    IBOutlet NSView *_nodataView;
    IBOutlet NSImageView *_nodataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    NSTextField *_subTextField;
    NSTextField *_nameTextField;
    NSImageView *_headImageView;
    CALayer *_headImageLayer;
    NSMutableArray *_deletedAry;
    NSMutableArray *_existenceAry;
    float _count;
    IMBADContactEntity *_currentContactData;
    NSMutableArray *_itemArray;
    IBOutlet NSView *_rootView;
}
@property (assign) IBOutlet IMBFilpedView *contentCustomView;
@property (assign) IBOutlet NSImageView *headImageView;
@property (assign) IBOutlet NSTextField *nameTextField;
@property (assign) IBOutlet NSTextField *subTextField;

@end
