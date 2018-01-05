//
//  CRLBag.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CRLBag.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface CRLBag ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *crlId;
@property (nonatomic, readwrite, retain) ASN1Encodable *crlValue;

@end

@implementation CRLBag
@synthesize crlId = _crlId;
@synthesize crlValue = _crlValue;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_crlId) {
        [_crlId release];
        _crlId = nil;
    }
    if (_crlValue) {
        [_crlValue release];
        _crlValue = nil;
    }
    [super dealloc];
#endif
}

+ (CRLBag *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CRLBag class]]) {
        return (CRLBag *)paramObject;
    }
    if (paramObject) {
        return [[[CRLBag alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.crlId = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        self.crlValue = [(DERTaggedObject *)[paramASN1Sequence getObjectAt:1] getObject];
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
        self.crlId = paramASN1ObjectIdentifier;
        self.crlValue = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getCrlId {
    return self.crlId;
}

- (ASN1Encodable *)getCrlValue {
    return self.crlValue;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.crlId];
    ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamInt:0 paramASN1Encodable:self.crlValue];
    [localASN1EncodableVector add:encodable];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
    return primitive;
}

@end
