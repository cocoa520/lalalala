//
//  IMBTransferModel.m
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/20.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBTransferModel.h"
#import "IMBCommonDefine.h"
@implementation IMBTransferModel
@synthesize image = _image;
@synthesize fileName = _fileName;
@synthesize destination = _estination;
@synthesize size = _size;
@synthesize progressView = _progressView;
@synthesize sizeStr = _sizeStr;
@synthesize progress = _progress;
@synthesize uniqueKey = _uniqueKey;
@synthesize dataAry = _dataAry;
@synthesize count = _count;
-(instancetype)init {
    if ([super init]) {
        _progressView = [[ProgressView alloc]initWithFrame:NSMakeRect(0, 0, 188, 6)];
        [_progressView setLeftFillColor:PROGRESS_ANIMATION_COLOR];
        [_progressView setRightFillColor:PROGRESS_ANIMATION_COLOR];
//        [_progressView setFillimage:[StringHelper imageNamed:@"download_process_bg"]];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    [_progressView release];
    _progressView = nil;
}
@end
