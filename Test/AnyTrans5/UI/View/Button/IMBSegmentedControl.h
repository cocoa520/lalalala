//
//  IMBSegmentedControl.h
//  PrimoMusic
//
//  Created by iMobie_Market on 16/4/13.
//  Copyright (c) 2016年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBSegmentedControl : NSSegmentedControl
{
    NSTrackingArea *_trackingArea;
    NSString *_firstTitle;
    NSString *_secondTitle;
}
@property (nonatomic, copy) NSString *firstTitle;
@property (nonatomic, copy) NSString *secondTitle;
@end
