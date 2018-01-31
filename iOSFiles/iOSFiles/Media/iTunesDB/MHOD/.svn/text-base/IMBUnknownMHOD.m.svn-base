//
//  IMBUnknownMHOD.m
//  MediaTrans
//
//  Created by Pallas on 12/17/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBUnknownMHOD.h"

@implementation IMBUnknownMHOD

#pragma mark - 初始化和释放方法
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)dealloc{
    free(_byteData);
    [super dealloc];
}

#pragma mark - 重写方法
- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    iPod = ipod;
    int readLength = 0;
    readLength = _sectionSize - _headerSize;
    byteDateLength = readLength;
    _byteData = (Byte*)malloc(readLength + 1);
    memset(_byteData, 0, malloc_size(_byteData));
    [reader getBytes:_byteData range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    [super write:writer];
    if (byteDateLength <= 0) {
        byteDateLength = 0;
        _byteData = malloc(1);
        memset(_byteData, 0, malloc_size(_byteData));
    }
    [writer appendBytes:_byteData length:byteDateLength];
}

-(int)getSectionSize{
    int size = _headerSize + byteDateLength;
    return size;
}

@end
