//
//  DSAParameter.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DSAParameter.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@implementation DSAParameter
@synthesize p = _p;
@synthesize q = _q;
@synthesize g = _g;

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
    if (_g) {
        [_g release];
        _g = nil;
    }
    [super dealloc];
#endif
}

+ (DSAParameter *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DSAParameter class]]) {
        return (DSAParameter *)paramObject;
    }
    if (paramObject) {
        return [[[DSAParameter alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (DSAParameter *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DSAParameter getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 3) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.p = [ASN1Integer getInstance:[localEnumeration nextObject]];
        self.q = [ASN1Integer getInstance:[localEnumeration nextObject]];
        self.g = [ASN1Integer getInstance:[localEnumeration nextObject]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramBigInteger3:(BigInteger *)paramBigInteger3
{
    if (self = [super init]) {
        ASN1Integer *pInteger = [[ASN1Integer alloc] initBI:paramBigInteger1];
        ASN1Integer *qInteger = [[ASN1Integer alloc] initBI:paramBigInteger2];
        ASN1Integer *gInteger = [[ASN1Integer alloc] initBI:paramBigInteger3];
        self.p = pInteger;
        self.q = qInteger;
        self.g = gInteger;
#if !__has_feature(objc_arc)
    if (pInteger) [pInteger release]; pInteger = nil;
    if (qInteger) [qInteger release]; qInteger = nil;
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

- (BigInteger *)getQ {
    return self.q.getPositiveValue;
}

- (BigInteger *)getG {
    return self.g.getPositiveValue;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.p];
    [localASN1EncodableVector add:self.q];
    [localASN1EncodableVector add:self.g];
    ASN1Primitive *primitive =  [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
