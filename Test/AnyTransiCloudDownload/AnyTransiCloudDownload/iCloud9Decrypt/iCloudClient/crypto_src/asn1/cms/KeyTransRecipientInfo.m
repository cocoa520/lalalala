//
//  KeyTransRecipientInfo.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "KeyTransRecipientInfo.h"
#import "DERSequence.h"

@interface KeyTransRecipientInfo ()

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) RecipientKeyIdentifier *rid;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *keyEncryptionAlgorithm;
@property (nonatomic, readwrite, retain) ASN1OctetString *encryptedKey;

@end

@implementation KeyTransRecipientInfo
@synthesize version = _version;
@synthesize rid = _rid;
@synthesize keyEncryptionAlgorithm = _keyEncryptionAlgorithm;
@synthesize encryptedKey = _encryptedKey;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_rid) {
        [_rid release];
        _rid = nil;
    }
    if (_keyEncryptionAlgorithm) {
        [_keyEncryptionAlgorithm release];
        _keyEncryptionAlgorithm = nil;
    }
    if (_encryptedKey) {
        [_encryptedKey release];
        _encryptedKey = nil;
    }
    [super dealloc];
#endif
}

+ (KeyTransRecipientInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[KeyTransRecipientInfo class]]) {
        return (KeyTransRecipientInfo *)paramObject;
    }
    if (paramObject) {
        return [[[KeyTransRecipientInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.version = (ASN1Integer *)[paramASN1Sequence getObjectAt:0];
        self.rid = [RecipientKeyIdentifier getInstance:[paramASN1Sequence getObjectAt:1]];
        self.keyEncryptionAlgorithm = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:2]];
        self.encryptedKey = (ASN1OctetString *)[paramASN1Sequence getObjectAt:3];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamRecipientIdentifier:(RecipientKeyIdentifier *)paramRecipientIdentifier paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        if ([[paramRecipientIdentifier toASN1Primitive] isKindOfClass:[ASN1TaggedObject class]]) {
            ASN1Integer *integer = [[ASN1Integer alloc] initLong:2];
            self.version = integer;
#if !__has_feature(objc_arc)
    if (integer) [integer release]; integer = nil;
#endif
        }else {
            ASN1Integer *integer = [[ASN1Integer alloc] initLong:0];
            self.version = integer;
#if !__has_feature(objc_arc)
            if (integer) [integer release]; integer = nil;
#endif
        }
        self.rid = paramRecipientIdentifier;
        self.keyEncryptionAlgorithm = paramAlgorithmIdentifier;
        self.encryptedKey = paramASN1OctetString;
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

- (RecipientKeyIdentifier *)getRecipientIdentifier {
    return self.rid;
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
    [localASN1EncodableVector add:self.rid];
    [localASN1EncodableVector add:self.keyEncryptionAlgorithm];
    [localASN1EncodableVector add:self.encryptedKey];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
