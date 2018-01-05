//
//  BEROctetStringGenerator.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BEROctetStringGenerator.h"
#import "Mac.h"

@implementation BEROctetStringGenerator

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream
{
    if (self = [super initParamOutputStream:paramOutputStream]) {
        [self writeBERHeader:36];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream paramInt:(int)paramInt paramBoolean:(BOOL)paramBoolean
{
    if (self = [super initParamOutputStream:paramOutputStream paramInt:paramInt paramBoolean:paramBoolean]) {
        [self writeBERHeader:36];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (Stream *)getOctetOutputStream {
    NSMutableData *mutData = [[NSMutableData alloc] initWithSize:8];
    Stream *stream = [self getOctetOutputStream:mutData];
#if !__has_feature(objc_arc)
    if (mutData) [mutData release]; mutData = nil;
#endif
    return stream;
}

- (Stream *)getOctetOutputStream:(NSMutableData *)paramArrayOfByte {
    return [[[BufferedBEROctetStream alloc] initParamArrayOfByte:paramArrayOfByte] autorelease];
}

@end

#import "DEROctetString.h"

@interface BufferedBEROctetStream ()

@property (nonatomic, readwrite, retain) NSMutableData *buf;
@property (nonatomic, assign) int off;
@property (nonatomic, readwrite, retain) DEROutputStream *derOut;

@end

@implementation BufferedBEROctetStream
@synthesize buf = _buf;
@synthesize off = _off;
@synthesize derOut = _derOut;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_buf) {
        [_buf release];
        _buf = nil;
    }
    if (_derOut) {
        [_derOut release];
        _derOut = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.buf = paramArrayOfByte;
        self.off = 0;
        DEROutputStream *derOutStream = [[DEROutputStream alloc] initDERParamOutputStream:[((BEROctetStringGenerator *)self) oUT]];
        self.derOut = derOutStream;
#if !__has_feature(objc_arc)
    if (derOutStream) [derOutStream release]; derOutStream = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)write:(int)paramInt {
    ((Byte *)[self.buf bytes])[self.off++] = (Byte)paramInt;
    if (self.off == [self.buf length]) {
        [DEROctetString encode:self.derOut paramArrayOfByte:self.buf];
        self.off = 0;
    }
}

- (void)write:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2 {
    while (paramInt2 > 0) {
        int i = (int)MIN(paramInt2, ([self.buf length] - self.off));
        self.off += i;
        if (self.off < [self.buf length]) {
            break;
        }
        [DEROctetString encode:self.derOut paramArrayOfByte:self.buf];
        self.off = 0;
        paramInt1 += i;
        paramInt2 -= i;
    }
}

- (void)close {
    if (self.off) {
        NSMutableData *arrayOfByte = [[NSMutableData alloc] initWithSize:self.off];
        arrayOfByte = [self.buf mutableCopy];
        [DEROctetString encode:self.derOut paramArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
    if (arrayOfByte) [arrayOfByte release]; arrayOfByte = nil;
#endif
    }
    [((BEROctetStringGenerator *)self) writeBEREnd];
}

@end