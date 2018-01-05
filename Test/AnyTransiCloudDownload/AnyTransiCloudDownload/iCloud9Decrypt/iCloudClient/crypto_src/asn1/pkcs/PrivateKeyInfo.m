//
//  PrivateKeyInfo.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PrivateKeyInfo.h"
#import "BigInteger.h"
#import "ASN1Integer.h"
#import "DEROctetString.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface PrivateKeyInfo ()

@property (nonatomic, readwrite, retain) ASN1OctetString *privKey;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *algId;
@property (nonatomic, readwrite, retain) ASN1Set *attributes;

@end

@implementation PrivateKeyInfo
@synthesize privKey = _privKey;
@synthesize algId = _algId;
@synthesize attributes = _attributes;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_privKey) {
        [_privKey release];
        _privKey = nil;
    }
    if (_algId) {
        [_algId release];
        _algId = nil;
    }
    if (_attributes) {
        [_attributes release];
        _attributes = nil;
    }
    [super dealloc];
#endif
}

+ (PrivateKeyInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PrivateKeyInfo class]]) {
        return (PrivateKeyInfo *)paramObject;
    }
    if (paramObject) {
        return [[[PrivateKeyInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (PrivateKeyInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [PrivateKeyInfo getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        BigInteger *localBigInteger = [(ASN1Integer *)[localEnumeration nextObject] getValue];
        if ([localBigInteger intValue]) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"wrong version for private key info" userInfo:nil];
        }
        self.algId = [AlgorithmIdentifier getInstance:[localEnumeration nextObject]];
        self.privKey = [ASN1OctetString getInstance:[localEnumeration nextObject]];
        id localObject = nil;
        if (localObject = [localEnumeration nextObject]) {
            self.attributes = [ASN1Set getInstance:localObject paramBoolean:false];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        [self initParamAlgorithmIdentifier:paramAlgorithmIdentifier paramASN1Encodable:paramASN1Encodable paramASN1Set:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable paramASN1Set:(ASN1Set *)paramASN1Set
{
    if (self = [super init]) {
        ASN1OctetString *privKeyOctetString = [[DEROctetString alloc] initDEROctetString:[[paramASN1Encodable toASN1Primitive] getEncoded:@"DER"]];
        self.privKey = privKeyOctetString;
        self.algId = paramAlgorithmIdentifier;
        self.attributes = paramASN1Set;
#if !__has_feature(objc_arc)
    if (privKeyOctetString) [privKeyOctetString release]; privKeyOctetString = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (AlgorithmIdentifier *)getPrivateKeyAlgorithm {
    return self.algId;
}

- (AlgorithmIdentifier *)getAlgorithmId {
    return self.algId;
}

- (ASN1Encodable *)parsePrivateKey {
    return [ASN1Primitive fromByteArray:[self.privKey getOctets]];
}

- (ASN1Primitive *)getPrivateKey {
    @try {
        return [[self parsePrivateKey] toASN1Primitive];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"unable to parse private key" userInfo:nil];
    }
}

- (ASN1Set *)getAttributes {
    return self.attributes;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    ASN1Integer *integer = [[ASN1Integer alloc] initLong:0];
    [localASN1EncodableVector add:integer];
#if !__has_feature(objc_arc)
    if (integer) [integer release]; integer = nil;
#endif
    [localASN1EncodableVector add:self.algId];
    [localASN1EncodableVector add:self.privKey];
    if (self.attributes) {
        ASN1Encodable *attributesEncodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:0 paramASN1Encodable:self.attributes];
        [localASN1EncodableVector add:attributesEncodable];
#if !__has_feature(objc_arc)
        if (attributesEncodable) [attributesEncodable release]; attributesEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
