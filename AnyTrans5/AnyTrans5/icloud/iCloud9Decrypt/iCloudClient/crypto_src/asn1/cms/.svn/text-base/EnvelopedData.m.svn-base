//
//  EnvelopedData.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "EnvelopedData.h"
#import "RecipientInfo.h"
#import "DERTaggedObject.h"
#import "BERSequence.h"

@interface EnvelopedData ()

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) OriginatorInfo *originatorInfo;
@property (nonatomic, readwrite, retain) ASN1Set *recipientInfos;
@property (nonatomic, readwrite, retain) EncryptedContentInfo *encryptedContentInfo;
@property (nonatomic, readwrite, retain) ASN1Set *unprotectedAttrs;

@end

@implementation EnvelopedData
@synthesize version = _version;
@synthesize originatorInfo = _originatorInfo;
@synthesize recipientInfos = _recipientInfos;
@synthesize encryptedContentInfo = _encryptedContentInfo;
@synthesize unprotectedAttrs = _unprotectedAttrs;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_originatorInfo) {
        [_originatorInfo release];
        _originatorInfo = nil;
    }
    if (_recipientInfos) {
        [_recipientInfos release];
        _recipientInfos = nil;
    }
    if (_encryptedContentInfo) {
        [_encryptedContentInfo release];
        _encryptedContentInfo = nil;
    }
    if (_unprotectedAttrs) {
        [_unprotectedAttrs release];
        _unprotectedAttrs = nil;
    }
    [super dealloc];
#endif
}

+ (EnvelopedData *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[EnvelopedData class]]) {
        return (EnvelopedData *)paramObject;
    }
    if (paramObject) {
        return [[[EnvelopedData alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (EnvelopedData *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [EnvelopedData getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (int)calculateVersion:(OriginatorInfo *)paramOriginatorInfo paramASN1Set1:(ASN1Set *)paramASN1Set1 paramASN1Set2:(ASN1Set *)paramASN1Set2 {
    int i;
    if (paramOriginatorInfo || paramASN1Set2) {
        i = 2;
    }else {
        i = 0;
        NSEnumerator *localEnumeration = [paramASN1Set1 getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            RecipientInfo *localRecipientInfo = [RecipientInfo getInstance:localObject];
            if ([[[localRecipientInfo getVersion] getValue] intValue] != i) {
                i = 2;
                break;
            }
        }
    }
    return i;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = 0;
        self.version = (ASN1Integer *)[paramASN1Sequence getObjectAt:i++];
        ASN1Encodable *localASN1Encodable = [paramASN1Sequence getObjectAt:i++];
        if ([localASN1Encodable isKindOfClass:[ASN1TaggedObject class]]) {
            self.originatorInfo = [OriginatorInfo getInstance:(ASN1TaggedObject *)localASN1Encodable paramBoolean:false];
            localASN1Encodable = [paramASN1Sequence getObjectAt:i++];
        }
        self.recipientInfos = [ASN1Set getInstance:localASN1Encodable];
        self.encryptedContentInfo = [EncryptedContentInfo getInstance:[paramASN1Sequence getObjectAt:i++]];
        if ([paramASN1Sequence size] > i) {
            self.unprotectedAttrs = [ASN1Set getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:i] paramBoolean:false];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamOriginatorInfo:(OriginatorInfo *)paramOriginatorInfo paramASN1Set1:(ASN1Set *)paramASN1Set1 paramEncryptedContentInfo:(EncryptedContentInfo *)paramEncryptedContentInfo paramASN1Set2:(ASN1Set *)paramASN1Set2
{
    if (self = [super init]) {
        ASN1Integer *versionInteger = [[ASN1Integer alloc] initLong:[EnvelopedData calculateVersion:paramOriginatorInfo paramASN1Set1:paramASN1Set1 paramASN1Set2:paramASN1Set2]];
        self.version = versionInteger;
        self.originatorInfo = paramOriginatorInfo;
        self.recipientInfos = paramASN1Set1;
        self.encryptedContentInfo = paramEncryptedContentInfo;
        self.unprotectedAttrs = paramASN1Set2;
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

- (instancetype)initParamOriginatorInfo:(OriginatorInfo *)paramOriginatorInfo paramASN1Set:(ASN1Set *)paramASN1Set paramEncryptedContentInfo:(EncryptedContentInfo *)paramEncryptedContentInfo paramAttributes:(Attributes *)paramAttributes
{
    self = [super init];
    if (self) {
        ASN1Integer *versionInteger = [[ASN1Integer alloc] initLong:[EnvelopedData calculateVersion:paramOriginatorInfo paramASN1Set1:paramASN1Set paramASN1Set2:[ASN1Set getInstance:paramAttributes]]];
        self.version = versionInteger;
        self.originatorInfo = paramOriginatorInfo;
        self.recipientInfos = paramASN1Set;
        self.encryptedContentInfo = paramEncryptedContentInfo;
        self.unprotectedAttrs = [ASN1Set getInstance:paramAttributes];
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

- (OriginatorInfo *)getOriginatorInfo {
    return self.originatorInfo;
}

- (ASN1Set *)getRecipientInfos {
    return self.recipientInfos;
}

- (EncryptedContentInfo *)getEncryptedContentInfo {
    return self.encryptedContentInfo;
}

- (ASN1Set *)getUnprotectedAttrs {
    return self.unprotectedAttrs;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.version];
    if (self.originatorInfo) {
        ASN1Encodable *originatorInfoEncodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:0 paramASN1Encodable:self.originatorInfo];
        [localASN1EncodableVector add:originatorInfoEncodable];
#if !__has_feature(objc_arc)
        if (originatorInfoEncodable) [originatorInfoEncodable release]; originatorInfoEncodable = nil;
#endif
    }
    [localASN1EncodableVector add:self.recipientInfos];
    [localASN1EncodableVector add:self.encryptedContentInfo];
    if (self.unprotectedAttrs) {
        ASN1Encodable *unprotectedAttrsEncodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:1 paramASN1Encodable:self.unprotectedAttrs];
        [localASN1EncodableVector add:unprotectedAttrsEncodable];
#if !__has_feature(objc_arc)
        if (unprotectedAttrsEncodable) [unprotectedAttrsEncodable release]; unprotectedAttrsEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[BERSequence alloc] initBERParamASn1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
