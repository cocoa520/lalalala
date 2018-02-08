//
//  CMSObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CMSObjectIdentifiers.h"
#import "PKCSObjectIdentifiers.h"

@implementation CMSObjectIdentifiers

+ (ASN1ObjectIdentifier *)data {
    static ASN1ObjectIdentifier *_data = nil;
    @synchronized(self) {
        if (!_data) {
            _data = [[PKCSObjectIdentifiers data] retain];
        }
    }
    return _data;
}

+ (ASN1ObjectIdentifier *)signedData {
    static ASN1ObjectIdentifier *_signedData = nil;
    @synchronized(self) {
        if (!_signedData) {
            _signedData = [[PKCSObjectIdentifiers signedData] retain];
        }
    }
    return _signedData;
}

+ (ASN1ObjectIdentifier *)envelopedData {
    static ASN1ObjectIdentifier *_envelopedData = nil;
    @synchronized(self) {
        if (!_envelopedData) {
            _envelopedData = [[PKCSObjectIdentifiers envelopedData] retain];
        }
    }
    return _envelopedData;
}

+ (ASN1ObjectIdentifier *)signedAndEnvelopedData {
    static ASN1ObjectIdentifier *_signedAndEnvelopedData = nil;
    @synchronized(self) {
        if (!_signedAndEnvelopedData) {
            _signedAndEnvelopedData = [[PKCSObjectIdentifiers signedAndEnvelopedData] retain];
        }
    }
    return _signedAndEnvelopedData;
}

+ (ASN1ObjectIdentifier *)digestedData {
    static ASN1ObjectIdentifier *_digestedData = nil;
    @synchronized(self) {
        if (!_digestedData) {
            _digestedData = [[PKCSObjectIdentifiers digestedData] retain];
        }
    }
    return _digestedData;
}

+ (ASN1ObjectIdentifier *)encryptedData {
    static ASN1ObjectIdentifier *_encryptedData = nil;
    @synchronized(self) {
        if (!_encryptedData) {
            _encryptedData = [[PKCSObjectIdentifiers encryptedData] retain];
        }
    }
    return _encryptedData;
}

+ (ASN1ObjectIdentifier *)authenticatedData {
    static ASN1ObjectIdentifier *_authenticatedData = nil;
    @synchronized(self) {
        if (!_authenticatedData) {
            _authenticatedData = [[PKCSObjectIdentifiers id_ct_authData] retain];
        }
    }
    return _authenticatedData;
}

+ (ASN1ObjectIdentifier *)compressedData {
    static ASN1ObjectIdentifier *_compressedData = nil;
    @synchronized(self) {
        if (!_compressedData) {
            _compressedData = [[PKCSObjectIdentifiers id_ct_compressedData] retain];
        }
    }
    return _compressedData;
}

+ (ASN1ObjectIdentifier *)authEnvelopedData {
    static ASN1ObjectIdentifier *_authEnvelopedData = nil;
    @synchronized(self) {
        if (!_authEnvelopedData) {
            _authEnvelopedData = [[PKCSObjectIdentifiers id_ct_authEnvelopedData] retain];
        }
    }
    return _authEnvelopedData;
}

+ (ASN1ObjectIdentifier *)timestampedData {
    static ASN1ObjectIdentifier *_timestampedData = nil;
    @synchronized(self) {
        if (!_timestampedData) {
            _timestampedData = [[PKCSObjectIdentifiers id_ct_timestampedData] retain];
        }
    }
    return _timestampedData;
}

+ (ASN1ObjectIdentifier *)id_ri {
    static ASN1ObjectIdentifier *_id_ri = nil;
    @synchronized(self) {
        if (!_id_ri) {
            _id_ri = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.16"];
        }
    }
    return _id_ri;
}

+ (ASN1ObjectIdentifier *)id_ri_ocsp_response {
    static ASN1ObjectIdentifier *_id_ri_ocsp_response = nil;
    @synchronized(self) {
        if (!_id_ri_ocsp_response) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_ri] branch:@"2"] retain];
            }
            _id_ri_ocsp_response = [branchObj retain];
        }
    }
    return _id_ri_ocsp_response;
}

+ (ASN1ObjectIdentifier *)id_ri_scvp {
    static ASN1ObjectIdentifier *_id_ri_scvp = nil;
    @synchronized(self) {
        if (!_id_ri_scvp) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_ri] branch:@"4"] retain];
            }
            _id_ri_scvp = [branchObj retain];
        }
    }
    return _id_ri_scvp;
}

@end
