//
//  SMIMEAttributes.m
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SMIMEAttributes.h"
#import "PKCSObjectIdentifiers.h"

@implementation SMIMEAttributes

+ (ASN1ObjectIdentifier *)smimeCapabilities {
    static ASN1ObjectIdentifier *_smimeCapabilities = nil;
    @synchronized(self) {
        if (!_smimeCapabilities) {
            _smimeCapabilities = [[PKCSObjectIdentifiers pkcs_9_at_smimeCapabilities] retain];
        }
    }
    return _smimeCapabilities;
}
+ (ASN1ObjectIdentifier *)encrypKeyPref {
    static ASN1ObjectIdentifier *_encrypKeyPref = nil;
    @synchronized(self) {
        if (!_encrypKeyPref) {
            _encrypKeyPref = [[PKCSObjectIdentifiers id_aa_encrypKeyPref] retain];
        }
    }
    return _encrypKeyPref;
}

@end
