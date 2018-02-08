//
//  SMIMECapabilityVector.m
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SMIMECapabilityVector.h"
#import "DERSequence.h"
#import "ASN1Integer.h"

@interface SMIMECapabilityVector ()

@property (nonatomic, readwrite, retain) ASN1EncodableVector *capabilities;

@end

@implementation SMIMECapabilityVector
@synthesize capabilities = _capabilities;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_capabilities) {
        [_capabilities release];
        _capabilities = nil;
    }
    [super dealloc];
#endif
}

- (void)setCapabilities:(ASN1EncodableVector *)capabilities {
    if (_capabilities != capabilities) {
        _capabilities = [[[ASN1EncodableVector alloc] init] autorelease];
    }
}

- (void)addCapability:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    ASN1Encodable *encodable = [[DERSequence alloc] initDERParamASN1Encodable:paramASN1ObjectIdentifier];
    [self.capabilities add:encodable];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
}

- (void)addCapability:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramInt:(int)paramInt {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:paramASN1ObjectIdentifier];
    ASN1Encodable *integerEncodable = [[ASN1Integer alloc] initLong:paramInt];
    [localASN1EncodableVector add:integerEncodable];
    ASN1Encodable *encodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
    [self.capabilities add:encodable];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (integerEncodable) [integerEncodable release]; integerEncodable = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
}

- (void)addCapability:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:paramASN1ObjectIdentifier];
    [localASN1EncodableVector add:paramASN1Encodable];
    ASN1Encodable *encodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
    [self.capabilities add:encodable];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
}

- (ASN1EncodableVector *)toASN1EncodableVector {
    return self.capabilities;
}

@end
