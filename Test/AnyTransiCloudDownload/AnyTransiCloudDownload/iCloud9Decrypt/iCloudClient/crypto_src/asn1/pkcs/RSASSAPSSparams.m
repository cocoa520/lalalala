//
//  RSASSAPSSparams.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RSASSAPSSparams.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "OIWObjectIdentifier.h"
#import "PKCSObjectIdentifiers.h"
#import "DERNull.h"
#import "DERTaggedObject.h"

@interface RSASSAPSSparams ()

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *hashAlgorithm;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *maskGenAlgorithm;
@property (nonatomic, readwrite, retain) ASN1Integer *saltLength;
@property (nonatomic, readwrite, retain) ASN1Integer *trailerField;

@end

@implementation RSASSAPSSparams
@synthesize hashAlgorithm = _hashAlgorithm;
@synthesize maskGenAlgorithm = _maskGenAlgorithm;
@synthesize saltLength = _saltLength;
@synthesize trailerField = _trailerField;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_hashAlgorithm) {
        [_hashAlgorithm release];
        _hashAlgorithm = nil;
    }
    if (_maskGenAlgorithm) {
        [_maskGenAlgorithm release];
        _maskGenAlgorithm = nil;
    }
    if (_saltLength) {
        [_saltLength release];
        _saltLength = nil;
    }
    if (_trailerField) {
        [_trailerField release];
        _trailerField = nil;
    }
    [super dealloc];
#endif
}

+ (AlgorithmIdentifier *)DEFAULT_HASH_ALGORITHM {
    static AlgorithmIdentifier *_DEFAULT_HASH_ALGORITHM = nil;
    @synchronized(self) {
        if (!_DEFAULT_HASH_ALGORITHM) {
            _DEFAULT_HASH_ALGORITHM = [[AlgorithmIdentifier alloc] initParamASN1ObjectIdentifier:[OIWObjectIdentifier idSHA1] paramASN1Encodable:[DERNull INSTANCE]];
        }
    }
    return _DEFAULT_HASH_ALGORITHM;
}

+ (AlgorithmIdentifier *)DEFAULT_MASK_GEN_FUNCTION {
    static AlgorithmIdentifier *_DEFAULT_MASK_GEN_FUNCTION = nil;
    @synchronized(self) {
        if (!_DEFAULT_MASK_GEN_FUNCTION) {
            _DEFAULT_MASK_GEN_FUNCTION = [[AlgorithmIdentifier alloc] initParamASN1ObjectIdentifier:[PKCSObjectIdentifiers id_mgf1] paramASN1Encodable:[RSASSAPSSparams DEFAULT_HASH_ALGORITHM]];
        }
    }
    return _DEFAULT_MASK_GEN_FUNCTION;
}

+ (ASN1Integer *)DEFAULT_SALT_LENGTH {
    static ASN1Integer *_DEFAULT_SALT_LENGTH = nil;
    @synchronized(self) {
        if (!_DEFAULT_SALT_LENGTH) {
            _DEFAULT_SALT_LENGTH = [[ASN1Integer alloc] initLong:20];
        }
    }
    return _DEFAULT_SALT_LENGTH;
}

+ (ASN1Integer *)DEFAULT_TRAILER_FIELD {
    static ASN1Integer *_DEFAULT_TRAILER_FIELD = nil;
    @synchronized(self) {
        if (!_DEFAULT_TRAILER_FIELD) {
            _DEFAULT_TRAILER_FIELD = [[ASN1Integer alloc] initLong:1];
        }
    }
    return _DEFAULT_TRAILER_FIELD;
}

+ (RSASSAPSSparams *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[RSASSAPSSparams class]]) {
        return (RSASSAPSSparams *)paramObject;
    }
    if (paramObject) {
        return [[[RSASSAPSSparams alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.hashAlgorithm = [RSASSAPSSparams DEFAULT_HASH_ALGORITHM];
        self.maskGenAlgorithm = [RSASSAPSSparams DEFAULT_MASK_GEN_FUNCTION];
        self.saltLength = [RSASSAPSSparams DEFAULT_SALT_LENGTH];
        self.trailerField = [RSASSAPSSparams DEFAULT_TRAILER_FIELD];
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
        self.hashAlgorithm = [RSASSAPSSparams DEFAULT_HASH_ALGORITHM];
        self.maskGenAlgorithm = [RSASSAPSSparams DEFAULT_MASK_GEN_FUNCTION];
        self.saltLength = [RSASSAPSSparams DEFAULT_SALT_LENGTH];
        self.trailerField = [RSASSAPSSparams DEFAULT_TRAILER_FIELD];
        for (int i = 0; i != [paramASN1Sequence size]; i++) {
            ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)[paramASN1Sequence getObjectAt:i];
            switch ([localASN1TaggedObject getTagNo]) {
                case 0:
                    self.hashAlgorithm = [AlgorithmIdentifier getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                case 1:
                    self.maskGenAlgorithm = [AlgorithmIdentifier getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                case 2:
                    self.saltLength = [ASN1Integer getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                case 3:
                    self.trailerField = [ASN1Integer getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:@"unknown tag" userInfo:nil];
                    break;
            }
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier1:(AlgorithmIdentifier *)paramAlgorithmIdentifier1 paramAlgorithmIdentifier2:(AlgorithmIdentifier *)paramAlgorithmIdentifier2 paramASN1Integer1:(ASN1Integer *)paramASN1Integer1 paramASN1Integer2:(ASN1Integer *)paramASN1Integer2
{
    if (self = [super init]) {
        self.hashAlgorithm = paramAlgorithmIdentifier1;
        self.maskGenAlgorithm = paramAlgorithmIdentifier2;
        self.saltLength = paramASN1Integer1;
        self.trailerField = paramASN1Integer2;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (AlgorithmIdentifier *)getHashAlgorithm {
    return self.hashAlgorithm;
}

- (AlgorithmIdentifier *)getMaskGenAlgorithm {
    return self.maskGenAlgorithm;
}

- (BigInteger *)getSaltLength {
    return [self.saltLength getValue];
}

- (BigInteger *)getTrailerField {
    return [self.trailerField getValue];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (![self.hashAlgorithm isEqual:[RSASSAPSSparams DEFAULT_HASH_ALGORITHM]]) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.hashAlgorithm];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (![self.maskGenAlgorithm isEqual:[RSASSAPSSparams DEFAULT_MASK_GEN_FUNCTION]]) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.maskGenAlgorithm];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (![self.saltLength isEqual:[RSASSAPSSparams DEFAULT_SALT_LENGTH]]) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:2 paramASN1Encodable:self.saltLength];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (![self.trailerField isEqual:[RSASSAPSSparams DEFAULT_TRAILER_FIELD]]) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:3 paramASN1Encodable:self.trailerField];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
