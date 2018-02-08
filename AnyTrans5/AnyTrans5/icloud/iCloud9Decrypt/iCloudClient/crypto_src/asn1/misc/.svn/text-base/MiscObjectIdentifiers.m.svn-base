//
//  MiscObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "MiscObjectIdentifiers.h"

@implementation MiscObjectIdentifiers

+ (ASN1ObjectIdentifier *)netscape {
    static ASN1ObjectIdentifier *_netscape = nil;
    @synchronized(self) {
        if (!_netscape) {
            _netscape = [[ASN1ObjectIdentifier alloc] initParamString:@"2.16.840.1.113730.1"];
        }
    }
    return _netscape;
}

+ (ASN1ObjectIdentifier *)netscapeCertType {
    static ASN1ObjectIdentifier *_netscapeCertType = nil;
    @synchronized(self) {
        if (!_netscapeCertType) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self netscape] branch:@"1"] retain];
            }
            _netscapeCertType = [branchObj retain];
        }
    }
    return _netscapeCertType;
}

+ (ASN1ObjectIdentifier *)netscapeBaseURL {
    static ASN1ObjectIdentifier *_netscapeBaseURL = nil;
    @synchronized(self) {
        if (!_netscapeBaseURL) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self netscape] branch:@"2"] retain];
            }
            _netscapeBaseURL = [branchObj retain];
        }
    }
    return _netscapeBaseURL;
}

+ (ASN1ObjectIdentifier *)netscapeRevocationURL {
    static ASN1ObjectIdentifier *_netscapeRevocationURL = nil;
    @synchronized(self) {
        if (!_netscapeRevocationURL) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self netscape] branch:@"3"] retain];
            }
            _netscapeRevocationURL = [branchObj retain];
        }
    }
    return _netscapeRevocationURL;
}

+ (ASN1ObjectIdentifier *)netscapeCARevocationURL {
    static ASN1ObjectIdentifier *_netscapeCARevocationURL = nil;
    @synchronized(self) {
        if (!_netscapeCARevocationURL) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self netscape] branch:@"4"] retain];
            }
            _netscapeCARevocationURL = [branchObj retain];
        }
    }
    return _netscapeCARevocationURL;
}

+ (ASN1ObjectIdentifier *)netscapeRenewalURL {
    static ASN1ObjectIdentifier *_netscapeRenewalURL = nil;
    @synchronized(self) {
        if (!_netscapeRenewalURL) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self netscape] branch:@"7"] retain];
            }
            _netscapeRenewalURL = [branchObj retain];
        }
    }
    return _netscapeRenewalURL;
}

+ (ASN1ObjectIdentifier *)netscapeCApolicyURL {
    static ASN1ObjectIdentifier *_netscapeCApolicyURL = nil;
    @synchronized(self) {
        if (!_netscapeCApolicyURL) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self netscape] branch:@"8"] retain];
            }
            _netscapeCApolicyURL = [branchObj retain];
        }
    }
    return _netscapeCApolicyURL;
}

+ (ASN1ObjectIdentifier *)netscapeSSLServerName {
    static ASN1ObjectIdentifier *_netscapeSSLServerName = nil;
    @synchronized(self) {
        if (!_netscapeSSLServerName) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self netscape] branch:@"12"] retain];
            }
            _netscapeSSLServerName = [branchObj retain];
        }
    }
    return _netscapeSSLServerName;
}

+ (ASN1ObjectIdentifier *)netscapeCertComment {
    static ASN1ObjectIdentifier *_netscapeCertComment = nil;
    @synchronized(self) {
        if (!_netscapeCertComment) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self netscape] branch:@"13"] retain];
            }
            _netscapeCertComment = [branchObj retain];
        }
    }
    return _netscapeCertComment;
}

+ (ASN1ObjectIdentifier *)verisign {
    static ASN1ObjectIdentifier *_verisign = nil;
    @synchronized(self) {
        if (!_verisign) {
            _verisign = [[ASN1ObjectIdentifier alloc] initParamString:@"2.16.840.1.113733.1"];
        }
    }
    return _verisign;
}

+ (ASN1ObjectIdentifier *)verisignCzagExtension {
    static ASN1ObjectIdentifier *_verisignCzagExtension = nil;
    @synchronized(self) {
        if (!_verisignCzagExtension) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self verisign] branch:@"6.3"] retain];
            }
            _verisignCzagExtension = [branchObj retain];
        }
    }
    return _verisignCzagExtension;
}

