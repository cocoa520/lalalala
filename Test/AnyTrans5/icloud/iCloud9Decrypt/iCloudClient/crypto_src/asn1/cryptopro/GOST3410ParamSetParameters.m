//
//  GOST3410ParamSetParameters.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "GOST3410ParamSetParameters.h"
#import "DERSequence.h"

@implementation GOST3410ParamSetParameters
@synthesize keySize = _keySize;
@synthesize p = _p;
@synthesize q = _q;
@synthesize a = _a;

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
    [super dealloc];
#endif
}

+ (GOST3410ParamSetParameters *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [GOST3410ParamSetParameters getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (GOST3410ParamSetParameters *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[GOST3410ParamSetParameters class]]) {
        return (GOST3410ParamSetParameters *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[GOST3410ParamSetParameters alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Invalid GOST3410Parameter: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamInt:(int)paramInt paramBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramBigInteger3:(BigInteger *)paramBigInteger3
{
    self = [super init];
    if (self) {
        self.keySize = paramInt;
        ASN1Integer *p = [[ASN1Integer alloc] initBI:paramBigInteger1];
        ASN1Integer *q = [[ASN1Integer alloc] initBI:paramBigInteger2];
        ASN1Integer *a = [[ASN1Integer alloc] initBI:paramBigInteger3];
        self.p = p;
        self.q = q;
        self.a = a;
#if !__has_feature(objc_arc)
    if (p) [p release]; p = nil;
    if (q) [q release]; q = nil;
    if (a) [a release]; a = nil;
#endif
    }
    return self;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.keySize = [[((ASN1Integer *)[localEnumeration nextObject]) getValue] intValue];
        self.p = (ASN1Integer *)[localEnumeration nextObject];
        self.q = (ASN1Integer *)[localEnumeration nextObject];
        self.a = (ASN1Integer *)[localEnumeration nextObject];
    }
    return self;
}

- (int)getLKeySize {
    return self.keySize;
}

- (int)getKeySize {
    return self.keySize;
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
    ASN1Encodable *encodable = [[ASN1Integer alloc] initLong:self.keySize];
    [localASN1EncodableVector add:encodable];
    [localASN1EncodableVector add:self.p];
    [localASN1EncodableVector add:self.q];
    [localASN1EncodableVector add:self.a];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
