//
//  RSAPrivateKey.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RSAPrivateKey.h"
#import "DERSequence.h"
#import "ASN1Integer.h"

@interface RSAPrivateKey ()

@property (nonatomic, readwrite, retain) BigInteger *version;
@property (nonatomic, readwrite, retain) BigInteger *modulus;
@property (nonatomic, readwrite, retain) BigInteger *publicExponent;
@property (nonatomic, readwrite, retain) BigInteger *privateExponent;
@property (nonatomic, readwrite, retain) BigInteger *prime1;
@property (nonatomic, readwrite, retain) BigInteger *prime2;
@property (nonatomic, readwrite, retain) BigInteger *exponent1;
@property (nonatomic, readwrite, retain) BigInteger *exponent2;
@property (nonatomic, readwrite, retain) BigInteger *coefficient;
@property (nonatomic, readwrite, retain) ASN1Sequence *otherPrimeInfos;

@end

@implementation RSAPrivateKey
@synthesize version = _version;
@synthesize modulus = _modulus;
@synthesize publicExponent = _publicExponent;
@synthesize privateExponent = _privateExponent;
@synthesize prime1 = _prime1;
@synthesize prime2 = _prime2;
@synthesize exponent1 = _exponent1;
@synthesize exponent2 = _exponent2;
@synthesize coefficient = _coefficient;
@synthesize otherPrimeInfos = _otherPrimeInfos;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_modulus) {
        [_modulus release];
        _modulus = nil;
    }
    if (_publicExponent) {
        [_publicExponent release];
        _publicExponent = nil;
    }
    if (_privateExponent) {
        [_privateExponent release];
        _privateExponent = nil;
    }
    if (_prime1) {
        [_prime1 release];
        _prime1 = nil;
    }
    if (_prime2) {
        [_prime2 release];
        _prime2 = nil;
    }
    if (_exponent1) {
        [_exponent1 release];
        _exponent1 = nil;
    }
    if (_exponent2) {
        [_exponent2 release];
        _exponent2 = nil;
    }
    if (_coefficient) {
        [_coefficient release];
        _coefficient = nil;
    }
    if (_otherPrimeInfos) {
        [_otherPrimeInfos release];
        _otherPrimeInfos = nil;
    }
    [super dealloc];
#endif
}

+ (RSAPrivateKey *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[RSAPrivateKey class]]) {
        return (RSAPrivateKey *)paramObject;
    }
    if (paramObject) {
        return [[[RSAPrivateKey alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (RSAPrivateKey *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [RSAPrivateKey getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        BigInteger *localBigInteger = [(ASN1Integer *)[localEnumeration nextObject] getValue];
        if (([localBigInteger intValue] != 0) && ([localBigInteger intValue] != 1)) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"wrong version for RSA private key" userInfo:nil];
        }
        self.version = localBigInteger;
        self.modulus = [(ASN1Integer *)[localEnumeration nextObject] getValue];
        self.publicExponent = [(ASN1Integer *)[localEnumeration nextObject] getValue];
        self.privateExponent = [(ASN1Integer *)[localEnumeration nextObject] getValue];
        self.prime1 = [(ASN1Integer *)[localEnumeration nextObject] getValue];
        self.prime2 = [(ASN1Integer *)[localEnumeration nextObject] getValue];
        self.exponent1 = [(ASN1Integer *)[localEnumeration nextObject] getValue];
        self.exponent2 = [(ASN1Integer *)[localEnumeration nextObject] getValue];
        self.coefficient = [(ASN1Integer *)[localEnumeration nextObject] getValue];
        ASN1Sequence *sequence = nil;
        if (sequence = [localEnumeration nextObject]) {
            self.otherPrimeInfos = sequence;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramBigInteger3:(BigInteger *)paramBigInteger3 paramBigInteger4:(BigInteger *)paramBigInteger4 paramBigInteger5:(BigInteger *)paramBigInteger5 paramBigInteger6:(BigInteger *)paramBigInteger6 paramBigInteger7:(BigInteger *)paramBigInteger7 paramBigInteger8:(BigInteger *)paramBigInteger8
{
    if (self = [super init]) {
        self.version = [BigInteger Zero];
        self.modulus = paramBigInteger1;
        self.publicExponent = paramBigInteger2;
        self.privateExponent = paramBigInteger3;
        self.prime1 = paramBigInteger4;
        self.prime2 = paramBigInteger5;
        self.exponent1 = paramBigInteger6;
        self.exponent2 = paramBigInteger7;
        self.coefficient = paramBigInteger8;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BigInteger *)getVersion {
    return self.version;
}

- (BigInteger *)getModulus {
    return self.modulus;
}

- (BigInteger *)getPublicExponent {
    return self.publicExponent;
}

- (BigInteger *)getPrivateExponent {
    return self.privateExponent;
}

- (BigInteger *)getPrime1 {
    return self.prime1;
}

- (BigInteger *)getPrime2 {
    return self.prime2;
}

- (BigInteger *)getExponent1 {
    return self.exponent1;
}

- (BigInteger *)getExponent2 {
    return self.exponent2;
}

- (BigInteger *)getCoefficient {
    return self.coefficient;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    ASN1Encodable *versionEncodable =[[ASN1Integer alloc] initBI:self.version];
    ASN1Encodable *modulusEncodable =[[ASN1Integer alloc] initBI:[self getModulus]];
    ASN1Encodable *publicEncodable =[[ASN1Integer alloc] initBI:[self getPublicExponent]];
    ASN1Encodable *privateEncodable =[[ASN1Integer alloc] initBI:[self getPrivateExponent]];
    ASN1Encodable *prime1Encodable =[[ASN1Integer alloc] initBI:[self getPrime1]];
    ASN1Encodable *prime2Encodable =[[ASN1Integer alloc] initBI:[self getPrime2]];
    ASN1Encodable *exponent1Encodable =[[ASN1Integer alloc] initBI:[self getExponent1]];
    ASN1Encodable *exponent2Encodable =[[ASN1Integer alloc] initBI:[self getExponent2]];
    ASN1Encodable *coefficientEncodable =[[ASN1Integer alloc] initBI:[self getCoefficient]];
    [localASN1EncodableVector add:versionEncodable];
    [localASN1EncodableVector add:modulusEncodable];
    [localASN1EncodableVector add:publicEncodable];
    [localASN1EncodableVector add:privateEncodable];
    [localASN1EncodableVector add:prime1Encodable];
    [localASN1EncodableVector add:prime2Encodable];
    [localASN1EncodableVector add:exponent1Encodable];
    [localASN1EncodableVector add:exponent2Encodable];
    [localASN1EncodableVector add:coefficientEncodable];
    if (self.otherPrimeInfos) {
        [localASN1EncodableVector add:self.otherPrimeInfos];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (versionEncodable) [versionEncodable release]; versionEncodable = nil;
    if (modulusEncodable) [modulusEncodable release]; modulusEncodable = nil;
    if (publicEncodable) [publicEncodable release]; publicEncodable = nil;
    if (privateEncodable) [privateEncodable release]; privateEncodable = nil;
    if (prime1Encodable) [prime1Encodable release]; prime1Encodable = nil;
    if (prime2Encodable) [prime2Encodable release]; prime2Encodable = nil;
    if (exponent1Encodable) [exponent1Encodable release]; exponent1Encodable = nil;
    if (exponent2Encodable) [exponent2Encodable release]; exponent2Encodable = nil;
    if (coefficientEncodable) [coefficientEncodable release]; coefficientEncodable = nil;
#endif
    return primitive;
}


@end
