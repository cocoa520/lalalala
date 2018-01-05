//
//  CertificationRequestInfo.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertificationRequestInfo.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@implementation CertificationRequestInfo
@synthesize version = _version;
@synthesize subject = _subject;
@synthesize subjectPKInfo = _subjectPKInfo;
@synthesize attributes = _attributes;

+ (CertificationRequestInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertificationRequestInfo class]]) {
        return (CertificationRequestInfo *)paramObject;
    }
    if (paramObject) {
        return [[[CertificationRequestInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.version = (ASN1Integer *)[paramASN1Sequence getObjectAt:0];
        self.subject = [X500Name getInstance:[paramASN1Sequence getObjectAt:1]];
        self.subjectPKInfo = [SubjectPublicKeyInfo getInstance:[paramASN1Sequence getObjectAt:2]];
        if ([paramASN1Sequence size] > 3) {
            DERTaggedObject *localDERTaggedObject = (DERTaggedObject *)[paramASN1Sequence getObjectAt:3];
            self.attributes = [ASN1Set getInstance:localDERTaggedObject paramBoolean:false];
        }
        if (!self.subject || !self.version || !self.subjectPKInfo) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"Not all mandatory fields set in CertificationRequestInfo generator." userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamX500Name:(X500Name *)paramX500Name paramSubjectPublicKeyInfo:(SubjectPublicKeyInfo *)paramSubjectPublicKeyInfo paramASN1Set:(ASN1Set *)paramASN1Set
{
    if (self = [super init]) {
        self.subject = paramX500Name;
        self.subjectPKInfo = paramSubjectPublicKeyInfo;
        self.attributes = paramASN1Set;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamX509Name:(X509Name *)paramX509Name paramSubjectPublicKeyInfo:(SubjectPublicKeyInfo *)paramSubjectPublicKeyInfo paramASN1Set:(ASN1Set *)paramASN1Set
{
    if (self = [super init]) {
        if (!paramX509Name || !paramSubjectPublicKeyInfo) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"Not all mandatory fields set in CertificationRequestInfo generator." userInfo:nil];
        }
        self.subject = [X500Name getInstance:[paramX509Name toASN1Primitive]];
        self.subjectPKInfo = paramSubjectPublicKeyInfo;
        self.attributes = paramASN1Set;
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
    [self setSubject:nil];
    [self setSubjectPKInfo:nil];
    [self setAttributes:nil];
    [super dealloc];
}

- (ASN1Integer *)getVersion {
    return self.version;
}

- (X500Name *)getSubject {
    return self.subject;
}

- (SubjectPublicKeyInfo *)getSubjectPublicKeyInfo {
    return self.subjectPKInfo;
}

- (ASN1Set *)getAttributes {
    return self.attributes;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.version];
    [localASN1EncodableVector add:self.subject];
    [localASN1EncodableVector add:self.subjectPKInfo];
    if (self.attributes) {
        ASN1Encodable *attributesEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:self.attributes];
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
