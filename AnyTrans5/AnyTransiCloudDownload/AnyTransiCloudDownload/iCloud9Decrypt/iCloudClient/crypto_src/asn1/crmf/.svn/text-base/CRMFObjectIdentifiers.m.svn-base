//
//  CRMFObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CRMFObjectIdentifiers.h"
#import "PKCSObjectIdentifiers.h"

@implementation CRMFObjectIdentifiers

+ (ASN1ObjectIdentifier *)id_pkix {
    static ASN1ObjectIdentifier *_id_pkix = nil;
    @synchronized(self) {
        if (!_id_pkix) {
            _id_pkix = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7"];
        }
    }
    return _id_pkix;
}

+ (ASN1ObjectIdentifier *)id_pkip {
    static ASN1ObjectIdentifier *_id_pkip = nil;
    @synchronized(self) {
        if (!_id_pkip) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_pkix] branch:@"5"] retain];
            }
            _id_pkip = [branchObj retain];
        }
    }
    return _id_pkip;
}

+ (ASN1ObjectIdentifier *)id_regCtrl {
    static ASN1ObjectIdentifier *_id_regCtrl = nil;
    @synchronized(self) {
        if (!_id_regCtrl) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_pkip] branch:@"1"] retain];
            }
            _id_regCtrl = [branchObj retain];
        }
    }
    return _id_regCtrl;
}

+ (ASN1ObjectIdentifier *)id_regCtrl_regToken {
    static ASN1ObjectIdentifier *_id_regCtrl_regToken = nil;
    @synchronized(self) {
        if (!_id_regCtrl_regToken) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_regCtrl] branch:@"1"] retain];
            }
            _id_regCtrl_regToken = [branchObj retain];
        }
    }
    return _id_regCtrl_regToken;
}

+ (ASN1ObjectIdentifier *)id_regCtrl_authenticator {
    static ASN1ObjectIdentifier *_id_regCtrl_authenticator = nil;
    @synchronized(self) {
        if (!_id_regCtrl_authenticator) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_regCtrl] branch:@"2"] retain];
            }
            _id_regCtrl_authenticator = [branchObj retain];
        }
    }
    return _id_regCtrl_authenticator;
}

+ (ASN1ObjectIdentifier *)id_regCtrl_pkiPublicationInfo {
    static ASN1ObjectIdentifier *_id_regCtrl_pkiPublicationInfo = nil;
    @synchronized(self) {
        if (!_id_regCtrl_pkiPublicationInfo) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_regCtrl] branch:@"3"] retain];
            }
            _id_regCtrl_pkiPublicationInfo = [branchObj retain];
        }
    }
    return _id_regCtrl_pkiPublicationInfo;
}

+ (ASN1ObjectIdentifier *)id_regCtrl_pkiArchiveOptions {
    static ASN1ObjectIdentifier *_id_regCtrl_pkiArchiveOptions = nil;
    @synchronized(self) {
        if (!_id_regCtrl_pkiArchiveOptions) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_regCtrl] branch:@"4"] retain];
            }
            _id_regCtrl_pkiArchiveOptions = [branchObj retain];
        }
    }
    return _id_regCtrl_pkiArchiveOptions;
}

+ (ASN1ObjectIdentifier *)id_ct_encKeyWithID {
    static ASN1ObjectIdentifier *_id_ct_encKeyWithID = nil;
    @synchronized(self) {
        if (!_id_ct_encKeyWithID) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[PKCSObjectIdentifiers id_ct] branch:@"21"] retain];
            }
            _id_ct_encKeyWithID = [branchObj retain];
        }
    }
    return _id_ct_encKeyWithID;
}

@end
