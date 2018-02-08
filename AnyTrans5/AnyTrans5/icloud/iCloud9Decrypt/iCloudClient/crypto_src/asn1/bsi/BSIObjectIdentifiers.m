//
//  BSIObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BSIObjectIdentifiers.h"

@implementation BSIObjectIdentifiers

+ (ASN1ObjectIdentifier *)bsi_de {
    static ASN1ObjectIdentifier *_bsi_de = nil;
    @synchronized(self) {
        if (!_bsi_de) {
            _bsi_de = [[ASN1ObjectIdentifier alloc] initParamString:@"0.4.0.127.0.7"];
        }
    }
    return _bsi_de;
}

+ (ASN1ObjectIdentifier *)id_ecc {
    static ASN1ObjectIdentifier *_id_ecc = nil;
    @synchronized(self) {
        if (!_id_ecc) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bsi_de] branch:@"1.1"] retain];
            }
            _id_ecc = [branchObj retain];
        }
    }
    return _id_ecc;
}

+ (ASN1ObjectIdentifier *)ecdsa_plain_signatures {
    static ASN1ObjectIdentifier *_ecdsa_plain_signatures = nil;
    @synchronized(self) {
        if (!_ecdsa_plain_signatures) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_ecc] branch:@"4.1"] retain];
            }
            _ecdsa_plain_signatures = [branchObj retain];
        }
    }
    return _ecdsa_plain_signatures;
}

+ (ASN1ObjectIdentifier *)ecdsa_plain_SHA1 {
    static ASN1ObjectIdentifier *_ecdsa_plain_SHA1 = nil;
    @synchronized(self) {
        if (!_ecdsa_plain_SHA1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ecdsa_plain_signatures] branch:@"1"] retain];
            }
            _ecdsa_plain_SHA1 = [branchObj retain];
        }
    }
    return _ecdsa_plain_SHA1;
}

+ (ASN1ObjectIdentifier *)ecdsa_plain_SHA224 {
    static ASN1ObjectIdentifier *_ecdsa_plain_SHA224 = nil;
    @synchronized(self) {
        if (!_ecdsa_plain_SHA224) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ecdsa_plain_signatures] branch:@"2"] retain];
            }
            _ecdsa_plain_SHA224 = [branchObj retain];
        }
    }
    return _ecdsa_plain_SHA224;
}

+ (ASN1ObjectIdentifier *)ecdsa_plain_SHA256 {
    static ASN1ObjectIdentifier *_ecdsa_plain_SHA256 = nil;
    @synchronized(self) {
        if (!_ecdsa_plain_SHA256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ecdsa_plain_signatures] branch:@"3"] retain];
            }
            _ecdsa_plain_SHA256 = [branchObj retain];
        }
    }
    return _ecdsa_plain_SHA256;
}

+ (ASN1ObjectIdentifier *)ecdsa_plain_SHA384 {
    static ASN1ObjectIdentifier *_ecdsa_plain_SHA384 = nil;
    @synchronized(self) {
        if (!_ecdsa_plain_SHA384) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ecdsa_plain_signatures] branch:@"4"] retain];
            }
            _ecdsa_plain_SHA384 = [branchObj retain];
        }
    }
    return _ecdsa_plain_SHA384;
}

+ (ASN1ObjectIdentifier *)ecdsa_plain_SHA512 {
    static ASN1ObjectIdentifier *_ecdsa_plain_SHA512 = nil;
    @synchronized(self) {
        if (!_ecdsa_plain_SHA512) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ecdsa_plain_signatures] branch:@"5"] retain];
            }
            _ecdsa_plain_SHA512 = [branchObj retain];
        }
    }
    return _ecdsa_plain_SHA512;
}

+ (ASN1ObjectIdentifier *)ecdsa_plain_RIPEMD160 {
    static ASN1ObjectIdentifier *_ecdsa_plain_RIPEMD160 = nil;
    @synchronized(self) {
        if (!_ecdsa_plain_RIPEMD160) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ecdsa_plain_signatures] branch:@"6"] retain];
            }
            _ecdsa_plain_RIPEMD160 = [branchObj retain];
        }
    }
    return _ecdsa_plain_RIPEMD160;
}

@end
