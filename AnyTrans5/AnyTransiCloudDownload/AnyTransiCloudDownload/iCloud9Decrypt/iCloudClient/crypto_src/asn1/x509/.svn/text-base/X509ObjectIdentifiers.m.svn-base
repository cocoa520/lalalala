//
//  X509ObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 7/12/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X509ObjectIdentifiers.h"

@implementation X509ObjectIdentifiers

+ (ASN1ObjectIdentifier *)commonName {
    static ASN1ObjectIdentifier *_commonName = nil;
    @synchronized(self) {
        if (!_commonName) {
            _commonName = [[[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.3"] intern];
        }
    }
    return _commonName;
}

+ (ASN1ObjectIdentifier *)countryName {
    static ASN1ObjectIdentifier *_countryName = nil;
    @synchronized(self) {
        if (!_countryName) {
            _countryName = [[[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.6"] intern];
        }
    }
    return _countryName;
}

+ (ASN1ObjectIdentifier *)localityName {
    static ASN1ObjectIdentifier *_localityName = nil;
    @synchronized(self) {
        if (!_localityName) {
            _localityName = [[[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.7"] intern];
        }
    }
    return _localityName;
}

+ (ASN1ObjectIdentifier *)stateOrProvinceName {
    static ASN1ObjectIdentifier *_stateOrProvinceName = nil;
    @synchronized(self) {
        if (!_stateOrProvinceName) {
            _stateOrProvinceName = [[[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.8"] intern];
        }
    }
    return _stateOrProvinceName;
}

+ (ASN1ObjectIdentifier *)organization {
    static ASN1ObjectIdentifier *_organization = nil;
    @synchronized(self) {
        if (!_organization) {
            _organization = [[[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.10"] intern];
        }
    }
    return _organization;
}

+ (ASN1ObjectIdentifier *)organizationalUnitName {
    static ASN1ObjectIdentifier *_organizationalUnitName = nil;
    @synchronized(self) {
        if (!_organizationalUnitName) {
            _organizationalUnitName = [[[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.11"] intern];
        }
    }
    return _organizationalUnitName;
}

+ (ASN1ObjectIdentifier *)id_at_telephoneNumber {
    static ASN1ObjectIdentifier *_id_at_telephoneNumber = nil;
    @synchronized(self) {
        if (!_id_at_telephoneNumber) {
            _id_at_telephoneNumber = [[[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.20"] intern];
        }
    }
    return _id_at_telephoneNumber;
}

+ (ASN1ObjectIdentifier *)id_at_name {
    static ASN1ObjectIdentifier *_id_at_name = nil;
    @synchronized(self) {
        if (!_id_at_name) {
            _id_at_name = [[[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.41"] intern];
        }
    }
    return _id_at_name;
}

+ (ASN1ObjectIdentifier *)id_SHA1 {
    static ASN1ObjectIdentifier *_id_SHA1 = nil;
    @synchronized(self) {
        if (!_id_SHA1) {
            _id_SHA1 = [[[ASN1ObjectIdentifier alloc] initParamString:@"1.3.14.3.2.26"] intern];
        }
    }
    return _id_SHA1;
}

+ (ASN1ObjectIdentifier *)ripemd160 {
    static ASN1ObjectIdentifier *_ripemd160 = nil;
    @synchronized(self) {
        if (!_ripemd160) {
            _ripemd160 = [[[ASN1ObjectIdentifier alloc] initParamString:@"1.3.36.3.2.1"] intern];
        }
    }
    return _ripemd160;
}

+ (ASN1ObjectIdentifier *)ripemd160WithRSAEncryption {
    static ASN1ObjectIdentifier *_ripemd160WithRSAEncryption = nil;
    @synchronized(self) {
        if (!_ripemd160WithRSAEncryption) {
            _ripemd160WithRSAEncryption = [[[ASN1ObjectIdentifier alloc] initParamString:@"1.3.36.3.3.1.2"] intern];
        }
    }
    return _ripemd160WithRSAEncryption;
}

+ (ASN1ObjectIdentifier *)id_ea_rsa {
    static ASN1ObjectIdentifier *_id_ea_rsa = nil;
    @synchronized(self) {
        if (!_id_ea_rsa) {
            _id_ea_rsa = [[[ASN1ObjectIdentifier alloc] initParamString:@"2.5.8.1.1"] intern];
        }
    }
    return _id_ea_rsa;
}

+ (ASN1ObjectIdentifier *)id_pkix {
    static ASN1ObjectIdentifier *_id_pkix = nil;
    @synchronized(self) {
        if (!_id_pkix) {
            _id_pkix = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7"];
        }
    }
    return _id_pkix;
}

+ (ASN1ObjectIdentifier *)id_pe {
    static ASN1ObjectIdentifier *_id_pe = nil;
    @synchronized(self) {
        if (!_id_pe) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_pkix] branch:@"1"] retain];
            }
            _id_pe = [branchObj retain];
        }
    }
    return _id_pe;
}

+ (ASN1ObjectIdentifier *)id_ce {
    static ASN1ObjectIdentifier *_id_ce = nil;
    @synchronized(self) {
        if (!_id_ce) {
            _id_ce = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29"];
        }
    }
    return _id_ce;
}

+ (ASN1ObjectIdentifier *)id_ad {
    static ASN1ObjectIdentifier *_id_ad = nil;
    @synchronized(self) {
        if (!_id_ad) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_pkix] branch:@"48"] retain];
            }
            _id_ad = [branchObj retain];
        }
    }
    return _id_ad;
}

+ (ASN1ObjectIdentifier *)id_ad_caIssuers {
    static ASN1ObjectIdentifier *_id_ad_caIssuers = nil;
    @synchronized(self) {
        if (!_id_ad_caIssuers) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_ad] branch:@"2"] retain];
            }
            _id_ad_caIssuers = [[branchObj intern] retain];
        }
    }
    return _id_ad_caIssuers;
}

+ (ASN1ObjectIdentifier *)id_ad_ocsp {
    static ASN1ObjectIdentifier *_id_ad_ocsp = nil;
    @synchronized(self) {
        if (!_id_ad_ocsp) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_ad] branch:@"1"] retain];
            }
            _id_ad_ocsp = [[branchObj intern] retain];
        }
    }
    return _id_ad_ocsp;
}

+ (ASN1ObjectIdentifier *)ocspAccessMethod {
    static ASN1ObjectIdentifier *_ocspAccessMethod = nil;
    @synchronized(self) {
        if (!_ocspAccessMethod) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[self id_ad_ocsp] retain];
            }
            _ocspAccessMethod = [branchObj retain];
        }
    }
    return _ocspAccessMethod;
}

+ (ASN1ObjectIdentifier *)crlAccessMethod {
    static ASN1ObjectIdentifier *_crlAccessMethod = nil;
    @synchronized(self) {
        if (!_crlAccessMethod) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[self id_ad_caIssuers] retain];
            }
            _crlAccessMethod = [branchObj retain];
        }
    }
    return _crlAccessMethod;
}

@end
