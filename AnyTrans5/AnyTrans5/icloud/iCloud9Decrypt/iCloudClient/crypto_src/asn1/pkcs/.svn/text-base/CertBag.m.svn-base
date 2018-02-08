//
//  CertBag.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertBag.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface CertBag ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *certId;
@property (nonatomic, readwrite, retain) ASN1Encodable *certValue;

@end

@implementation CertBag
@synthesize certId = _certId;
@synthesize certValue = _certValue;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_certId) {
        [_certId release];
        _certId = nil;
    }
    if (_certValue) {
        [_certValue release];
        _certValue = nil;
    }
    [super dealloc];
#endif
}

+ (CertBag *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertBag class]]) {
        return (CertBag *)paramObject;
    }
    if (paramObject) {
        return [[[CertBag alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.certId = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        self.certValue = [(DERTaggedObject *)[paramASN1Sequence getObjectAt:1] getObject];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        self.certId = paramASN1ObjectIdentifier;
        self.certValue = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getCertId {
    return self.certId;
}

- (ASN1Encodable *)getCertValue {
    return self.certValue;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.certId];
    ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamInt:0 paramASN1Encodable:self.certValue];
    [localASN1EncodableVector add:encodable];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
    return primitive;
}

@end
