//
//  ConstructedOctetStream.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ConstructedOctetStream.h"
#import "ASN1OctetStringParser.h"

@interface ConstructedOctetStream ()

@property (nonatomic, readwrite, retain) ASN1StreamParser *parser;
@property (nonatomic, assign) BOOL first;
@property (nonatomic, readwrite, retain) Stream *currentStream;

@end

@implementation ConstructedOctetStream
@synthesize parser = _parser;
@synthesize first = _first;
@synthesize currentStream = _currentStream;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_parser) {
        [_parser release];
        _parser = nil;
    }
    if (_currentStream) {
        [_currentStream release];
        _currentStream = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamASN1StreamParser:(ASN1StreamParser *)paramASN1StreamParser
{
    if (self = [super init]) {
        self.parser = paramASN1StreamParser;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (int)readParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2 {
    if (!self.currentStream) {
        if (!self.first) {
            return -1;
        }
        ASN1OctetStringParser *localASN1OctetStringParser1 = (ASN1OctetStringParser *)[self.parser readObject];
        if (!localASN1OctetStringParser1) {
            return -1;
        }
        self.first = false;
        self.currentStream = [localASN1OctetStringParser1 getOctetStream];
    }
    int i = 0;
    for (; ;) {
        int j = (int)[self.currentStream read:paramArrayOfByte withOff:paramInt1 + i withLen:paramInt2 - i];
        if (j >= 0) {
            i += j;
            if (i == paramInt2) {
                return i;
            }
        }else {
            ASN1OctetStringParser *localASN1OctetStringParser2 = (ASN1OctetStringParser *)[self.parser readObject];
            if (!localASN1OctetStringParser2) {
                self.currentStream = nil;
                return i < 1 ? -1 : i;
            }
            self.currentStream = [localASN1OctetStringParser2 getOctetStream];
        }
    }
}

- (int)read {
    ASN1OctetStringParser *localASN1OctetStringParser1;
    if (!self.currentStream) {
        if (!self.first) {
            return -1;
        }
        localASN1OctetStringParser1 = (ASN1OctetStringParser *)[self.parser readObject];
        if (!localASN1OctetStringParser1) {
            return -1;
        }
        self.first = NO;
    }
    ASN1OctetStringParser *localASN1OctetStringParser2;
    for ((self.currentStream = [localASN1OctetStringParser1 getOctetStream]); ; (self.currentStream = [localASN1OctetStringParser2 getOctetStream])) {
        int i = [self.currentStream read];
        if (i >= 0) {
            return i;
        }
        localASN1OctetStringParser2 = (ASN1OctetStringParser *)[self.parser readObject];
        if (!localASN1OctetStringParser2) {
            self.currentStream = nil;
            return -1;
        }
    }
}

@end
