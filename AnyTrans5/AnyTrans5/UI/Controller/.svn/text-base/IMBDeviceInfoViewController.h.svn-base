//
//  IMBDeviceInfoViewController.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/9/20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "IMBVolumeBarView.h"
#import "LoadingView.h"
#import "IMBLackCornerView.h"
#import "customTextFiled.h"
@interface IMBDeviceInfoViewController : IMBBaseViewController
{
    IMBiPod *_iPod;
    NSMutableArray *_volArray;
    NSArray *_categoryArray;
    long long _capacitySize;
    long long _usedSize;
    long long _freeSize;
    NSMutableArray *_volumeRectArray;
    NSMutableArray *_volumeBarArray;
    NSMutableArray *_deviceArray;
    BOOL _isEdit;
    IMBGeneralButton *_editNameBtn;
    BOOL _isFirst;
    
    IBOutlet NSImageView *_deviceImage;
    IBOutlet customTextFiled *_deviceName;
    NSNotificationCenter *nc;
    IBOutlet NSTextField *_deviceCapacityLable;
    IBOutlet NSImageView *VolumeRectPlaceHolderImageView;
    IBOutlet NSTextField *VolumeRectPlaceHolderLabel;
    IBOutlet NSView *useinforView;
    IBOutlet IMBVolumeBarView *volumeBarImageView;
    IBOutlet IMBBorderRectAndColorView *_deviceInforView;
    IBOutlet IMBGeneralButton *_copyBtn;
    IBOutlet IMBGeneralButton *_openBtn;
    IBOutlet IMBGeneralButton *_cancelBtn;
    IBOutlet IMBWhiteView *_bgView;
    IBOutlet IMBLackCornerView *_animationView;
    IBOutlet LoadingView *_loadingView;
}

- (void)showInformationWithiPod:(IMBiPod *)iPod WithSuperView:(NSView *)superView;
@end
