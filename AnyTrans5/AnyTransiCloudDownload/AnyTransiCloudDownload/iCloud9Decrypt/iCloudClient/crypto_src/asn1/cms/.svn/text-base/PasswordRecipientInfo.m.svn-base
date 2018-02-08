//
//  PasswordRecipientInfo.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PasswordRecipientInfo.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface PasswordRecipientInfo ()

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *keyDerivationAlgorithm;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *keyEncryptionAlgorithm;
@property (nonatomic, readwrite, retain) ASN1OctetString *encryptedKey;

@end

@implementation PasswordRecipientInfo
@synthesize version = _version;
@synthesize keyEncryptionAlgorithm = _keyEncryptionAlgorithm;
@synthesize keyDerivationAlgorithm = _keyDerivationAlgorithm;
@synthesize encryptedKey = _encryptedKey;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_keyEncryptionAlgorithm) {
        [_keyEncryptionAlgorithm release];
        _keyEncryptionAlgorithm = nil;
    }
    if (_keyDerivationAlgorithm) {
        [_keyDerivationAlgorithm release];
        _keyDerivationAlgorithm = nil;
    }
    if (_encryptedKey) {
        [_encryptedKey release];
        _encryptedKey = nil;
    }
    [super dealloc];
#endif
}

+ (PasswordRecipientInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PasswordRecipientInfo class]]) {
        return (PasswordRecipientInfo *)paramObject;
    }
    if (paramObject) {
        return [[[PasswordRecipientInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (PasswordRecipientInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [PasswordRecipientInfo getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        self.version = (ASN1Integer *)[paramASN1Sequence getObjectAt:0];
        if ([[paramASN1Sequence getObjectAt:1] isKindOfClass:[ASN1TaggedObject class]]) {
            self.keyDerivationAlgorithm = [AlgorithmIdentifier getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:1] paramBoolean:false];
            self.keyEncryptionAlgorithm = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:2]];
            self.encryptedKey = (ASN1OctetString *)[paramASN1Sequence getObjectAt:3];
        }else {
            self.keyEncryptionAlgorithm = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:1]];
            self.encryptedKey = (ASN1OctetString *)[paramASN1Sequence getObjectAt:2];
        }
    }
    return self;
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    self = [super init];
    if (self) {
        self.version = [[[ASN1Integer alloc] initLong:0] autorelease];
        self.keyEncryptionAlgorithm = paramAlgorithmIdentifier;
        self.encryptedKey = paramASN1OctetString;
    }
    return self;
}

- (instancetype)initParamAlgorithmIdentifier1:(AlgorithmIdentifier *)paramAlgorithmIdentifier1 paramAlgorithmIdentifier2:(AlgorithmIdentifier *)paramAlgorithmIdentifier2 paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    self = [super init];
    if (self) {
        self.version = [[[ASN1Integer alloc] initLong:0] autorelease];
        self.keyDerivationAlgorithm = paramAlgorithmIdentifier1;
        self.keyEncryptionAlgorithm = paramAlgorithmIdentifier2;
        self.encryptedKey = paramASN1OctetString;
    }
    return self;
}

- (ASN1Integer *)getVersion {
    return self.version;
}

- (AlgorithmIdentifier *)getKeyDerivationAlgorithm {
    return self.keyDerivationAlgorithm;
}

- (AlgorithmIdentifier *)getKeyEncryptionAlgorithm {
    return self.keyEncryptionAlgorithm;
}

- (ASN1OctetString *)getEncryptedKey {
    return self.encryptedKey;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.version];
    if (self.keyDerivationAlgorithm) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:self.keyDerivationAlgorithm];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
    }
    [localASN1EncodableVector add:self.keyEncryptionAlgorithm];
    [localASN1EncodableVector add:self.encryptedKey];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
