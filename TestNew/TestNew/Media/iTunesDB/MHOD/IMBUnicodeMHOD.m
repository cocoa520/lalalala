//
//  IMBUnicodeMHOD.m
//  MediaTrans
//
//  Created by Pallas on 12/17/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBUnicodeMHOD.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation IMBUnicodeMHOD
@synthesize position = _position;

#pragma mark - 初始化和释放方法
-(id)init{
    self = [super init];
    if (self) {
        _position = 1;
        _dataSize = 0;
        _data = @"";
        _unk3 = 1;
    }
    return self;
}

-(id)initWithType:(int)type{
    self = [self init];
    if (self) {
        _type = type;
    }
    return self;
}

-(void)dealloc{
    free(_unk5);
    [super dealloc];
}

#pragma mark - 重写方法
- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    iPod = ipod;
    int readLength = 0;
    readLength = sizeof(_position);
    [reader getBytes:&_position range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_dataSize);
    [reader getBytes:&_dataSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk3);
    [reader getBytes:&_unk3 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk4);
    [reader getBytes:&_unk4 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = _dataSize;
    Byte *byteData = (Byte*)malloc(_dataSize + 1);
    memset(byteData, 0, malloc_size(byteData));
    [reader getBytes:byteData range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    _data = [[NSString stringWithFormat:@"%S", (const unsigned short *)byteData] retain];
    free(byteData);
    
    int extraDataLength = _sectionSize - (_dataSize + _headerSize + 16);
    unk5Length = extraDataLength;
    if (extraDataLength > 0) {
        readLength = extraDataLength;
        _unk5 = (Byte*)malloc(readLength + 1);
        memset(_unk5, 0, malloc_size(_unk5));
        [reader getBytes:_unk5 range:NSMakeRange(currPosition, readLength)];
        currPosition += readLength;
    } else {
        _unk5 = (Byte*)malloc(1);
        memset(_unk5, 0, malloc_size(_unk5));
    }
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    [super write:writer]; 
    
    NSData *dataBytes = nil;
    if (_data != nil) {
        dataBytes = [_data dataUsingEncoding:NSUnicodeStringEncoding];
    }
    [writer appendBytes:&_position length:sizeof(_position)];
    int dataBytesLength = (int)[dataBytes length] - 2;
    [writer appendBytes:&dataBytesLength length:sizeof(dataBytesLength)];
    [writer appendBytes:&_unk3 length:sizeof(_unk3)];
    [writer appendBytes:&_unk4 length:sizeof(_unk4)];
    
    //[writer appendData:dataBytes];
    [writer appendBytes:&[dataBytes bytes][2] length:dataBytesLength];
    if (_unk5 != nil) {
        [writer appendBytes:_unk5 length:unk5Length];
    } else {
        _unk5 = (Byte*)malloc(1);
        memset(_unk5, 0, malloc_size(_unk5));
    }
}

-(int)getSectionSize{
    int size = _headerSize;
    if (_data != nil) {
        size += (int)[[_data dataUsingEncoding:NSUnicodeStringEncoding] length] - 2;
    }
    size += 16;
    
    if (_unk5 != nil) {
        size += unk5Length;
    }
    
    if (size != _sectionSize) {
    }
    return size;
}


@end
