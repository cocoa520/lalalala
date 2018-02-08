//
//  MicrosoftObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "MicrosoftObjectIdentifiers.h"

@implementation MicrosoftObjectIdentifiers

+ (ASN1ObjectIdentifier *)microsoft {
    static ASN1ObjectIdentifier *_microsoft = nil;
    @synchronized(self) {
        if (!_microsoft) {
            _microsoft = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.311"];
        }
    }
    return _microsoft;
}

+ (ASN1ObjectIdentifier *)microsoftCertTemplateV1 {
    static ASN1ObjectIdentifier *_microsoftCertTemplateV1 = nil;
    @synchronized(self) {
        if (!_microsoftCertTemplateV1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self microsoft] branch:@"20.2"] retain];
            }
            _microsoftCertTemplateV1 = [branchObj retain];
        }
    }
    return _microsoftCertTemplateV1;
}

+ (ASN1ObjectIdentifier *)microsoftCaVersion {
    static ASN1ObjectIdentifier *_microsoftCaVersion = nil;
    @synchronized(self) {
        if (!_microsoftCaVersion) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self microsoft] branch:@"21.1"] retain];
            }
            _microsoftCaVersion = [[[self microsoft] branch:@"21.1"] retain];
        }
    }
    return _microsoftCaVersion;
}

+ (ASN1ObjectIdentifier *)microsoftPrevCaCertHash {
    static ASN1ObjectIdentifier *_microsoftPrevCaCertHash = nil;
    @synchronized(self) {
        if (!_microsoftPrevCaCertHash) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self microsoft] branch:@"21.2"] retain];
            }
            _microsoftPrevCaCertHash = [branchObj retain];
        }
    }
    return _microsoftPrevCaCertHash;
}

+ (ASN1ObjectIdentifier *)microsoftCrlNextPublish {
    static ASN1ObjectIdentifier *_microsoftCrlNextPublish = nil;
    @synchronized(self) {
        if (!_microsoftCrlNextPublish) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self microsoft] branch:@"21.4"] retain];
            }
            _microsoftCrlNextPublish = [branchObj retain];
        }
    }
    return _microsoftCrlNextPublish;
}

+ (ASN1ObjectIdentifier *)microsoftCertTemplateV2 {
    static ASN1ObjectIdentifier *_microsoftCertTemplateV2 = nil;
    @synchronized(self) {
        if (!_microsoftCertTemplateV2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self microsoft] branch:@"21.7"] retain];
            }
            _microsoftCertTemplateV2 = [branchObj retain];
        }
    }
    return _microsoftCertTemplateV2;
}

+ (ASN1ObjectIdentifier *)microsoftAppPolicies {
    static ASN1ObjectIdentifier *_microsoftAppPolicies = nil;
    @synchronized(self) {
        if (!_microsoftAppPolicies) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self microsoft] branch:@"21.10"] retain];
            }
            _microsoftAppPolicies = [[[self microsoft] branch:@"21.10"] retain];
        }
    }
    return _microsoftAppPolicies;
}

@end
