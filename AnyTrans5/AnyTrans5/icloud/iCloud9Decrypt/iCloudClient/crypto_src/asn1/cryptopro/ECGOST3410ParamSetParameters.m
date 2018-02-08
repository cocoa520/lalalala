//
//  ECGOST3410ParamSetParameters.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ECGOST3410ParamSetParameters.h"
#import "DERSequence.h"

@implementation ECGOST3410ParamSetParameters
@synthesize p = _p;
@synthesize q = _q;
@synthesize a = _a;
@synthesize b = _b;
@synthesize x = _x;
@synthesize y = _y;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_p) {
        [_p release];
        _p = nil;
    }
    if (_q) {
        [_q release];
        _q = nil;
    }
    if (_a) {
        [_a release];
        _a = nil;
    }
    if (_b) {
        [_b release];
        _b = nil;
    }
    if (_x) {
        [_x release];
        _x = nil;
    }
    if (_y) {
        [_y release];
        _y = nil;
    }
    [super dealloc];
#endif
}

+ (ECGOST3410ParamSetParameters *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [ECGOST3410ParamSetParameters getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (ECGOST3410ParamSetParameters *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[ECGOST3410ParamSetParameters class]]) {
        return (ECGOST3410ParamSetParameters *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[ECGOST3410ParamSetParameters alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Invalid GOST3410Parameter: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramBigInteger3:(BigInteger *)paramBigInteger3 paramBigInteger4:(BigInteger *)paramBigInteger4 paramInt:(int)paramInt paramBigInteger5:(BigInteger *)paramBigInteger5
{
    if (self = [super init]) {
        ASN1Integer *a = [[ASN1Integer alloc] initBI:paramBigInteger1];
        ASN1Integer *b = [[ASN1Integer alloc] initBI:paramBigInteger2];
        ASN1Integer *p = [[ASN1Integer alloc] initBI:paramBigInteger3];
        ASN1Integer *q = [[ASN1Integer alloc] initBI:paramBigInteger4];
        ASN1Integer *x = [[ASN1Integer alloc] initLong:paramInt];
        ASN1Integer *y = [[ASN1Integer alloc] initBI:paramBigInteger5];
        self.a = a;
        self.b = b;
        self.p = p;
        self.q = q;
        self.x = x;
        self.y = y;
#if !__has_feature(objc_arc)
    if (a) [a release]; a = nil;
    if (b) [b release]; b = nil;
    if (p) [p release]; p = nil;
    if (q) [q release]; q = nil;
    if (x) [x release]; x = nil;
    if (y) [y release]; y = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.a = (ASN1Integer *)[localEnumeration nextObject];
        self.b = (ASN1Integer *)[localEnumeration nextObject];
        self.p = (ASN1Integer *)[localEnumeration nextObject];
        self.q = (ASN1Integer *)[localEnumeration nextObject];
        self.x = (ASN1Integer *)[localEnumeration nextObject];
        self.y = (ASN1Integer *)[localEnumeration nextObject];
    }
    return self;
}

- (BigInteger *)getP {
    return self.p.getPositiveValue;
}

- (BigInteger *)getQ {
    return self.q.getPositiveValue;
}

- (BigInteger *)getA {
    return self.a.getPositiveValue;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.a];
    [localASN1EncodableVector add:self.b];
    [localASN1EncodableVector add:self.p];
    [localASN1EncodableVector add:self.q];
    [localASN1EncodableVector add:self.x];
    [localASN1EncodableVector add:self.y];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
