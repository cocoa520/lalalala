//
//  DHDomainParameters.m
//  crypto
//
//  Created by JGehry on 5/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DHDomainParameters.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface DHDomainParameters ()

@property (nonatomic, readwrite, retain) ASN1Integer *p;
@property (nonatomic, readwrite, retain) ASN1Integer *g;
@property (nonatomic, readwrite, retain) ASN1Integer *q;
@property (nonatomic, readwrite, retain) ASN1Integer *j;
@property (nonatomic, readwrite, retain) DHValidationParms *validationParms;

@end

@implementation DHDomainParameters
@synthesize p = _p;
@synthesize g = _g;
@synthesize q = _q;
@synthesize j = _j;
@synthesize validationParms = _validationParms;

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
    if (_validationParms) {
        [_validationParms release];
        _validationParms = nil;
    }
    [super dealloc];
#endif
}

+ (DHDomainParameters *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DHDomainParameters getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (DHDomainParameters *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DHDomainParameters class]]) {
        return (DHDomainParameters *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[DHDomainParameters alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Invalid DHDomainParameters: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (ASN1Encodable *)getNext:(NSEnumerator *)paramEnumeration {
    ASN1Encodable *encodable = nil;
    return (encodable = [paramEnumeration nextObject]) ? encodable : nil;
}

- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramBigInteger3:(BigInteger *)paramBigInteger3 paramBigInteger4:(BigInteger *)paramBigInteger4 paramDHValidationParms:(DHValidationParms *)paramDHValidationParms
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
        ASN1Integer *jInteger = [[ASN1Integer alloc] initBI:paramBigInteger4];
        self.p = pInteger;
        self.g = gInteger;
        self.q = qInteger;
        self.j = jInteger;
        self.validationParms = paramDHValidationParms;
#if !__has_feature(objc_arc)
    if (pInteger) [pInteger release]; pInteger = nil;
    if (gInteger) [gInteger release]; gInteger = nil;
    if (qInteger) [qInteger release]; qInteger = nil;
    if (jInteger) [jInteger release]; jInteger = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Integer1:(ASN1Integer *)paramASN1Integer1 paramASN1Integer2:(ASN1Integer *)paramASN1Integer2 paramASN1Integer3:(ASN1Integer *)paramASN1Integer3 paramASN1Integer4:(ASN1Integer *)paramASN1Integer4 paramDHValidationParms:(DHValidationParms *)paramDHValidationParms
{
    if (self = [super init]) {
        if (!paramASN1Integer1) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'p' cannot be null" userInfo:nil];
        }
        if (!paramASN1Integer2) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'g' cannot be null" userInfo:nil];
        }
        if (!paramASN1Integer3) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'q' cannot be null" userInfo:nil];
        }
        self.p = paramASN1Integer1;
        self.g = paramASN1Integer2;
        self.q = paramASN1Integer3;
        self.j = paramASN1Integer4;
        self.validationParms = paramDHValidationParms;
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
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.p = [ASN1Integer getInstance:localEnumeration.nextObject];
        self.g = [ASN1Integer getInstance:localEnumeration.nextObject];
        self.q = [ASN1Integer getInstance:localEnumeration.nextObject];
        ASN1Encodable *localASN1Encodable = [DHDomainParameters getNext:localEnumeration];
        if (localASN1Encodable && [localASN1Encodable isKindOfClass:[ASN1Integer class]]) {
            self.j = [ASN1Integer getInstance:localASN1Encodable];
            localASN1Encodable = [DHDomainParameters getNext:localEnumeration];
        }
        if (localASN1Encodable) {
            self.validationParms = [DHValidationParms getInstance:[localASN1Encodable toASN1Primitive]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Integer *)getP {
    return self.p;
}

- (ASN1Integer *)getG {
    return self.g;
}

- (ASN1Integer *)getQ {
    return self.q;
}

- (ASN1Integer *)getJ {
    return self.j;
}

- (DHValidationParms *)getValidationParms {
    return self.validationParms;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.p];
    [localASN1EncodableVector add:self.q];
    [localASN1EncodableVector add:self.q];
    if (self.j) {
        [localASN1EncodableVector add:self.j];
    }
    if (self.validationParms) {
        [localASN1EncodableVector add:self.validationParms];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
