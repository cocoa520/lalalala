//
//  UAObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "UAObjectIdentifiers.h"

@implementation UAObjectIdentifiers

+ (ASN1ObjectIdentifier *)UaOid {
    static ASN1ObjectIdentifier *_UaOid = nil;
    @synchronized(self) {
        if (!_UaOid) {
            _UaOid = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.804.2.1.1.1"];
        }
    }
    return _UaOid;
}

+ (ASN1ObjectIdentifier *)dstu4145le {
    static ASN1ObjectIdentifier *_dstu4145le = nil;
    @synchronized(self) {
        if (!_dstu4145le) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self UaOid] branch:@"1.3.1.1"] retain];
            }
            _dstu4145le = [branchObj retain];
        }
    }
    return _dstu4145le;
}

+ (ASN1ObjectIdentifier *)dstu4145be {
    static ASN1ObjectIdentifier *_dstu4145be = nil;
    @synchronized(self) {
        if (!_dstu4145be) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self UaOid] branch:@"1.3.1.1.1.1"] retain];
            }
            _dstu4145be = [branchObj retain];
        }
    }
    return _dstu4145be;
}

@end
