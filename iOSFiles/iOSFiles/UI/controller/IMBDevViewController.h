//
//  IMBDevViewController.h
//  iOSFiles
//
//  Created by iMobie on 18/1/25.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IMBDevViewController : NSViewController
{
@private
    NSMutableArray *_devices;
    
}

@property(retain, nonatomic)NSMutableArray *devices;

@end