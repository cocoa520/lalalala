//
//  SignedData.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SignedData.h"
#import "DERTaggedObject.h"
#import "BERSequence.h"

@interface SignedData ()

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) ASN1Set *digestAlgorithm;
@property (nonatomic, readwrite, retain) ContentInfoPKCS *contentInfo;
@property (nonatomic, readwrite, retain) ASN1Set *certificates;
@property (nonatomic, readwrite, retain) ASN1Set *crls;
@property (nonatomic, readwrite, retain) ASN1Set *signerInfos;

@end

@implementation SignedData
@synthesize version = _version;
@synthesize digestAlgorithm = _digestAlgorithm;
@synthesize contentInfo = _contentInfo;
@synthesize certificates = _certificates;
@synthesize crls = _crls;
@synthesize signerInfos = _signerInfos;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_digestAlgorithm) {
        [_digestAlgorithm release];
        _digestAlgorithm = nil;
    }
    if (_contentInfo) {
        [_contentInfo release];
        _contentInfo = nil;
    }
    if (_certificates) {
        [_certificates release];
        _certificates = nil;
    }
    if (_crls) {
        [_crls release];
        _crls = nil;
    }
    if (_signerInfos) {
        [_signerInfos release];
        _signerInfos = nil;
    }
    [super dealloc];
#endif
}

+ (SignedData *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SignedData class]]) {
        return (SignedData *)paramObject;
    }
    if (paramObject) {
        return [[[SignedData alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.version = (ASN1Integer *)[localEnumeration nextObject];
        self.digestAlgorithm = (ASN1Set *)[localEnumeration nextObject];
        self.contentInfo = [ContentInfoPKCS getInstance:[localEnumeration nextObject]];
        ASN1Primitive *localASN1Primitive = nil;
        while (localASN1Primitive = [localEnumeration nextObject]) {
            if ([localASN1Primitive isKindOfClass:[ASN1TaggedObject class]]) {
                ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)localASN1Primitive;
                switch ([localASN1TaggedObject getTagNo]) {
                    case 0:
                        self.certificates = [ASN1Set getInstance:localASN1TaggedObject paramBoolean:NO];
                        break;
                    case 1:
                        self.crls = [ASN1Set getInstance:localASN1TaggedObject paramBoolean:NO];
                        break;
                    default:
                        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown tag value %d", [localASN1TaggedObject getTagNo]] userInfo:nil];
                        break;
                }
            }else {
                self.signerInfos = (ASN1Set *)localASN1Primitive;
            }
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer paramASN1Set1:(ASN1Set *)paramASN1Set1 paramContentInfo:(ContentInfoPKCS *)paramContentInfo paramASN1Set2:(ASN1Set *)paramASN1Set2 paramASN1Set3:(ASN1Set *)paramASN1Set3 paramASN1Set4:(ASN1Set *)paramASN1Set4
{
    if (self = [super init]) {
        self.version = paramASN1Integer;
        self.digestAlgorithm = paramASN1Set1;
        self.contentInfo = paramContentInfo;
        self.certificates = paramASN1Set2;
        self.crls = paramASN1Set3;
        self.signerInfos = paramASN1Set4;
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

- (ASN1Set *)getDigestAlgorithms {
    return self.digestAlgorithm;
}

- (ContentInfoPKCS *)getContentInfo {
    return self.contentInfo;
}

- (ASN1Set *)getCertificates {
    return self.certificates;
}

- (ASN1Set *)getCRLs {
    return self.crls;
}

- (ASN1Set *)getSignerInfos {
    return self.signerInfos;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.version];
    [localASN1EncodableVector add:self.digestAlgorithm];
    [localASN1EncodableVector add:self.contentInfo];
    if (self.certificates) {
        ASN1Encodable *certEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:self.certificates];
        [localASN1EncodableVector add:certEncodable];
#if !__has_feature(objc_arc)
        if (certEncodable) [certEncodable release]; certEncodable = nil;
#endif
    }
    if (self.crls) {
        ASN1Encodable *crlsEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:self.crls];
        [localASN1EncodableVector add:crlsEncodable];
#if !__has_feature(objc_arc)
        if (crlsEncodable) [crlsEncodable release]; crlsEncodable = nil;
#endif
    }
    [localASN1EncodableVector add:self.signerInfos];
    ASN1Primitive *primitive = [[[BERSequence alloc] initBERParamASn1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
