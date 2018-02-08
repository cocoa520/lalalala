//
//  KeyAgreeRecipientInfo.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "KeyAgreeRecipientInfo.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface KeyAgreeRecipientInfo ()

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) OriginatorIdentifierOrKey *originator;
@property (nonatomic, readwrite, retain) ASN1OctetString *ukm;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *keyEncryptionAlgorithm;
@property (nonatomic, readwrite, retain) ASN1Sequence *recipientEncryptedKeys;

@end

@implementation KeyAgreeRecipientInfo
@synthesize version = _version;
@synthesize originator = _originator;
@synthesize ukm = _ukm;
@synthesize keyEncryptionAlgorithm = _keyEncryptionAlgorithm;
@synthesize recipientEncryptedKeys = _recipientEncryptedKeys;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_originator) {
        [_originator release];
        _originator = nil;
    }
    if (_ukm) {
        [_ukm release];
        _ukm = nil;
    }
    if (_keyEncryptionAlgorithm) {
        [_keyEncryptionAlgorithm release];
        _keyEncryptionAlgorithm = nil;
    }
    if (_recipientEncryptedKeys) {
        [_recipientEncryptedKeys release];
        _recipientEncryptedKeys = nil;
    }
    [super dealloc];
#endif
}

+ (KeyAgreeRecipientInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[KeyAgreeRecipientInfo class]]) {
        return (KeyAgreeRecipientInfo *)paramObject;
    }
    if (paramObject) {
        return [[[KeyAgreeRecipientInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (KeyAgreeRecipientInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [KeyAgreeRecipientInfo getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = 0;
        self.version = (ASN1Integer *)[paramASN1Sequence getObjectAt:i++];
        self.originator = [OriginatorIdentifierOrKey getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:i++] paramBoolean:TRUE];
        if ([[paramASN1Sequence getObjectAt:i] isKindOfClass:[ASN1TaggedObject class]]) {
            self.ukm = [ASN1OctetString getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:i++] paramBoolean:TRUE];
        }
        self.keyEncryptionAlgorithm = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:i++]];
        self.recipientEncryptedKeys = (ASN1Sequence *)[paramASN1Sequence getObjectAt:i++];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamOriginatorIdentifierOrKey:(OriginatorIdentifierOrKey *)paramOriginatorIdentifierOrKey paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        ASN1Integer *versionInteger = [[ASN1Integer alloc] initLong:3];
        self.version = versionInteger;
        self.originator = paramOriginatorIdentifierOrKey;
        self.ukm = paramASN1OctetString;
        self.keyEncryptionAlgorithm = paramAlgorithmIdentifier;
        self.recipientEncryptedKeys = paramASN1Sequence;
#if !__has_feature(objc_arc)
    if (versionInteger) [versionInteger release]; versionInteger = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Integer *)getVersion {
    return self.version;
}

- (OriginatorIdentifierOrKey *)getOriginator {
    return self.originator;
}

- (ASN1OctetString *)getUserKeyingMaterial {
    return self.ukm;
}

- (AlgorithmIdentifier *)getKeyEncryptionAlgorithm {
    return self.keyEncryptionAlgorithm;
}

- (ASN1Sequence *)getRecipientEncryptedKeys {
    return self.recipientEncryptedKeys;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.version];
    ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.originator];
    [localASN1EncodableVector add:encodable];
    if (self.ukm) {
        ASN1Encodable *ukmEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.ukm];
        [localASN1EncodableVector add:ukmEncodable];
#if !__has_feature(objc_arc)
        if (ukmEncodable) [ukmEncodable release]; ukmEncodable = nil;
#endif
    }
    [localASN1EncodableVector add:self.keyEncryptionAlgorithm];
    [localASN1EncodableVector add:self.recipientEncryptedKeys];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
