//
//  IMBBaseViewController.h
//  iOSFiles
//
//  Created by 龙凡 on 2018/2/26.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMBiPod,IMBInformation;

@interface IMBBaseViewController : NSViewController
{
    IMBiPod *_iPod;
}

@property(nonatomic, retain)IMBiPod *iPod;

- (void)refresh:(IMBInformation *)information;
- (void)toMac:(IMBInformation *)information;
- (void)addToDevice:(IMBInformation *)information;
- (void)deleteItem:(IMBInformation *)information;
- (void)toDevice:(IMBInformation *)information;

@end
