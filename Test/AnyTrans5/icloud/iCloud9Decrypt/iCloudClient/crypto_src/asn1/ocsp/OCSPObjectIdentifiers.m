//
//  OCSPObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OCSPObjectIdentifiers.h"

@implementation OCSPObjectIdentifiers

+ (ASN1ObjectIdentifier *)id_pkix_ocsp {
    static ASN1ObjectIdentifier *_id_pkix_ocsp = nil;
    @synchronized(self) {
        if (!_id_pkix_ocsp) {
            _id_pkix_ocsp = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.48.1"];
        }
    }
    return _id_pkix_ocsp;
}

+ (ASN1ObjectIdentifier *)id_pkix_ocsp_basic {
    static ASN1ObjectIdentifier *_id_pkix_ocsp_basic = nil;
    @synchronized(self) {
        if (!_id_pkix_ocsp_basic) {
            _id_pkix_ocsp_basic = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.48.1.1"];
        }
    }
    return _id_pkix_ocsp_basic;
}

+ (ASN1ObjectIdentifier *)id_pkix_ocsp_nonce {
    static ASN1ObjectIdentifier *_id_pkix_ocsp_nonce = nil;
    @synchronized(self) {
        if (!_id_pkix_ocsp_nonce) {
            _id_pkix_ocsp_nonce = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.48.1.2"];
        }
    }
    return _id_pkix_ocsp_nonce;
}

+ (ASN1ObjectIdentifier *)id_pkix_ocsp_crl {
    static ASN1ObjectIdentifier *_id_pkix_ocsp_crl = nil;
    @synchronized(self) {
        if (!_id_pkix_ocsp_crl) {
            _id_pkix_ocsp_crl = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.48.1.3"];
        }
    }
    return _id_pkix_ocsp_crl;
}

+ (ASN1ObjectIdentifier *)id_pkix_ocsp_response {
    static ASN1ObjectIdentifier *_id_pkix_ocsp_response = nil;
    @synchronized(self) {
        if (!_id_pkix_ocsp_response) {
            _id_pkix_ocsp_response = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.48.1.4"];
        }
    }
    return _id_pkix_ocsp_response;
}

+ (ASN1ObjectIdentifier *)id_pkix_ocsp_nocheck {
    static ASN1ObjectIdentifier *_id_pkix_ocsp_nocheck = nil;
    @synchronized(self) {
        if (!_id_pkix_ocsp_nocheck) {
            _id_pkix_ocsp_nocheck = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.48.1.5"];
        }
    }
    return _id_pkix_ocsp_nocheck;
}

+ (ASN1ObjectIdentifier *)id_pkix_ocsp_archive_cutoff {
    static ASN1ObjectIdentifier *_id_pkix_ocsp_archive_cutoff = nil;
    @synchronized(self) {
        if (!_id_pkix_ocsp_archive_cutoff) {
            _id_pkix_ocsp_archive_cutoff = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.48.1.6"];
        }
    }
    return _id_pkix_ocsp_archive_cutoff;
}

+ (ASN1ObjectIdentifier *)id_pkix_ocsp_service_locator {
    static ASN1ObjectIdentifier *_id_pkix_ocsp_service_locator = nil;
    @synchronized(self) {
        if (!_id_pkix_ocsp_service_locator) {
            _id_pkix_ocsp_service_locator = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.48.1.7"];
        }
    }
    return _id_pkix_ocsp_service_locator;
}

+ (ASN1ObjectIdentifier *)id_pkix_ocsp_pref_sig_algs {
    static ASN1ObjectIdentifier *_id_pkix_ocsp_pref_sig_algs = nil;
    @synchronized(self) {
        if (!_id_pkix_ocsp_pref_sig_algs) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_pkix_ocsp] branch:@"8"] retain];
            }
            _id_pkix_ocsp_pref_sig_algs = [branchObj retain];
        }
    }
    return _id_pkix_ocsp_pref_sig_algs;
}

+ (ASN1ObjectIdentifier *)id_pkix_ocsp_extended_revoke {
    static ASN1ObjectIdentifier *_id_pkix_ocsp_extended_revoke = nil;
    @synchronized(self) {
        if (!_id_pkix_ocsp_extended_revoke) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_pkix_ocsp] branch:@"9"] retain];
            }
            _id_pkix_ocsp_extended_revoke = [branchObj retain];
        }
    }
    return _id_pkix_ocsp_extended_revoke;
}

@end
