//
//  IMBiCloudDownloadProgressView.h
//  PhoneRescue
//
//  Created by 肖体华 on 14-9-26.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBiCloudDownloadProgressView : NSView{
    NSArray *_dataArray;
    NSTextField *text;
    long _downloadedTotalSize;
    long long _totalSize;
    BOOL _isDownloadSucess;
    NSTimer *_timer;
    BOOL _isHigh;
}
@property (assign) long downloadedTotalSize;
@property (assign) long long totalSize;
@property (assign) BOOL isDownloadSucess;
@property (assign) BOOL isHigh;
@property (nonatomic, retain) NSTimer *timer;

@end
