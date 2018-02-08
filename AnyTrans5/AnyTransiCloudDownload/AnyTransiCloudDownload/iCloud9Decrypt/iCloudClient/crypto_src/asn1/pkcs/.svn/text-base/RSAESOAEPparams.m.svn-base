//
//  RSAESOAEPparams.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RSAESOAEPparams.h"
#import "OIWObjectIdentifier.h"
#import "PKCSObjectIdentifiers.h"
#import "DERNull.h"
#import "DEROctetString.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface RSAESOAEPparams ()

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *hashAlgorithm;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *maskGenAlgorithm;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *pSourceAlgorithm;

@end

@implementation RSAESOAEPparams
@synthesize hashAlgorithm = _hashAlgorithm;
@synthesize maskGenAlgorithm = _maskGenAlgorithm;
@synthesize pSourceAlgorithm = _pSourceAlgorithm;

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
    if (_pSourceAlgorithm) {
        [_pSourceAlgorithm release];
        _pSourceAlgorithm = nil;
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
            _DEFAULT_MASK_GEN_FUNCTION = [[AlgorithmIdentifier alloc] initParamASN1ObjectIdentifier:[PKCSObjectIdentifiers id_mgf1] paramASN1Encodable:[RSAESOAEPparams DEFAULT_HASH_ALGORITHM]];
        }
    }
    return _DEFAULT_MASK_GEN_FUNCTION;
}

+ (AlgorithmIdentifier *)DEFAULT_P_SOURCE_ALGORITHM {
    static AlgorithmIdentifier *_DEFAULT_P_SOURCE_ALGORITHM = nil;
    @synchronized(self) {
        if (!_DEFAULT_P_SOURCE_ALGORITHM) {
            NSMutableData *mutData = [[NSMutableData alloc] initWithSize:0];
            ASN1Encodable *derOctetString = [[DEROctetString alloc] initDEROctetString:mutData];
            _DEFAULT_P_SOURCE_ALGORITHM = [[AlgorithmIdentifier alloc] initParamASN1ObjectIdentifier:[PKCSObjectIdentifiers id_pSpecified] paramASN1Encodable:derOctetString];
#if !__has_feature(objc_arc)
    if (mutData) [mutData release]; mutData = nil;
    if (derOctetString) [derOctetString release]; derOctetString = nil;
#endif
        }
    }
    return _DEFAULT_P_SOURCE_ALGORITHM;
}

+ (RSAESOAEPparams *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[RSAESOAEPparams class]]) {
        return (RSAESOAEPparams *)paramObject;
    }
    if (paramObject) {
        return [[[RSAESOAEPparams alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.hashAlgorithm = [RSAESOAEPparams DEFAULT_HASH_ALGORITHM];
        self.maskGenAlgorithm = [RSAESOAEPparams DEFAULT_MASK_GEN_FUNCTION];
        self.pSourceAlgorithm = [RSAESOAEPparams DEFAULT_P_SOURCE_ALGORITHM];
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
                    self.pSourceAlgorithm = [AlgorithmIdentifier getInstance:localASN1TaggedObject paramBoolean:YES];
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

- (instancetype)init
{
    if (self = [super init]) {
        self.hashAlgorithm = [RSAESOAEPparams DEFAULT_HASH_ALGORITHM];
        self.maskGenAlgorithm = [RSAESOAEPparams DEFAULT_MASK_GEN_FUNCTION];
        self.pSourceAlgorithm = [RSAESOAEPparams DEFAULT_P_SOURCE_ALGORITHM];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier1:(AlgorithmIdentifier *)paramAlgorithmIdentifier1 paramAlgorithmIdentifier2:(AlgorithmIdentifier *)paramAlgorithmIdentifier2 paramAlgorithmIdentifier3:(AlgorithmIdentifier *)paramAlgorithmIdentifier3
{
    if (self = [super init]) {
        self.hashAlgorithm = paramAlgorithmIdentifier1;
        self.maskGenAlgorithm = paramAlgorithmIdentifier2;
        self.pSourceAlgorithm = paramAlgorithmIdentifier3;
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

- (AlgorithmIdentifier *)getPSourceAlgorithm {
    return self.pSourceAlgorithm;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (![self.hashAlgorithm isEqual:[RSAESOAEPparams DEFAULT_HASH_ALGORITHM]]) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.hashAlgorithm];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (![self.maskGenAlgorithm isEqual:[RSAESOAEPparams DEFAULT_MASK_GEN_FUNCTION]]) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.maskGenAlgorithm];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (![self.pSourceAlgorithm isEqual:[RSAESOAEPparams DEFAULT_P_SOURCE_ALGORITHM]]) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:2 paramASN1Encodable:self.pSourceAlgorithm];
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
