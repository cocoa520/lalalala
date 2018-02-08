//
//  DomainParameters.m
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DomainParameters.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface DomainParameters ()

@property (nonatomic, readwrite, retain) ASN1Integer *p;
@property (nonatomic, readwrite, retain) ASN1Integer *g;
@property (nonatomic, readwrite, retain) ASN1Integer *q;
@property (nonatomic, readwrite, retain) ASN1Integer *j;
@property (nonatomic, readwrite, retain) ValidationParams *validationParams;

@end

@implementation DomainParameters
@synthesize p = _p;
@synthesize g = _g;
@synthesize q = _q;
@synthesize j = _j;
@synthesize validationParams = _validationParams;

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
    if (_q) {
        [_q release];
        _q = nil;
    }
    if (_j) {
        [_j release];
        _j = nil;
    }
    if (_validationParams) {
        [_validationParams release];
        _validationParams = nil;
    }
    [super dealloc];
#endif
}

+ (DomainParameters *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DomainParameters getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (DomainParameters *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DomainParameters class]]) {
        return (DomainParameters *)paramObject;
    }
    if (paramObject) {
        return [[[DomainParameters alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (ASN1Encodable *)getNext:(NSEnumerator *)paramEnumeration {
    ASN1Encodable *encodable = nil;
    return (encodable = [paramEnumeration nextObject]) ? encodable : nil;
}

- (instancetype)initParamBitInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramBigInteger3:(BigInteger *)paramBigInteger3 paramBigInteger4:(BigInteger *)paramBigInteger4 paramValidationParams:(ValidationParams *)paramValidationParams
{
    if (self = [super init]) {
        if (!paramBigInteger1) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'p' cannot be null" userInfo:nil];
        }
        if (!paramBigInteger2) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'g' cannot be null" userInfo:nil];
        }
        if (!paramBigInteger3) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'q' cannot be null" userInfo:nil];
        }
        ASN1Integer *pInteger = [[ASN1Integer alloc] initBI:paramBigInteger1];
        ASN1Integer *gInteger = [[ASN1Integer alloc] initBI:paramBigInteger2];
        ASN1Integer *qInteger = [[ASN1Integer alloc] initBI:paramBigInteger3];
        self.p = pInteger;
        self.g = gInteger;
        self.q = qInteger;
        if (paramBigInteger4) {
            ASN1Integer *jInteger = [[ASN1Integer alloc] initBI:paramBigInteger4];
            self.j = jInteger;
#if !__has_feature(objc_arc)
            if (jInteger) [jInteger release]; jInteger = nil;
#endif
        }else {
            self.j = nil;
        }
        self.validationParams = paramValidationParams;
#if !__has_feature(objc_arc)
    if (pInteger) [pInteger release]; pInteger = nil;
    if (gInteger) [gInteger release]; gInteger = nil;
    if (qInteger) [qInteger release]; qInteger = nil;
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
    if (self = [super init]) {
        if ([paramASN1Sequence size] < 3 || [paramASN1Sequence size] > 5) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Bad sequence size: %d", paramASN1Sequence.size] userInfo:nil];
        }
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.p = [ASN1Integer getInstance:localEnumeration.nextObject];
        self.g = [ASN1Integer getInstance:localEnumeration.nextObject];
        self.q = [ASN1Integer getInstance:localEnumeration.nextObject];
        ASN1Encodable *localASN1Encodable = [DomainParameters getNext:localEnumeration];
        if (localASN1Encodable && [localASN1Encodable isKindOfClass:[ASN1Integer class]]) {
            self.j = [ASN1Integer getInstance:localASN1Encodable];
            localASN1Encodable = [DomainParameters getNext:localEnumeration];
        }else {
            self.j = nil;
        }
        if (localASN1Encodable) {
            self.validationParams = [ValidationParams getInstance:localASN1Encodable.toASN1Primitive];
        }else {
            self.validationParams = nil;
        }
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

- (BigInteger *)getQ {
    return self.q.getPositiveValue;
}

- (BigInteger *)getJ {
    if (!self.j) {
        return nil;
    }
    return self.j.getPositiveValue;
}

- (ValidationParams *)getValidationParams {
    return self.validationParams;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.p];
    [localASN1EncodableVector add:self.g];
    [localASN1EncodableVector add:self.q];
    if (self.j) {
        [localASN1EncodableVector add:self.j];
    }
    if (self.validationParams) {
        [localASN1EncodableVector add:self.validationParams];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
