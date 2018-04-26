//
//  IMBPlaylistPositionMHOD.m
//  MediaTrans
//
//  Created by Pallas on 12/17/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBPlaylistPositionMHOD.h"

@implementation IMBPlaylistPositionMHOD
@synthesize position = _position;

#pragma mark - 初始化和释放方法
-(id)init{
    self = [super init];
    if (self) {
        _type = PLAYLISTPOSITION;
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
    byteDataLength = 0;
    if (_sectionSize == _headerSize) {
    } else {
        readLength = sizeof(_position);
        [reader getBytes:&_position range:NSMakeRange(currPosition, readLength)];
        currPosition += readLength;
        readLength = _sectionSize - (_headerSize + 4);
        byteDataLength = readLength;
        if (_byteData != nil) {
            if (sizeof(_byteData) != readLength) {
                free(_byteData);
                _byteData = (Byte*)malloc(readLength + 1);
                memset(_byteData, 0, malloc_size(_byteData));
            }
        } else {
            _byteData = (Byte*)malloc(readLength + 1);
            memset(_byteData, 0, malloc_size(_byteData));
        }
        [reader getBytes:_byteData range:NSMakeRange(currPosition, readLength)];
        currPosition += readLength;
    }
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    if ([writer length] == 1192046) {
    }
    
    [super write:writer];
    [writer appendBytes:&_position length:sizeof(_position)];
    if (_byteData != nil) {
        [writer appendBytes:_byteData length:byteDataLength];
    }
}

-(int)getSectionSize{
    int size = _headerSize + 4;
    if (_byteData != nil) {
        size += byteDataLength;
    }
return size;
}

#pragma mark - 实现声明方法
-(void)create{
    byteDataLength = 16;
    _byteData = (Byte*)malloc(16 + 1);
    memset(_byteData, 0, malloc_size(_byteData));
}

@end
