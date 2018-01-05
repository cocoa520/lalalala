//
//  IMBSelectBrowserImageView.h
//  iMobieTrans
//
//  Created by iMobie on 14-12-3.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBSelectBrowserImageView : NSImageView
{
    NSInteger _eventNumber;
    NSImageView *_backgroundView;
    BOOL _isSelected;
    NSTrackingArea *trackingArea;
}

@property(nonatomic,assign)NSImageView *backgroundView;
@property(nonatomic,assign)BOOL isSelected;

@end
