//
//  IMBBaseMHODElement.m
//  MediaTrans
//
//  Created by Pallas on 12/11/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBBaseMHODElement.h"

@implementation IMBBaseMHODElement
@synthesize unk1 = _unk1;
@synthesize unk2 = _unk2;
@synthesize type = _type;

-(id)init {
    self = [super init];
    if (self) {
        _requiredHeaderSize = 24;
        _headerSize = 24;
        _type = ID;
    }
    return self;
}

-(id)initWithElementType:(int)type{
    self = [self init];
    if (self) {
        identifierLength = 4;
//        _identifier = (char*)malloc(identifierLength + 1);
//        memset(_identifier, 0, malloc_size(_identifier));
//        memcpy(_identifier, "mhod", 4);
        _type = type;
    }
    return self;
}

-(void)dealloc{
    //TODO Crash
    /*
     Child with pid 15829 exited normally
     iMobieTrans(15822,0xb0081000) malloc: *** error for object 0x1319e8: pointer being freed was not allocated
     *** set a breakpoint in malloc_error_break to debug
    */
    //free(_identifier) 出错
//    if (_identifier != nil) {
//        //free(_identifier);
//    }
    [super dealloc];
}

- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    iPod = ipod;
    currPosition = [super read:iPod reader:reader currPosition:currPosition];
    
    int readLength = 0;
    readLength = 4;
    identifierLength = readLength;
    _identifier = (char*)malloc(readLength + 1);
    memset(_identifier, 0, malloc_size(_identifier));
    [reader getBytes:_identifier range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_headerSize);
    [reader getBytes:&_headerSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    [self validateHeader:@"mhod"];
    
    readLength = sizeof(_sectionSize);
    [reader getBytes:&_sectionSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_type);
    [reader getBytes:&_type range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk1);
    [reader getBytes:&_unk1 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk2);
    [reader getBytes:&_unk2 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    free(_identifier);
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    _sectionSize = [self getSectionSize];
    
    identifierLength = 4;
    _identifier = (char*)malloc(5);
    memset(_identifier, 0, malloc_size(_identifier));
    memcpy(_identifier, "mhod", 4);
    [writer appendBytes:_identifier length:identifierLength];
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    [writer appendBytes:&_type length:sizeof(_type)];
    [writer appendBytes:&_unk1 length:sizeof(_unk1)];
    [writer appendBytes:&_unk2 length:sizeof(_unk2)];
    
    free(_identifier);
}

- (int)getSectionSize
{
    return 0;
}

-(void)setHeader:(IMBBaseMHODElement *)header{
    _headerSize = [header headerSize];
    _sectionSize = [header sectionSize];
    _unk1 = [header unk1];
    _unk2 = [header unk2];
    _type = [header type];
}

@end
