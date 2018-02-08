//
//  KEKRecipientInfo.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "KEKRecipientInfo.h"
#import "DERSequence.h"

@interface KEKRecipientInfo ()

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) KEKIdentifier *kekid;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *keyEncryptionAlgorithm;
@property (nonatomic, readwrite, retain) ASN1OctetString *encryptedKey;

@end

@implementation KEKRecipientInfo
@synthesize version = _version;
@synthesize kekid = _kekid;
@synthesize keyEncryptionAlgorithm = _keyEncryptionAlgorithm;
@synthesize encryptedKey = _encryptedKey;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_kekid) {
        [_kekid release];
        _kekid = nil;
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

+ (KEKRecipientInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[KEKRecipientInfo class]]) {
        return (KEKRecipientInfo *)paramObject;
    }
    if (paramObject) {
        return [[[KEKRecipientInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (KEKRecipientInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [KEKRecipientInfo getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.version = (ASN1Integer *)[paramASN1Sequence getObjectAt:0];
        self.kekid = [KEKIdentifier getInstance:[paramASN1Sequence getObjectAt:1]];
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

- (instancetype)initParamKEKIdentifier:(KEKIdentifier *)paramKEKIdentifier paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        ASN1Integer *integer = [[ASN1Integer alloc] initLong:4];
        self.version = integer;
#if !__has_feature(objc_arc)
    if (integer) [integer release]; integer = nil;
#endif
        self.kekid = paramKEKIdentifier;
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

- (KEKIdentifier *)getKekid {
    return self.kekid;
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
    [localASN1EncodableVector add:self.kekid];
    [localASN1EncodableVector add:self.keyEncryptionAlgorithm];
    [localASN1EncodableVector add:self.encryptedKey];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
