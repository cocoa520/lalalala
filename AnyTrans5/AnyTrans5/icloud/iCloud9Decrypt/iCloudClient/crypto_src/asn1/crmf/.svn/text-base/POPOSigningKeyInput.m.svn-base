//
//  POPOSigningKeyInput.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "POPOSigningKeyInput.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"

@interface POPOSigningKeyInput ()

@property (nonatomic, readwrite, retain) GeneralName *sender;
@property (nonatomic, readwrite, retain) PKMACValue *publicKeyMAC;
@property (nonatomic, readwrite, retain) SubjectPublicKeyInfo *publicKey;

@end

@implementation POPOSigningKeyInput
@synthesize sender = _sender;
@synthesize publicKeyMAC = _publicKeyMAC;
@synthesize publicKey = _publicKey;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_sender) {
        [_sender release];
        _sender = nil;
    }
    if (_publicKeyMAC) {
        [_publicKeyMAC release];
        _publicKeyMAC = nil;
    }
    if (_publicKey) {
        [_publicKey release];
        _publicKey = nil;
    }
  [super dealloc];
#endif
}

+ (POPOSigningKeyInput *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[POPOSigningKeyInput class]]) {
        return (POPOSigningKeyInput *)paramObject;
    }
    if (paramObject) {
        return [[[POPOSigningKeyInput alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        ASN1Encodable *localASN1Encodable = [paramASN1Sequence getObjectAt:0];
        if ([localASN1Encodable isKindOfClass:[ASN1TaggedObject class]]) {
            ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)localASN1Encodable;
            if ([localASN1TaggedObject getTagNo]) {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Unknown authInfo tag: %d", [localASN1TaggedObject getTagNo]] userInfo:nil];
            }
            self.sender = [GeneralName getInstance:[localASN1TaggedObject getObject]];
        }else {
            self.publicKeyMAC = [PKMACValue getInstance:localASN1Encodable];
        }
        self.publicKey = [SubjectPublicKeyInfo getInstance:[paramASN1Sequence getObjectAt:1]];
    }
    return self;
}

- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramSubjectPublicKeyInfo:(SubjectPublicKeyInfo *)paramSubjectPublicKeyInfo
{
    self = [super init];
    if (self) {
        self.sender = paramGeneralName;
        self.publicKey = paramSubjectPublicKeyInfo;
    }
    return self;
}

- (instancetype)initParamPKMACValue:(PKMACValue *)paramPKMACValue paramSubjectPublicKeyInfo:(SubjectPublicKeyInfo *)paramSubjectPublicKeyInfo
{
    self = [super init];
    if (self) {
        self.publicKeyMAC = paramPKMACValue;
        self.publicKey = paramSubjectPublicKeyInfo;
    }
    return self;
}

- (GeneralName *)getSender {
    return self.sender;
}

- (PKMACValue *)getPublicKeyMAC {
    return self.publicKeyMAC;
}

- (SubjectPublicKeyInfo *)getPublicKey {
    return self.publicKey;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.sender) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:0 paramASN1Encodable:self.sender];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }else {
        [localASN1EncodableVector add:self.publicKeyMAC];
    }
    [localASN1EncodableVector add:self.publicKey];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
