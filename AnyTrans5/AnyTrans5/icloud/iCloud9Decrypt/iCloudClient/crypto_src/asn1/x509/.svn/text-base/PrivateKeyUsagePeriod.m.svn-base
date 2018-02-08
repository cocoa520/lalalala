//
//  PrivateKeyUsagePeriod.m
//  crypto
//
//  Created by JGehry on 7/12/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PrivateKeyUsagePeriod.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"

@interface PrivateKeyUsagePeriod ()

@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *notBefore;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *notAfter;

@end

@implementation PrivateKeyUsagePeriod
@synthesize notBefore = _notBefore;
@synthesize notAfter = _notAfter;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_notBefore) {
        [_notBefore release];
        _notBefore = nil;
    }
    if (_notAfter) {
        [_notAfter release];
        _notAfter = nil;
    }
    [super dealloc];
#endif
}

+ (PrivateKeyUsagePeriod *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PrivateKeyUsagePeriod class]]) {
        return (PrivateKeyUsagePeriod *)paramObject;
    }
    if (paramObject) {
        return [[[PrivateKeyUsagePeriod alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        ASN1TaggedObject *localASN1TaggedObject = nil;
        while (localASN1TaggedObject = [localEnumeration nextObject]) {
            if ([localASN1TaggedObject getTagNo] == 0) {
                self.notBefore = [ASN1GeneralizedTime getInstance:localASN1TaggedObject paramBoolean:NO];
            }else if ([localASN1TaggedObject getTagNo] == 1) {
                self.notAfter = [ASN1GeneralizedTime getInstance:localASN1TaggedObject paramBoolean:NO];
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

- (ASN1GeneralizedTime *)getNotBefore {
    return self.notBefore;
}

- (ASN1GeneralizedTime *)getNotAfter {
    return self.notAfter;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.notBefore) {
        ASN1Encodable *beforeEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:self.notBefore];
        [localASN1EncodableVector add:beforeEncodable];
#if !__has_feature(objc_arc)
        if (beforeEncodable) [beforeEncodable release]; beforeEncodable = nil;
#endif
    }
    if (self.notAfter) {
        ASN1Encodable *afterEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:self.notAfter];
        [localASN1EncodableVector add:afterEncodable];
#if !__has_feature(objc_arc)
        if (afterEncodable) [afterEncodable release]; afterEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
