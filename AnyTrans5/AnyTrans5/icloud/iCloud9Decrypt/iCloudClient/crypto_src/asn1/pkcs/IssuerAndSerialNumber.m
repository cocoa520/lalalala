//
//  IssuerAndSerialNumber.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "IssuerAndSerialNumber.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@implementation IssuerAndSerialNumber
@synthesize name = _name;
@synthesize certSerialNumber = _certSerialNumber;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_name) {
        [_name release];
        _name = nil;
    }
    if (_certSerialNumber) {
        [_certSerialNumber release];
        _certSerialNumber = nil;
    }
    [super dealloc];
#endif
}

+ (IssuerAndSerialNumber *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[IssuerAndSerialNumber class]]) {
        return (IssuerAndSerialNumber *)paramObject;
    }
    if (paramObject) {
        return [[[IssuerAndSerialNumber alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.name = [X500Name getInstance:[paramASN1Sequence getObjectAt:0]];
        self.certSerialNumber = (ASN1Integer *)[paramASN1Sequence getObjectAt:1];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamX509Name:(X509Name *)paramX509Name paramBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        self.name = [X500Name getInstance:[paramX509Name toASN1Primitive]];
        ASN1Integer *integer = [[ASN1Integer alloc] initBI:paramBigInteger];
        self.certSerialNumber = integer;
#if !__has_feature(objc_arc)
    if (integer) [integer release]; integer = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamX509Name:(X509Name *)paramX509Name paramASN1Integer:(ASN1Integer *)paramASN1Integer
{
    if (self = [super init]) {
        self.name = [X500Name getInstance:[paramX509Name toASN1Primitive]];
        self.certSerialNumber = paramASN1Integer;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamX500Name:(X500Name *)paramX500Name paramBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        self.name = paramX500Name;
        ASN1Integer *integer = [[ASN1Integer alloc] initBI:paramBigInteger];
        self.certSerialNumber = integer;
#if !__has_feature(objc_arc)
    if (integer) [integer release]; integer = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (X500Name *)getName {
    return self.name;
}

- (ASN1Integer *)getCertificateSerialNumber {
    return self.certSerialNumber;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.name];
    [localASN1EncodableVector add:self.certSerialNumber];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