+ (ASN1ObjectIdentifier *)verisignPrivate_6_9 {
    static ASN1ObjectIdentifier *_verisignPrivate_6_9 = nil;
    @synchronized(self) {
        if (!_verisignPrivate_6_9) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self verisign] branch:@"6.9"] retain];
            }
            _verisignPrivate_6_9 = [branchObj retain];
        }
    }
    return _verisignPrivate_6_9;
}

+ (ASN1ObjectIdentifier *)verisignOnSiteJurisdictionHash {
    static ASN1ObjectIdentifier *_verisignOnSiteJurisdictionHash = nil;
    @synchronized(self) {
        if (!_verisignOnSiteJurisdictionHash) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self verisign] branch:@"6.11"] retain];
            }
            _verisignOnSiteJurisdictionHash = [branchObj retain];
        }
    }
    return _verisignOnSiteJurisdictionHash;
}

+ (ASN1ObjectIdentifier *)verisignBitString_6_13 {
    static ASN1ObjectIdentifier *_verisignBitString_6_13 = nil;
    @synchronized(self) {
        if (!_verisignBitString_6_13) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self verisign] branch:@"6.13"] retain];
            }
            _verisignBitString_6_13 = [branchObj retain];
        }
    }
    return _verisignBitString_6_13;
}

+ (ASN1ObjectIdentifier *)verisignDnbDunsNumber {
    static ASN1ObjectIdentifier *_verisignDnbDunsNumber = nil;
    @synchronized(self) {
        if (!_verisignDnbDunsNumber) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self verisign] branch:@"6.15"] retain];
            }
            _verisignDnbDunsNumber = [branchObj retain];
        }
    }
    return _verisignDnbDunsNumber;
}

+ (ASN1ObjectIdentifier *)verisignIssStrongCrypto {
    static ASN1ObjectIdentifier *_verisignIssStrongCrypto = nil;
    @synchronized(self) {
        if (!_verisignIssStrongCrypto) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self verisign] branch:@"8.1"] retain];
            }
            _verisignIssStrongCrypto = [branchObj retain];
        }
    }
    return _verisignIssStrongCrypto;
}

+ (ASN1ObjectIdentifier *)novell {
    static ASN1ObjectIdentifier *_novell = nil;
    @synchronized(self) {
        if (!_novell) {
            _novell = [[ASN1ObjectIdentifier alloc] initParamString:@"2.16.840.1.113719"];
        }
    }
    return _novell;
}

+ (ASN1ObjectIdentifier *)novellSecurityAttribs {
    static ASN1ObjectIdentifier *_novellSecurityAttribs = nil;
    @synchronized(self) {
        if (!_novellSecurityAttribs) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self novell] branch:@"1.9.4.1"] retain];
            }
            _novellSecurityAttribs = [branchObj retain];
        }
    }
    return _novellSecurityAttribs;
}

+ (ASN1ObjectIdentifier *)entrust {
    static ASN1ObjectIdentifier *_entrust = nil;
    @synchronized(self) {
        if (!_entrust) {
            _entrust = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113533.7"];
        }
    }
    return _entrust;
}

+ (ASN1ObjectIdentifier *)entrustVersionExtension {
    static ASN1ObjectIdentifier *_entrustVersionExtension = nil;
    @synchronized(self) {
        if (!_entrustVersionExtension) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self entrust] branch:@"65.0"] retain];
            }
            _entrustVersionExtension = [branchObj retain];
        }
    }
    return _entrustVersionExtension;
}

+ (ASN1ObjectIdentifier *)cast5CBC {
    static ASN1ObjectIdentifier *_cast5CBC = nil;
    @synchronized(self) {
        if (!_cast5CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self entrust] branch:@"66.10"] retain];
            }
            _cast5CBC = [branchObj retain];
        }
    }
    return _cast5CBC;
}

+ (ASN1ObjectIdentifier *)as_sys_sec_alg_ideaCBC {
    static ASN1ObjectIdentifier *_as_sys_sec_alg_ideaCBC = nil;
    @synchronized(self) {
        if (!_as_sys_sec_alg_ideaCBC) {
            _as_sys_sec_alg_ideaCBC = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.188.7.1.1.2"];
        }
    }
    return _as_sys_sec_alg_ideaCBC;
}

+ (ASN1ObjectIdentifier *)cryptlib {
    static ASN1ObjectIdentifier *_cryptlib = nil;
    @synchronized(self) {
        if (!_cryptlib) {
            _cryptlib = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.3029"];
        }
    }
    return _cryptlib;
}

