//
//  GOST3410PublicKeyAlgParameters.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "GOST3410PublicKeyAlgParameters.h"
#import "DERSequence.h"

@interface GOST3410PublicKeyAlgParameters ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *publicKeyParamSet;
@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *digestParamSet;
@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *encryptionParamSet;

@end

@implementation GOST3410PublicKeyAlgParameters
@synthesize publicKeyParamSet = _publicKeyParamSet;
@synthesize digestParamSet = _digestParamSet;
@synthesize encryptionParamSet = _encryptionParamSet;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_publicKeyParamSet) {
        [_publicKeyParamSet release];
        _publicKeyParamSet = nil;
    }
    if (_digestParamSet) {
        [_digestParamSet release];
        _digestParamSet = nil;
    }
    if (_encryptionParamSet) {
        [_encryptionParamSet release];
        _encryptionParamSet = nil;
    }
    [super dealloc];
#endif
}

+ (GOST3410PublicKeyAlgParameters *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [GOST3410PublicKeyAlgParameters getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (GOST3410PublicKeyAlgParameters *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[GOST3410PublicKeyAlgParameters class]]) {
        return (GOST3410PublicKeyAlgParameters *)paramObject;
    }
    if (paramObject) {
        return [[[GOST3410PublicKeyAlgParameters alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1ObjectIdentifier1:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier1 paramASN1ObjectIdentifier2:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier2
{
    self = [super init];
    if (self) {
        self.publicKeyParamSet = paramASN1ObjectIdentifier1;
        self.digestParamSet = paramASN1ObjectIdentifier2;
        self.encryptionParamSet = nil;
    }
    return self;
}

- (instancetype)initParamASN1ObjectIdentifier1:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier1 paramASN1ObjectIdentifier2:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier2 paramASN1ObjectIdentifier3:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier3
{
    self = [super init];
    if (self) {
        self.publicKeyParamSet = paramASN1ObjectIdentifier1;
        self.digestParamSet = paramASN1ObjectIdentifier2;
        self.encryptionParamSet = paramASN1ObjectIdentifier3;
    }
    return self;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        self.publicKeyParamSet = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        self.digestParamSet = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:1];
        if ([paramASN1Sequence size] > 2) {
            self.encryptionParamSet = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:2];
        }
    }
    return self;
}

- (ASN1ObjectIdentifier *)getPublicKeyParamSet {
    return self.publicKeyParamSet;
}

- (ASN1ObjectIdentifier *)getDigestParamSet {
    return self.digestParamSet;
}

- (ASN1ObjectIdentifier *)getEncryptionParamSet {
    return self.encryptionParamSet;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.publicKeyParamSet];
    [localASN1EncodableVector add:self.digestParamSet];
    if (self.encryptionParamSet) {
        [localASN1EncodableVector add:self.encryptionParamSet];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
