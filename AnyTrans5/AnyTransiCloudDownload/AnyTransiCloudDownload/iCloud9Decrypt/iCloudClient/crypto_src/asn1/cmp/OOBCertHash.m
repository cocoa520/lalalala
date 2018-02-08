//
//  OOBCertHash.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OOBCertHash.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"

@interface OOBCertHash ()

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *hashAlg;
@property (nonatomic, readwrite, retain) CertIdCRMF *certId;
@property (nonatomic, readwrite, retain) DERBitString *hashVal;

@end

@implementation OOBCertHash
@synthesize hashAlg = _hashAlg;
@synthesize certId = _certId;
@synthesize hashVal = _hashVal;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_hashAlg) {
        [_hashAlg release];
        _hashAlg = nil;
    }
    if (_certId) {
        [_certId release];
        _certId = nil;
    }
    if (_hashVal) {
        [_hashVal release];
        _hashVal = nil;
    }
    [super dealloc];
#endif
}

+ (OOBCertHash *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OOBCertHash class]]) {
        return (OOBCertHash *)paramObject;
    }
    if (paramObject) {
        return [[[OOBCertHash alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        int i = (int)[paramASN1Sequence size] - 1;
        self.hashVal = [DERBitString getInstance:[paramASN1Sequence getObjectAt:i--]];
        for (int j = i; j >= 0; j--) {
            ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)[paramASN1Sequence getObjectAt:j];
            if ([localASN1TaggedObject getTagNo] == 0) {
                self.hashAlg = [AlgorithmIdentifier getInstance:localASN1TaggedObject paramBoolean:TRUE];
            }else {
                self.certId = [CertIdCRMF getInstance:localASN1TaggedObject paramBoolean:TRUE];
            }
        }
    }
    return self;
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramCertId:(CertIdCRMF *)paramCertId paramArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    self = [super init];
    if (self) {
        DERBitString *derBit = [[DERBitString alloc] initDERBitString:paramArrayOfByte];
        [self initParamAlgorithmIdentifier:paramAlgorithmIdentifier paramCertId:paramCertId paramDERBitString:derBit];
#if !__has_feature(objc_arc)
        if (derBit) [derBit release]; derBit = nil;
#endif
    }
    return self;
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramCertId:(CertIdCRMF *)paramCertId paramDERBitString:(DERBitString *)paramDERBitString
{
    self = [super init];
    if (self) {
        self.hashAlg = paramAlgorithmIdentifier;
        self.certId = paramCertId;
        self.hashVal = paramDERBitString;
    }
    return self;
}

- (AlgorithmIdentifier *)getHashAlg {
    return self.hashAlg;
}

- (CertIdCRMF *)getCertId {
    return self.certId;
}

- (DERBitString *)getHashVal {
    return self.hashVal;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [self addOptional:localASN1EncodableVector paramInt:0 paramASN1Encodable:self.hashAlg];
    [self addOptional:localASN1EncodableVector paramInt:1 paramASN1Encodable:self.certId];
    [localASN1EncodableVector add:self.hashVal];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (void)addOptional:(ASN1EncodableVector *)paramASN1EncodableVector paramInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable {
    if (paramASN1Encodable) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:TRUE paramInt:paramInt paramASN1Encodable:paramASN1Encodable];
        [paramASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
}

@end
