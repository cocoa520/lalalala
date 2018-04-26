//
//  IMBDevViewController.h
//  iOSFiles
//
//  Created by iMobie on 18/1/25.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

APPKIT_EXTERN CGFloat const IMBDevViewControllerRowH;

@interface IMBDevViewController : NSViewController
{
@private
    NSMutableArray *_devices;
    CGFloat _iconX;
    CGFloat _textX;
}

@property(nonatomic, assign)CGFloat iconX;
@property(nonatomic, assign)CGFloat textX;
@property(retain, nonatomic)NSMutableArray *devices;

@end