//
//  IMBMenuIndexMHOD.m
//  MediaTrans
//
//  Created by Pallas on 12/17/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBMenuIndexMHOD.h"

@implementation IMBMenuIndexMHOD
@synthesize indexType = _indexType;

-(id)init{
    self = [super init];
    if (self) {
        _type = MENUINDEXTABLE;
        _padding = (Byte*)malloc(40 + 1);
        memset(_padding, 0, malloc_size(_padding));
    }
    return self;
}

-(id)initWithIndexType:(MenuIndexTypeEnum)indexType{
    self = [self init];
    if (self) {
        _indexType = (int)indexType;
    }
    return self;
}

-(void)dealloc{
    free(_padding);
    [super dealloc];
}

- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    iPod = ipod;
    int readLength = 0;
    readLength = sizeof(_indexType);
    [reader getBytes:&_indexType range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    int nbrEntries;
    readLength = sizeof(nbrEntries);
    [reader getBytes:&nbrEntries range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = 40;
    paddingLength = readLength;
    [reader getBytes:_padding range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    _indexes = [[NSMutableArray alloc] init];
    
    int tempInt;
    NSNumber *number;
    for (int i = 0; i < nbrEntries; i++) {
        readLength = sizeof(tempInt);
        [reader getBytes:&tempInt range:NSMakeRange(currPosition, readLength)];
        currPosition += readLength;
        number = [[NSNumber alloc] initWithInt:tempInt];
        [_indexes addObject:number];
        [number release];
        number = nil;
    }
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    [super write:writer];
    
    [writer appendBytes:&_indexType length:sizeof(_indexType)];
    int indexCount = (int)[_indexes count];
    [writer appendBytes:&indexCount length:sizeof(indexCount)];
    
    [writer appendBytes:_padding length:paddingLength];
    
    int tempInt;
    for (NSNumber *item in _indexes) {
        tempInt = [item intValue];
        [writer appendBytes:&tempInt length:sizeof(tempInt)];
    }
    
}

-(int)getSectionSize{
    return (int)(_headerSize + 48 + [_indexes count] * 4);
}

@end
