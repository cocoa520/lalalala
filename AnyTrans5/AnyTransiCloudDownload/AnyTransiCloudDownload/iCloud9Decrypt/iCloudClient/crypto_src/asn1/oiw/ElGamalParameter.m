//
//  ElGamalParameter.m
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ElGamalParameter.h"
#import "DERSequence.h"

@implementation ElGamalParameter
@synthesize p = _p;
@synthesize g = _g;

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
    [super dealloc];
#endif
}

+ (ElGamalParameter *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ElGamalParameter class]]) {
        return (ElGamalParameter *)paramObject;
    }
    if (paramObject) {
        return [[[ElGamalParameter alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2
{
    if (self = [super init]) {
        ASN1Integer *pInteger = [[ASN1Integer alloc] initBI:paramBigInteger1];
        ASN1Integer *gInteger = [[ASN1Integer alloc] initBI:paramBigInteger2];
        self.p = pInteger;
        self.g = gInteger;
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

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.p = ((ASN1Integer *)[localEnumeration nextObject]);
        self.g = ((ASN1Integer *)[localEnumeration nextObject]);
    }
    return self;
}

- (BigInteger *)getP {
    return self.p.getPositiveValue;
}

- (BigInteger *)getG {
    return self.g.getPositiveValue;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.p];
    [localASN1EncodableVector add:self.g];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
