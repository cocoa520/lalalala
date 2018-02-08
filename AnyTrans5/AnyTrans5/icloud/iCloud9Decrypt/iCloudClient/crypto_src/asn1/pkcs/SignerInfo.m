//
//  SignerInfo.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SignerInfo.h"
#import "DERTaggedObject.h"
#import "DEROctetString.h"
#import "DERSequence.h"

@interface SignerInfo ()

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) IssuerAndSerialNumber *issuerAndSerialNumber;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *digAlgorithm;
@property (nonatomic, readwrite, retain) ASN1Set *authenticatedAttributes;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *digEncryptionAlgorithm;
@property (nonatomic, readwrite, retain) ASN1OctetString *encryptedDigest;
@property (nonatomic, readwrite, retain) ASN1Set *unauthenticatedAttributes;

@end

@implementation SignerInfo
@synthesize version = _version;
@synthesize issuerAndSerialNumber = _issuerAndSerialNumber;
@synthesize digAlgorithm = _digAlgorithm;
@synthesize authenticatedAttributes = _authenticatedAttributes;
@synthesize digEncryptionAlgorithm = _digEncryptionAlgorithm;
@synthesize encryptedDigest = _encryptedDigest;
@synthesize unauthenticatedAttributes = _unauthenticatedAttributes;

+ (SignerInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SignerInfo class]]) {
        return (SignerInfo *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[SignerInfo alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown object in factory: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.version = (ASN1Integer *)[localEnumeration nextObject];
        self.issuerAndSerialNumber = [IssuerAndSerialNumber getInstance:[localEnumeration nextObject]];
        self.digAlgorithm = [AlgorithmIdentifier getInstance:[localEnumeration nextObject]];
        id localObject = [localEnumeration nextObject];
        if ([localObject isKindOfClass:[ASN1TaggedObject class]]) {
            self.authenticatedAttributes = [ASN1Set getInstance:(ASN1TaggedObject *)localObject paramBoolean:false];
            self.digEncryptionAlgorithm = [AlgorithmIdentifier getInstance:[localEnumeration nextObject]];
        }else {
            self.authenticatedAttributes = nil;
            self.digEncryptionAlgorithm = [AlgorithmIdentifier getInstance:localObject];
        }
        self.encryptedDigest = [DEROctetString getInstance:[localEnumeration nextObject]];
        id localObject1 = nil;
        if (localObject1 = [localEnumeration nextObject]) {
            self.unauthenticatedAttributes = [ASN1Set getInstance:localObject1 paramBoolean:false];
        }else {
            self.unauthenticatedAttributes = nil;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer paramIssuerAndSerialNumber:(IssuerAndSerialNumber *)paramIssuerAndSerialNumber paramAlgorithmIdentifier1:(AlgorithmIdentifier *)paramAlgorithmIdentifier1 paramASN1Set1:(ASN1Set *)paramASN1Set1 paramAlgorithmIdentifier2:(AlgorithmIdentifier *)paramAlgorithmIdentifier2 paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString paramASN1Set2:(ASN1Set *)paramASN1Set2
{
    if (self = [super init]) {
        self.version = paramASN1Integer;
        self.issuerAndSerialNumber = paramIssuerAndSerialNumber;
        self.digAlgorithm = paramAlgorithmIdentifier1;
        self.authenticatedAttributes = paramASN1Set1;
        self.digEncryptionAlgorithm = paramAlgorithmIdentifier2;
        self.encryptedDigest = paramASN1OctetString;
        self.unauthenticatedAttributes = paramASN1Set2;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)dealloc
{
    [self setVersion:nil];
    [self setIssuerAndSerialNumber:nil];
    [self setDigAlgorithm:nil];
    [self setAuthenticatedAttributes:nil];
    [self setDigEncryptionAlgorithm:nil];
    [self setEncryptedDigest:nil];
    [self setUnauthenticatedAttributes:nil];
    [super dealloc];
}

- (ASN1Integer *)getVersion {
    return self.version;
}

- (IssuerAndSerialNumber *)getIssuerAndSerialNumber {
    return self.issuerAndSerialNumber;
}

- (ASN1Set *)getAuthenticatedAttributes {
    return self.authenticatedAttributes;
}

- (AlgorithmIdentifier *)getDigestAlgorithm {
    return self.digAlgorithm;
}

- (ASN1OctetString *)getEncryptedDigest {
    return self.encryptedDigest;
}

- (AlgorithmIdentifier *)getDigestEncryptionAlgorithm {
    return self.digEncryptionAlgorithm;
}

- (ASN1Set *)getUnauthenticatedAttributes {
    return self.unauthenticatedAttributes;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.version];
    [localASN1EncodableVector add:self.issuerAndSerialNumber];
    [localASN1EncodableVector add:self.digAlgorithm];
    if (self.authenticatedAttributes) {
        ASN1Encodable *authEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:self.authenticatedAttributes];
        [localASN1EncodableVector add:authEncodable];
#if !__has_feature(objc_arc)
        if (authEncodable) [authEncodable release]; authEncodable = nil;
#endif
    }
    [localASN1EncodableVector add:self.digEncryptionAlgorithm];
    [localASN1EncodableVector add:self.encryptedDigest];
    if (self.unauthenticatedAttributes) {
        ASN1Encodable *unauthEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:self.unauthenticatedAttributes];
        [localASN1EncodableVector add:unauthEncodable];
#if !__has_feature(objc_arc)
        if (unauthEncodable) [unauthEncodable release]; unauthEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
