//
//  RSAPublicKeyEAC.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RSAPublicKeyEAC.h"
#import "UnsignedInteger.h"
#import "DERSequence.h"

@interface RSAPublicKeyEAC ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *usage;
@property (nonatomic, readwrite, retain) BigInteger *modulus;
@property (nonatomic, readwrite, retain) BigInteger *exponent;
@property (nonatomic, assign) int valid;

@end

@implementation RSAPublicKeyEAC
@synthesize usage = _usage;
@synthesize modulus = _modulus;
@synthesize exponent = _exponent;
@synthesize valid = _valid;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_usage) {
        [_usage release];
        _usage = nil;
    }
    if (_modulus) {
        [_modulus release];
        _modulus = nil;
    }
    if (_exponent) {
        [_exponent release];
        _exponent = nil;
    }
    [super dealloc];
#endif
}

+ (int)modulusValid {
    static int _modulusValid = 0;
    @synchronized(self) {
        if (!_modulusValid) {
            _modulusValid = 1;
        }
    }
    return _modulusValid;
}

+ (int)exponentValid {
    static int _exponentValid = 0;
    @synchronized(self) {
        if (!_exponentValid) {
            _exponentValid = 2;
        }
    }
    return _exponentValid;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.usage = [ASN1ObjectIdentifier getInstance:[localEnumeration nextObject]];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            UnsignedInteger *localUnsignedInteger = [UnsignedInteger getInstance:localObject];
            switch ([localUnsignedInteger getTagNo]) {
                case 1:
                    [self setIsModulus:localUnsignedInteger];
                    break;
                case 2:
                    [self setIsExponent:localUnsignedInteger];
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Unknown DERTaggedObject :%d-> not an Iso7816RSAPublicKeyStructure", [localUnsignedInteger getTagNo]] userInfo:nil];
                    break;
            }
        }
        if (self.valid != 3) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"missing argument -> not an Iso7816RSAPublicKeyStructure" userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2
{
    if (self = [super init]) {
        self.usage = paramASN1ObjectIdentifier;
        self.modulus = paramBigInteger1;
        self.exponent = paramBigInteger2;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getUsage {
    return self.usage;
}

- (BigInteger *)getModulus {
    return self.modulus;
}

- (BigInteger *)getPublicExponent {
    return self.exponent;
}

- (void)setIsModulus:(UnsignedInteger *)paramUnsignedInteger {
    if ((self.valid & [RSAPublicKeyEAC modulusValid]) == 0) {
        self.valid |= [RSAPublicKeyEAC modulusValid];
        self.modulus = [paramUnsignedInteger getValue];
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Modulus already set" userInfo:nil];
    }
}

- (void)setIsExponent:(UnsignedInteger *)paramUnsignedInteger {
    if ((self.valid & [RSAPublicKeyEAC exponentValid]) == 0) {
        self.valid |= [RSAPublicKeyEAC exponentValid];
        self.exponent = [paramUnsignedInteger getValue];
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Exponent already set" userInfo:nil];
    }
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.usage];
    ASN1Encodable *modulusEncodable = [[UnsignedInteger alloc] initParamInt:1 paramBigInteger:[self getModulus]];
    ASN1Encodable *publicExponentEncodable = [[UnsignedInteger alloc] initParamInt:2 paramBigInteger:[self getPublicExponent]];
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
