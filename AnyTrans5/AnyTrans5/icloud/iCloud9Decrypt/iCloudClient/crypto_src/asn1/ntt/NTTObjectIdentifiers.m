//
//  NTTObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "NTTObjectIdentifiers.h"

@implementation NTTObjectIdentifiers

+ (ASN1ObjectIdentifier *)id_camellia128_cbc {
    static ASN1ObjectIdentifier *_id_camellia128_cbc = nil;
    @synchronized(self) {
        if (!_id_camellia128_cbc) {
            _id_camellia128_cbc = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.392.200011.61.1.1.1.2"];
        }
    }
    return _id_camellia128_cbc;
}

+ (ASN1ObjectIdentifier *)id_camellia192_cbc {
    static ASN1ObjectIdentifier *_id_camellia192_cbc = nil;
    @synchronized(self) {
        if (!_id_camellia192_cbc) {
            _id_camellia192_cbc = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.392.200011.61.1.1.1.3"];
        }
    }
    return _id_camellia192_cbc;
}

+ (ASN1ObjectIdentifier *)id_camellia256_cbc {
    static ASN1ObjectIdentifier *_id_camellia256_cbc = nil;
    @synchronized(self) {
        if (!_id_camellia256_cbc) {
            _id_camellia256_cbc = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.392.200011.61.1.1.1.4"];
        }
    }
    return _id_camellia256_cbc;
}

+ (ASN1ObjectIdentifier *)id_camellia128_wrap {
    static ASN1ObjectIdentifier *_id_camellia128_wrap = nil;
    @synchronized(self) {
        if (!_id_camellia128_wrap) {
            _id_camellia128_wrap = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.392.200011.61.1.1.3.2"];
        }
    }
    return _id_camellia128_wrap;
}

+ (ASN1ObjectIdentifier *)id_camellia192_wrap {
    static ASN1ObjectIdentifier *_id_camellia192_wrap = nil;
    @synchronized(self) {
        if (!_id_camellia192_wrap) {
            _id_camellia192_wrap = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.392.200011.61.1.1.3.3"];
        }
    }
    return _id_camellia192_wrap;
}

+ (ASN1ObjectIdentifier *)id_camellia256_wrap {
    static ASN1ObjectIdentifier *_id_camellia256_wrap = nil;
    @synchronized(self) {
        if (!_id_camellia256_wrap) {
            _id_camellia256_wrap = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.392.200011.61.1.1.3.4"];
        }
    }
    return _id_camellia256_wrap;
}

@end
