//
//  ISOIECObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ISOIECObjectIdentifiers.h"

@implementation ISOIECObjectIdentifiers

+ (ASN1ObjectIdentifier *)iso_encryption_algorithms {
    static ASN1ObjectIdentifier *_iso_encryption_algorithms = nil;
    @synchronized(self) {
        if (!_iso_encryption_algorithms) {
            _iso_encryption_algorithms = [[ASN1ObjectIdentifier alloc] initParamString:@"1.0.10118"];
        }
    }
    return _iso_encryption_algorithms;
}

+ (ASN1ObjectIdentifier *)hash_algorithms {
    static ASN1ObjectIdentifier *_hash_algorithms = nil;
    @synchronized(self) {
        if (!_hash_algorithms) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self iso_encryption_algorithms] branch:@"3.0"] retain];
            }
            _hash_algorithms = [branchObj retain];
        }
    }
    return _hash_algorithms;
}

+ (ASN1ObjectIdentifier *)ripemd160 {
    static ASN1ObjectIdentifier *_ripemd160 = nil;
    @synchronized(self) {
        if (!_ripemd160) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hash_algorithms] branch:@"49"] retain];
            }
            _ripemd160 = [branchObj retain];
        }
    }
    return _ripemd160;
}

+ (ASN1ObjectIdentifier *)ripemd128 {
    static ASN1ObjectIdentifier *_ripemd128 = nil;
    @synchronized(self) {
        if (!_ripemd128) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hash_algorithms] branch:@"50"] retain];
            }
            _ripemd128 = [branchObj retain];
        }
    }
    return _ripemd128;
}

+ (ASN1ObjectIdentifier *)whirlpool {
    static ASN1ObjectIdentifier *_whirlpool = nil;
    @synchronized(self) {
        if (!_whirlpool) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hash_algorithms] branch:@"55"] retain];
            }
            _whirlpool = [branchObj retain];
        }
    }
    return _whirlpool;
}

+ (ASN1ObjectIdentifier *)is18033_2 {
    static ASN1ObjectIdentifier *_is18033_2 = nil;
    @synchronized(self) {
        if (!_is18033_2) {
            _is18033_2 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.0.18033.2"];
        }
    }
    return _is18033_2;
}

+ (ASN1ObjectIdentifier *)id_ac_generic_hybrid {
    static ASN1ObjectIdentifier *_id_ac_generic_hybrid = nil;
    @synchronized(self) {
        if (!_id_ac_generic_hybrid) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self is18033_2] branch:@"1.2"] retain];
            }
            _id_ac_generic_hybrid = [branchObj retain];
        }
    }
    return _id_ac_generic_hybrid;
}

+ (ASN1ObjectIdentifier *)id_kem_rsa {
    static ASN1ObjectIdentifier *_id_kem_rsa = nil;
    @synchronized(self) {
        if (!_id_kem_rsa) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self is18033_2] branch:@"2.4"] retain];
            }
            _id_kem_rsa = [branchObj retain];
        }
    }
    return _id_kem_rsa;
}

@end
