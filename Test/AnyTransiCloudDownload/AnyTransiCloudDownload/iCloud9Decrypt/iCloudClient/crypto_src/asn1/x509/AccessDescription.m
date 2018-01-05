//
//  AccessDescription.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AccessDescription.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@implementation AccessDescription
@synthesize accessMethod = _accessMethod;
@synthesize accessLocation = _accessLocation;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_accessMethod) {
        [_accessMethod release];
        _accessMethod = nil;
    }
    if (_accessLocation) {
        [_accessLocation release];
        _accessLocation = nil;
    }
    [super dealloc];
#endif
}

+ (ASN1ObjectIdentifier *)id_ad_caIssuers {
    static ASN1ObjectIdentifier *_id_ad_caIssuers = nil;
    @synchronized(self) {
        if (!_id_ad_caIssuers) {
            _id_ad_caIssuers = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.48.2"];
        }
    }
    return _id_ad_caIssuers;
}

+ (ASN1ObjectIdentifier *)id_ad_ocsp {
    static ASN1ObjectIdentifier *_id_ad_ocsp = nil;
    @synchronized(self) {
        if (!_id_ad_ocsp) {
            _id_ad_ocsp = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.48.1"];
        }
    }
    return _id_ad_ocsp;
}

+ (AccessDescription *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[AccessDescription class]]) {
        return (AccessDescription *)paramObject;
    }
    if (paramObject) {
        return [[[AccessDescription alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"wrong number of elements in sequence" userInfo:nil];
        }
        self.accessMethod = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        self.accessLocation = [GeneralName getInstance:[paramASN1Sequence getObjectAt:1]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramGeneralName:(GeneralName *)paramGeneralName
{
    if (self = [super init]) {
        self.accessMethod = paramASN1ObjectIdentifier;
        self.accessLocation = paramGeneralName;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getAccessMethod {
    return self.accessMethod;
}

- (GeneralName *)getAccessLocation {
    return self.accessLocation;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.accessMethod];
    [localASN1EncodableVector add:self.accessLocation];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"AccessDescription: Oid(%@)", [self.accessMethod getId]];
}

@end
