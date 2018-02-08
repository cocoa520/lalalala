//
//  OtherInfo.m
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OtherInfo.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"

@interface OtherInfo ()

@property (nonatomic, readwrite, retain) KeySpecificInfo *keyInfo;
@property (nonatomic, readwrite, retain) ASN1OctetString *partyAInfo;
@property (nonatomic, readwrite, retain) ASN1OctetString *suppPubInfo;

@end

@implementation OtherInfo
@synthesize keyInfo = _keyInfo;
@synthesize partyAInfo = _partyAInfo;
@synthesize suppPubInfo = _suppPubInfo;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_keyInfo) {
        [_keyInfo release];
        _keyInfo = nil;
    }
    if (_partyAInfo) {
        [_partyAInfo release];
        _partyAInfo = nil;
    }
    if (_suppPubInfo) {
        [_suppPubInfo release];
        _suppPubInfo = nil;
    }
    [super dealloc];
#endif
}

+ (OtherInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OtherInfo class]]) {
        return (OtherInfo *)paramObject;
    }
    if (paramObject) {
        return [[[OtherInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamKeySpecificInfo:(KeySpecificInfo *)paramKeySpecificInfo paramASN1OctetString1:(ASN1OctetString *)paramASN1OctetString1 paramASN1OctetString2:(ASN1OctetString *)paramASN1OctetString2
{
    if (self = [super init]) {
        self.keyInfo = paramKeySpecificInfo;
        self.partyAInfo = paramASN1OctetString1;
        self.suppPubInfo = paramASN1OctetString2;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.keyInfo = [KeySpecificInfo getInstance:localEnumeration.nextObject];
        DERTaggedObject *localDERTaggedObject = nil;
        while (localDERTaggedObject = [localEnumeration nextObject]) {
            if (localDERTaggedObject.tagNO == 0) {
                self.partyAInfo = (ASN1OctetString *)[localDERTaggedObject getObject];
            }else if (localDERTaggedObject.tagNO == 2) {
                self.suppPubInfo = (ASN1OctetString *)[localDERTaggedObject getObject];
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

- (KeySpecificInfo *)getKeyInfo {
    return self.keyInfo;
}

- (ASN1OctetString *)getPartyAInfo {
    return self.partyAInfo;
}

- (ASN1OctetString *)getSuppPubInfo {
    return self.suppPubInfo;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.keyInfo];
    if (self.partyAInfo) {
        ASN1Encodable *infoEncodable = [[DERTaggedObject alloc] initParamInt:0 paramASN1Encodable:self.partyAInfo];
        [localASN1EncodableVector add:infoEncodable];
#if !__has_feature(objc_arc)
        if (infoEncodable) [infoEncodable release]; infoEncodable = nil;
#endif
    }
    ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamInt:2 paramASN1Encodable:self.suppPubInfo];
    [localASN1EncodableVector add:encodable];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
    return primitive;
}

@end
