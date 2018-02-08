//
//  DVCSObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DVCSObjectIdentifiers.h"

@implementation DVCSObjectIdentifiers

+ (ASN1ObjectIdentifier *)id_pkix {
    static ASN1ObjectIdentifier *_id_pkix = nil;
    @synchronized(self) {
        if (!_id_pkix) {
            _id_pkix = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7"];
        }
    }
    return _id_pkix;
}

+ (ASN1ObjectIdentifier *)id_smime {
    static ASN1ObjectIdentifier *_id_smime = nil;
    @synchronized(self) {
        if (!_id_smime) {
            _id_smime = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.9.16"];
        }
    }
    return _id_smime;
}

+ (ASN1ObjectIdentifier *)id_ad_dvcs {
    static ASN1ObjectIdentifier *_id_ad_dvcs = nil;
    @synchronized(self) {
        if (!_id_ad_dvcs) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_pkix] branch:@"48.4"] retain];
            }
            _id_ad_dvcs = [branchObj retain];
        }
    }
    return _id_ad_dvcs;
}

+ (ASN1ObjectIdentifier *)id_kp_dvcs {
    static ASN1ObjectIdentifier *_id_kp_dvcs = nil;
    @synchronized(self) {
        if (!_id_kp_dvcs) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_pkix] branch:@"3.10"] retain];
            }
            _id_kp_dvcs = [branchObj retain];
        }
    }
    return _id_kp_dvcs;
}

+ (ASN1ObjectIdentifier *)id_ct_DVCSRequestData {
    static ASN1ObjectIdentifier *_id_ct_DVCSRequestData = nil;
    @synchronized(self) {
        if (!_id_ct_DVCSRequestData) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_smime] branch:@"1.7"] retain];
            }
            _id_ct_DVCSRequestData = [branchObj retain];
        }
    }
    return _id_ct_DVCSRequestData;
}

+ (ASN1ObjectIdentifier *)id_ct_DVCSResponseData {
    static ASN1ObjectIdentifier *_id_ct_DVCSResponseData = nil;
    @synchronized(self) {
        if (!_id_ct_DVCSResponseData) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_smime] branch:@"1.8"] retain];
            }
            _id_ct_DVCSResponseData = [branchObj retain];
        }
    }
    return _id_ct_DVCSResponseData;
}

+ (ASN1ObjectIdentifier *)id_aa_dvcs_dvc {
    static ASN1ObjectIdentifier *_id_aa_dvcs_dvc = nil;
    @synchronized(self) {
        if (!_id_aa_dvcs_dvc) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_smime] branch:@"2.29"] retain];
            }
            _id_aa_dvcs_dvc = [branchObj retain];
        }
    }
    return _id_aa_dvcs_dvc;
}

@end
