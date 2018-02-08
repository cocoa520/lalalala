//
//  X9ECPoint.m
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X9ECPoint.h"
#import "Arrays.h"
#import "DEROctetString.h"

@interface X9ECPoint ()

@property (nonatomic, readwrite, retain) ASN1OctetString *encoding;
@property (nonatomic, readwrite, retain) ECCurve *c;
@property (nonatomic, readwrite, retain) ECPoint *p;

@end

@implementation X9ECPoint
@synthesize encoding = _encoding;
@synthesize c = _c;
@synthesize p = _p;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_encoding) {
        [_encoding release];
        _encoding = nil;
    }
    if (_c) {
        [_c release];
        _c = nil;
    }
    if (_p) {
        [_p release];
        _p = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamECPoint:(ECPoint *)paramECPoint
{
    if (self = [super init]) {
        [self initParamECPoint:paramECPoint paramBoolean:NO];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamECPoint:(ECPoint *)paramECPoint paramBoolean:(BOOL)paramBoolean
{
    if (self = [super init]) {
        self.p = [paramECPoint normalize];
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:[paramECPoint getEncodedWithCompressed:paramBoolean]];
        self.encoding = octetString;
#if !__has_feature(objc_arc)
        if (octetString) [octetString release]; octetString = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamECCurve:(ECCurve *)paramECCurve paramArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.c = paramECCurve;
        NSMutableData *tmpData = [Arrays cloneWithByteArray:paramArrayOfByte];
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:tmpData];
        self.encoding = octetString;
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
        if (octetString) [octetString release]; octetString = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamECCurve:(ECCurve *)paramECCurve paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        [self initParamECCurve:paramECCurve paramArrayOfByte:[paramASN1OctetString getOctets]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (NSMutableData *)getPointEncoding {
    return [[Arrays cloneWithByteArray:[self.encoding getOctets]] autorelease];
}

- (ECPoint *)getPoint {
    if (!self.p) {
        self.p = [[self.c decodePoint:[self.encoding getOctets]] normalize];
    }
    return self.p;
}

- (BOOL)isPointCompressed {
    NSMutableData *arrayOfByte = [self.encoding getOctets];
    return ((arrayOfByte) && (arrayOfByte.length > 0) && ((((Byte *)([arrayOfByte bytes]))[0] == 2) || (((Byte *)([arrayOfByte bytes]))[0] == 3)));
}

- (ASN1Primitive *)toASN1Primitive {
    return self.encoding;
}

@end
