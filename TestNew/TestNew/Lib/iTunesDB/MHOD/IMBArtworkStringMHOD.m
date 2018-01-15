//
//  IMBArtworkStringMHOD.m
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBArtworkStringMHOD.h"

@implementation IMBArtworkStringMHOD

- (id)init {
    self = [super init];
    if (self) {
        _requiredHeaderSize = 24;
        _headerSize = 24;
        _type = ALBUM;
        _stringType = Unicode;
    }
    return self;
}

- (void)dealloc {
    free(_identifier);
    if (_data != nil) {
        [_data release];
        _data = nil;
    }
    [super dealloc];
}

- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    long startOfElement = currPosition;
    
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
    readLength = sizeof(uint16);
    [reader getBytes:&_type range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk1x);
    [reader getBytes:&_unk1x range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk2);
    [reader getBytes:&_unk2 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_padding);
    [reader getBytes:&_padding range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    int dataLength = 0;
    readLength = sizeof(dataLength);
    [reader getBytes:&dataLength range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_stringType);
    [reader getBytes:&_stringType range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk3);
    [reader getBytes:&_unk3 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = dataLength;
    Byte *bytes = malloc(readLength + 1);
    memset(bytes, 0, malloc_size(bytes));
    [reader getBytes:bytes range:NSMakeRange(currPosition, readLength)];
    _data = [[NSString stringWithFormat:@"%S", (const unsigned short *)bytes] retain];
    //_data = [[NSString alloc] initWithBytes:bytes length:dataLength encoding:[self stringEncoding]];
    currPosition += readLength;
    free(bytes);
    
    //Jump over padding section
    _actualPadding = (int)((startOfElement + _sectionSize) - currPosition);
    if (_actualPadding != 0) {
        currPosition = startOfElement + _sectionSize;
    }
    return currPosition;
}




- (void)write:(NSMutableData *)writer {
    _sectionSize = [self getSectionSize];
    
    NSData *byteData = [_data dataUsingEncoding:[self stringEncoding]];
    int dataLength = (int)[byteData length] - 2;
    
    identifierLength = 4;
    _identifier = (char*)malloc(5);
    memset(_identifier, 0, malloc_size(_identifier));
    memcpy(_identifier, "mhod", 4);
    [writer appendBytes:_identifier length:identifierLength];
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    uint16 typeuint16 = (uint16)_type;
    [writer appendBytes:&typeuint16 length:sizeof(typeuint16)];
    uint16 unk1xuint16 = (uint16)_unk1x;
    [writer appendBytes:&unk1xuint16 length:sizeof(unk1xuint16)];
    [writer appendBytes:&_unk2 length:sizeof(_unk2)];
    [writer appendBytes:&_padding length:sizeof(_padding)];
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    [writer appendBytes:&dataLength length:sizeof(dataLength)];
    int stringTypeInt = (int)_stringType;
    [writer appendBytes:&stringTypeInt length:sizeof(stringTypeInt)];
    [writer appendBytes:&_unk3 length:sizeof(_unk3)];
    //[writer appendData:byteData];
    [writer appendBytes:&[byteData bytes][2] length:dataLength];
    //Jump over padding section
    if (_actualPadding > 0) {
        Byte *emptyByte = malloc(_actualPadding + 1);
        memset(emptyByte, 0, malloc_size(emptyByte));
        [writer appendBytes:emptyByte length:_actualPadding];
    }
}

- (int)getSectionSize {
    NSData *byteData = [_data dataUsingEncoding:[self stringEncoding]];
    int dataLength = (int)[byteData length] - 2;
    return _headerSize + 12 + dataLength + _actualPadding;
}

- (void)setData:(NSString *)data {
    if ([data hasPrefix:@":"] == NO) {
        _data = [@":" stringByAppendingString:data];
    } else {
        _data = data;
    }
    [_data retain];
}

- (NSString*)data {
    return _data;
}

- (void)create:(NSString*)data {
    unusedHeaderLength = _headerSize - _requiredHeaderSize;
    _unusedHeader = malloc(unusedHeaderLength + 1);
    memset(_unusedHeader, 0, malloc_size(_unusedHeader));
    [self setData:data];
}

- (NSStringEncoding)stringEncoding {
    if (_stringType == Unicode) {
        return NSUnicodeStringEncoding;
    } else if (_stringType == Ascii) {
        return NSASCIIStringEncoding;
    } else {
        return NSUTF8StringEncoding;
    }
}

@end
