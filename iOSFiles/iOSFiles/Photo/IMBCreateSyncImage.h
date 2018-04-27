//
//  IMBCreateSyncImage.h
//  iMobieTrans
//
//  Created by iMobie on 7/11/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBLogManager.h"
#import "IMBiPod.h"
#import "IMBTrack.h"

@interface IMBCreateSyncImage : NSObject {
    int _thbumHeight;
    int _thbumWidth;
    
    long long _fileTatolSize;
    IMBLogManager *_logHandle;
    IMBiPod *_ipod;
    BOOL _isBetweenDevice;
}

@property (assign) long long fileTatolSize;

-(NSData *)writeImage:(IMBTrack *)tract withOldData:(NSData *)oldData;
-(id)initWithImage:(IMBiPod *)ipod;
-(NSMutableArray *)getThumbnilArray:(NSMutableArray *)uuidArray;
- (NSData *)createImageDataByTract:(IMBTrack *)tract withType:(BOOL)isBetweenDevice;
-(NSData *)createImageData:(IMBTrack *)tract;
-(NSData *)createThumb78_78Image:(NSData *)imgData;
-(NSData *)createThumb158_158Image:(NSData *)imgData;
-(NSData *)createThumb167_167Image:(NSData *)imgData;
-(NSData *)createThumb120_120Image:(NSData *)imgData;
-(NSData *)createThumb32_32Image:(NSData *)imgData;

@end
