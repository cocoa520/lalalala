//
//  IMBPurchaseOrAnnoyController.h
//  AllFiles
//
//  Created by iMobie on 2018/4/19.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMBHoverChangeImageBtn,IMBWhiteView;

@interface IMBPurchaseOrAnnoyController : NSViewController
{
    IBOutlet IMBHoverChangeImageBtn *_closeWindowBtn;
    IBOutlet IMBWhiteView *_whiteView;
}

@property(nonatomic, assign)IMBWhiteView *whiteView;
@property(nonatomic, copy)void(^closeClicked)(void);

+ (instancetype)annoyWithToMacLeftNum:(NSInteger)toMacLeftNum toDeviceLeftNum:(NSInteger)toDeviceLeftNum toCloudLeftNum:(NSInteger)toCloudLeftNum;
+ (instancetype)purchase;

@end
