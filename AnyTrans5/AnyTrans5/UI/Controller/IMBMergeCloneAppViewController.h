//
//  IMBMergeCloneAppViewController.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/26.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBiPod.h"
#import "IMBGeneralButton.h"
#import "IMBBorderRectAndColorView.h"
#import "IMBApplicationManager.h"
#import "IMBWhiteView.h"
#import "IMBScrollView.h"
@interface IMBMergeCloneAppViewController : NSViewController
{
    
    IBOutlet IMBScrollView *_scrollView;
    IBOutlet IMBGeneralButton *_okBtn;
    IBOutlet IMBGeneralButton *_cancelBtn;
    IBOutlet NSTextField *_mainTitle;
    IBOutlet NSCollectionView *_collectionView;
    IBOutlet IMBBorderRectAndColorView *_alertView;
    IBOutlet NSArrayController *_arrayController;
    IBOutlet IMBWhiteView *_bgView;
    NSMutableArray *_itemArray;
    NSView *_mainView;
    int _result;
    BOOL _endRunloop;
    IMBiPod *_sourceiPod;
    IMBiPod *_targetiPod;
    BOOL _isToDevice;
    NSMutableArray *_sourceApps;
}
@property (nonatomic, retain) NSMutableArray *itemArray;
@property (nonatomic, assign) BOOL isToDevice;
@property (nonatomic, assign) NSMutableArray *sourceApps;
- (int)showTitleString:(NSString *)title OkButton:(NSString *)OkText CancelButton:(NSString *)cancelText TargetiPod:(IMBiPod *)targetiPod sourceiPod:(IMBiPod *)sourceiPod SuperView:(NSView *)superView;
@end
