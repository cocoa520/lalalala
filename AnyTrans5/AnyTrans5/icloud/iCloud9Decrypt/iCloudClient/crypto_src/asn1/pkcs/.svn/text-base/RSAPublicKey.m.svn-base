//
//  RSAPublicKey.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RSAPublicKey.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "ASN1Integer.h"

@interface RSAPublicKey ()

@property (nonatomic, readwrite, retain) BigInteger *modulus;
@property (nonatomic, readwrite, retain) BigInteger *publicExponent;

@end

@implementation RSAPublicKey
@synthesize modulus = _modulus;
@synthesize publicExponent = _publicExponent;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_modulus) {
        [_modulus release];
        _modulus = nil;
    }
    if (_publicExponent) {
        [_publicExponent release];
        _publicExponent = nil;
    }
    [super dealloc];
#endif
}

+ (RSAPublicKey *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[RSAPublicKey class]]) {
        return (RSAPublicKey *)paramObject;
    }
    if (paramObject) {
        return [[[RSAPublicKey alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (RSAPublicKey *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [RSAPublicKey getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.modulus = [[ASN1Integer getInstance:[localEnumeration nextObject]] getPositiveValue];
        self.publicExponent = [[ASN1Integer getInstance:[localEnumeration nextObject]] getPositiveValue];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2
{
    if (self = [super init]) {
        self.modulus = paramBigInteger1;
        self.publicExponent = paramBigInteger2;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BigInteger *)getModulus {
    return self.modulus;
}

- (BigInteger *)getPublicExponent {
    return self.publicExponent;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    ASN1Encodable *modulusEncodable = [[ASN1Integer alloc] initBI:[self getModulus]];
    ASN1Encodable *publicExponentEncodable = [[ASN1Integer alloc] initBI:[self getPublicExponent]];
    [localASN1EncodableVector add:modulusEncodable];
    [localASN1EncodableVector add:publicExponentEncodable];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (modulusEncodable) [modulusEncodable release]; modulusEncodable = nil;
    if (publicExponentEncodable) [publicExponentEncodable release]; publicExponentEncodable = nil;
#endif
    return primitive;
}

@end
