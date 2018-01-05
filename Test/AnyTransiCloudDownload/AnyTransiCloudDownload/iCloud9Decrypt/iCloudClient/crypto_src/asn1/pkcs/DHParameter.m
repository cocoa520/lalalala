//
//  DHParameter.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DHParameter.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@implementation DHParameter
@synthesize p = _p;
@synthesize g = _g;
@synthesize l = _l;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_p) {
        [_p release];
        _p = nil;
    }
    if (_g) {
        [_g release];
        _g = nil;
    }
    if (_l) {
        [_l release];
        _l = nil;
    }
    [super dealloc];
#endif
}

+ (DHParameter *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DHParameter class]]) {
        return (DHParameter *)paramObject;
    }
    if (paramObject) {
        return [[[DHParameter alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.p = [ASN1Integer getInstance:[localEnumeration nextObject]];
        self.g = [ASN1Integer getInstance:[localEnumeration nextObject]];
        ASN1Integer *integer = nil;
        if (integer = [localEnumeration nextObject]) {
            self.l = integer;
        }else {
            self.l = nil;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramInt:(int)paramInt
{
    if (self = [super init]) {
        ASN1Integer *pInteger = [[ASN1Integer alloc] initBI:paramBigInteger1];
        ASN1Integer *gInteger = [[ASN1Integer alloc] initBI:paramBigInteger2];
        self.p = pInteger;
        self.g = gInteger;
        if (paramInt) {
            ASN1Integer *lInteger = [[ASN1Integer alloc] initLong:paramInt];
            self.l = lInteger;
#if !__has_feature(objc_arc)
            if (lInteger) [lInteger release]; lInteger = nil;
#endif
        }else {
            self.l = nil;
        }
#if !__has_feature(objc_arc)
    if (pInteger) [pInteger release]; pInteger = nil;
    if (gInteger) [gInteger release]; gInteger = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BigInteger *)getP {
    return self.p.getPositiveValue;
}

- (BigInteger *)getG {
    return self.g.getPositiveValue;
}

- (BigInteger *)getL {
    return self.l.getPositiveValue;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.p];
    [localASN1EncodableVector add:self.g];
    if ([self getL]) {
        [localASN1EncodableVector add:self.l];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
