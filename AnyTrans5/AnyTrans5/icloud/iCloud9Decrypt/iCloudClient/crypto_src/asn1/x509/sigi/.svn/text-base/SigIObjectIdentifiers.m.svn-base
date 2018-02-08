//
//  SigIObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SigIObjectIdentifiers.h"

@implementation SigIObjectIdentifiers

+ (ASN1ObjectIdentifier *)id_sigi {
    static ASN1ObjectIdentifier *_id_sigi = nil;
    @synchronized(self) {
        if (!_id_sigi) {
            _id_sigi = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.36.8"];
        }
    }
    return _id_sigi;
}

+ (ASN1ObjectIdentifier *)id_sigi_kp {
    static ASN1ObjectIdentifier *_id_sigi_kp = nil;
    @synchronized(self) {
        if (!_id_sigi_kp) {
            _id_sigi_kp = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.36.8.2"];
        }
    }
    return _id_sigi_kp;
}

+ (ASN1ObjectIdentifier *)id_sigi_cp {
    static ASN1ObjectIdentifier *_id_sigi_cp = nil;
    @synchronized(self) {
        if (!_id_sigi_cp) {
            _id_sigi_cp = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.36.8.1"];
        }
    }
    return _id_sigi_cp;
}

+ (ASN1ObjectIdentifier *)id_sigi_on {
    static ASN1ObjectIdentifier *_id_sigi_on = nil;
    @synchronized(self) {
        if (!_id_sigi_on) {
            _id_sigi_on = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.36.8.4"];
        }
    }
    return _id_sigi_on;
}

+ (ASN1ObjectIdentifier *)id_sigi_kp_directoryService {
    static ASN1ObjectIdentifier *_id_sigi_kp_directoryService = nil;
    @synchronized(self) {
        if (!_id_sigi_kp_directoryService) {
            _id_sigi_kp_directoryService = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.36.8.2.1"];
        }
    }
    return _id_sigi_kp_directoryService;
}

+ (ASN1ObjectIdentifier *)id_sigi_on_personalData {
    static ASN1ObjectIdentifier *_id_sigi_on_personalData = nil;
    @synchronized(self) {
        if (!_id_sigi_on_personalData) {
            _id_sigi_on_personalData = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.36.8.4.1"];
        }
    }
    return _id_sigi_on_personalData;
}

+ (ASN1ObjectIdentifier *)id_sigi_cp_sigconform {
    static ASN1ObjectIdentifier *_id_sigi_cp_sigconform = nil;
    @synchronized(self) {
        if (!_id_sigi_cp_sigconform) {
            _id_sigi_cp_sigconform = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.36.8.1.1"];
        }
    }
    return _id_sigi_cp_sigconform;
}

@end
