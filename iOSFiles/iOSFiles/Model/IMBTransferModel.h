//
//  IMBTransferModel.h
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/20.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProgressView.h"
#import "IMBiPod.h"
@interface IMBTransferModel : NSObject
{
    NSImage *_image;
    NSString *_fileName;
    NSString *_destination;
    ProgressView *_progressView;
    NSString *_sizeStr;
    long long _size;
    double _progress;
    NSString *_uniqueKey;
    NSMutableArray *_dataAry;
    int _count;
}
@property (nonatomic,assign) int count;
@property (nonatomic,assign) ProgressView *progressView;
@property (nonatomic,assign) NSImage *image;
@property (nonatomic,retain) NSString *sizeStr;
@property (nonatomic,retain) NSString *fileName;
@property (nonatomic,retain) NSString *destination;
@property (nonatomic,assign) long long size;
@property (nonatomic,assign) double progress;
@property (nonatomic,retain) NSString *uniqueKey;
@property (nonatomic,retain) NSMutableArray *dataAry;
@end
