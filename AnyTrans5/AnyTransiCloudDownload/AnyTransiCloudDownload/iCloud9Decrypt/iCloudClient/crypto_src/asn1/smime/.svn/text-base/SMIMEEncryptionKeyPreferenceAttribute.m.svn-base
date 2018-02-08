//
//  SMIMEEncryptionKeyPreferenceAttribute.m
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SMIMEEncryptionKeyPreferenceAttribute.h"
#import "DERSet.h"
#import "DERTaggedObject.h"
#import "SMIMEAttributes.h"

@implementation SMIMEEncryptionKeyPreferenceAttribute

- (instancetype)initParamIssuerAndSerialNumber:(IssuerAndSerialNumber *)paramIssuerAndSerialNumber
{
    ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:paramIssuerAndSerialNumber];
    ASN1Set *set = [[[DERSet alloc] initDERParamASN1Encodable:encodable] autorelease];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
    if (self = [super initParamASN1ObjectIdentifier:[SMIMEAttributes encrypKeyPref] paramASN1Set:set]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamRecipientKeyIdentifier:(RecipientKeyIdentifier *)paramRecipientKeyIdentifier
{
    ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:paramRecipientKeyIdentifier];
    ASN1Set *set = [[[DERSet alloc] initDERParamASN1Encodable:encodable] autorelease];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
    if (self = [super initParamASN1ObjectIdentifier:[SMIMEAttributes encrypKeyPref] paramASN1Set:set]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:2 paramASN1Encodable:paramASN1OctetString];
    ASN1Set *set = [[[DERSet alloc] initDERParamASN1Encodable:encodable] autorelease];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
    if (self = [super initParamASN1ObjectIdentifier:[SMIMEAttributes encrypKeyPref] paramASN1Set:set]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

@end