+ (ASN1ObjectIdentifier *)cryptlib_algorithm {
    static ASN1ObjectIdentifier *_cryptlib_algorithm = nil;
    @synchronized(self) {
        if (!_cryptlib_algorithm) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cryptlib] branch:@"1"] retain];
            }
            _cryptlib_algorithm = [branchObj retain];
        }
    }
    return _cryptlib_algorithm;
}

+ (ASN1ObjectIdentifier *)cryptlib_algorithm_blowfish_ECB {
    static ASN1ObjectIdentifier *_cryptlib_algorithm_blowfish_ECB = nil;
    @synchronized(self) {
        if (!_cryptlib_algorithm_blowfish_ECB) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cryptlib_algorithm] branch:@"1.1"] retain];
            }
            _cryptlib_algorithm_blowfish_ECB = [branchObj retain];
        }
    }
    return _cryptlib_algorithm_blowfish_ECB;
}

+ (ASN1ObjectIdentifier *)cryptlib_algorithm_blowfish_CBC {
    static ASN1ObjectIdentifier *_cryptlib_algorithm_blowfish_CBC = nil;
    @synchronized(self) {
        if (!_cryptlib_algorithm_blowfish_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cryptlib_algorithm] branch:@"1.2"] retain];
            }
            _cryptlib_algorithm_blowfish_CBC = [branchObj retain];
        }
    }
    return _cryptlib_algorithm_blowfish_CBC;
}

+ (ASN1ObjectIdentifier *)cryptlib_algorithm_blowfish_CFB {
    static ASN1ObjectIdentifier *_cryptlib_algorithm_blowfish_CFB = nil;
    @synchronized(self) {
        if (!_cryptlib_algorithm_blowfish_CFB) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cryptlib_algorithm] branch:@"1.3"] retain];
            }
            _cryptlib_algorithm_blowfish_CFB = [branchObj retain];
        }
    }
    return _cryptlib_algorithm_blowfish_CFB;
}

+ (ASN1ObjectIdentifier *)cryptlib_algorithm_blowfish_OFB {
    static ASN1ObjectIdentifier *_cryptlib_algorithm_blowfish_OFB = nil;
    @synchronized(self) {
        if (!_cryptlib_algorithm_blowfish_OFB) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cryptlib_algorithm] branch:@"1.4"] retain];
            }
            _cryptlib_algorithm_blowfish_OFB = [branchObj retain];
        }
    }
    return _cryptlib_algorithm_blowfish_OFB;
}

+ (ASN1ObjectIdentifier *)blake2 {
    static ASN1ObjectIdentifier *_blake2 = nil;
    @synchronized(self) {
        if (!_blake2) {
            _blake2 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.1722.12.2"];
        }
    }
    return _blake2;
}

+ (ASN1ObjectIdentifier *)id_blake2b160 {
    static ASN1ObjectIdentifier *_id_blake2b160 = nil;
    @synchronized(self) {
        if (!_id_blake2b160) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self blake2] branch:@"1.5"] retain];
            }
            _id_blake2b160 = [branchObj retain];
        }
    }
    return _id_blake2b160;
}

+ (ASN1ObjectIdentifier *)id_blake2b256 {
    static ASN1ObjectIdentifier *_id_blake2b256 = nil;
    @synchronized(self) {
        if (!_id_blake2b256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self blake2] branch:@"1.8"] retain];
            }
            _id_blake2b256 = [[[self blake2] branch:@"1.8"] retain];
        }
    }
    return _id_blake2b256;
}

+ (ASN1ObjectIdentifier *)id_blake2b384 {
    static ASN1ObjectIdentifier *_id_blake2b384 = nil;
    @synchronized(self) {
        if (!_id_blake2b384) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self blake2] branch:@"1.12"] retain];
            }
            _id_blake2b384 = [[[self blake2] branch:@"1.12"] retain];
        }
    }
    return _id_blake2b384;
}

+ (ASN1ObjectIdentifier *)id_blake2b512 {
    static ASN1ObjectIdentifier *_id_blake2b512 = nil;
    @synchronized(self) {
        if (!_id_blake2b512) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self blake2] branch:@"1.16"] retain];
            }
            _id_blake2b512 = [[[self blake2] branch:@"1.16"] retain];
        }
    }
    return _id_blake2b512;
}


@end
