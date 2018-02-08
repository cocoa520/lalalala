//
//  SMIMECapabilitiesAttribute.m
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SMIMECapabilitiesAttribute.h"
#import "SMIMEAttributes.h"
#import "DERSet.h"

@implementation SMIMECapabilitiesAttribute

- (instancetype)initParamSMIMECapabilityVector:(SMIMECapabilityVector *)paramSMIMECapabilityVector
{
    ASN1Set *set = [[DERSet alloc] initDERParamASN1EncodableVector:[paramSMIMECapabilityVector toASN1EncodableVector]];
    if (self = [super initParamASN1ObjectIdentifier:[SMIMEAttributes smimeCapabilities] paramASN1Set:set]) {
#if !__has_feature(objc_arc)
        if (set) [set release]; set = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        if (set) [set release]; set = nil;
        [self release];
#endif
        return nil;
    }
}

@end
