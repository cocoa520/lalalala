//
//  IMBiCloudDownloadProgressView.m
//  PhoneRescue
//
//  Created by 肖体华 on 14-9-26.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBiCloudDownloadProgressView.h"
//#import "IMBCommonDefine.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
#define LINE 5

@implementation IMBiCloudDownloadProgressView
@synthesize totalSize = _totalSize;
@synthesize downloadedTotalSize = _downloadedTotalSize;
@synthesize isDownloadSucess = _isDownloadSucess;
@synthesize timer = _timer;
@synthesize isHigh = _isHigh;
- (id)init{
    if (self = [super init]) {
        [self setWantsLayer:YES];
        _downloadedTotalSize= 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:NOTIFY_ICLOUD_DOWNLOAD_PROGRESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshiOS9View:) name:NOTIFY_ICLOUD_IOS9DOWNLOAD_PROGRESS object:nil];

    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ICLOUD_DOWNLOAD_PROGRESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ICLOUD_IOS9DOWNLOAD_PROGRESS object:nil];
}

- (void)refreshiOS9View:(NSNotification *)n{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [n userInfo];
        long totalsize = [[dic valueForKey:@"totalSize"] longValue];
        long downloadsize = [[dic valueForKey:@"DownloadedTotalSize"] longValue];
        if (downloadsize > _downloadedTotalSize) {
            _downloadedTotalSize = downloadsize;
        }
        _totalSize = totalsize;
        //        //回调或者说是通知主线程刷新，
        [self setNeedsDisplay:YES];
    });
}

- (void)refreshView:(NSNotification *)n{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [n userInfo];
        long totalsize = [[dic valueForKey:@"totalSize"] longValue];
        long downloadsize = [[dic valueForKey:@"DownloadedTotalSize"] longValue];
        if (downloadsize > _downloadedTotalSize) {
            _downloadedTotalSize = downloadsize;
        }
        _totalSize = totalsize;
//        //回调或者说是通知主线程刷新，
        [self setNeedsDisplay:YES];
    });
}

- (void)drawRect:(NSRect)dirtyRect{
    [super drawRect:dirtyRect];
    [[NSColor clearColor] set];
    NSRectFill(dirtyRect);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    [path setWindingRule:NSEvenOddWindingRule];
    [path addClip];
    [[StringHelper getColorFromString:CustomColor(@"progress_bgColor", nil)] set];
    [path fill];
    
    NSBezierPath *progressPath = [NSBezierPath bezierPath];
        
    [progressPath moveToPoint:NSMakePoint(NSMinX(dirtyRect)+LINE, NSMaxY(dirtyRect))];
        
    [progressPath appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(dirtyRect) + LINE, NSMaxY(dirtyRect) - LINE) radius:LINE startAngle:90 endAngle:180];
        
    [progressPath lineToPoint:NSMakePoint(NSMinX(dirtyRect), NSMinY(dirtyRect)+LINE)];
        
    [progressPath appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(dirtyRect) + LINE, NSMinY(dirtyRect)+LINE) radius:LINE startAngle:180 endAngle:270];
        
    float progress = ((float)_downloadedTotalSize)/_totalSize;
    if (progress >= 1.0) {
        progress = 0.99;
    }
    if (progress == ((float)1)/_totalSize) {
        progress = 0.00;
    }

        
        float width = dirtyRect.size.width * progress;
        
        if (width == 0.00) {
            progressPath = nil;
        }else{
            [progressPath lineToPoint:NSMakePoint( NSMinX(dirtyRect) + width - LINE, NSMinY(dirtyRect))];
            
            [progressPath lineToPoint:NSMakePoint(NSMinX(dirtyRect) + width - LINE, NSMaxY(dirtyRect))];
            
            [path closePath];
        }
        
//        if (_isDownloadSucess) {
//            progressPath = path;
//        }
        [[StringHelper getColorFromString:CustomColor(@"icloud_download_progress_color", nil)] set];
        [progressPath fill];
}
@end
