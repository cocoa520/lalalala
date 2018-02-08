//
//  IANAObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "IANAObjectIdentifiers.h"

@implementation IANAObjectIdentifiers

+ (ASN1ObjectIdentifier *)internet {
    static ASN1ObjectIdentifier *_internet = nil;
    @synchronized(self) {
        if (!_internet) {
            _internet = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1"];
        }
    }
    return _internet;
}

+ (ASN1ObjectIdentifier *)directory {
    static ASN1ObjectIdentifier *_directory = nil;
    @synchronized(self) {
        if (!_directory) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self internet] branch:@"1"] retain];
            }
            _directory = [branchObj retain];
        }
    }
    return _directory;
}

+ (ASN1ObjectIdentifier *)mgmt {
    static ASN1ObjectIdentifier *_mgmt = nil;
    @synchronized(self) {
        if (!_mgmt) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self internet] branch:@"2"] retain];
            }
            _mgmt = [branchObj retain];
        }
    }
    return _mgmt;
}

+ (ASN1ObjectIdentifier *)experimental {
    static ASN1ObjectIdentifier *_experimental = nil;
    @synchronized(self) {
        if (!_experimental) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self internet] branch:@"3"] retain];
            }
            _experimental = [branchObj retain];
        }
    }
    return _experimental;
}

+ (ASN1ObjectIdentifier *)_private {
    static ASN1ObjectIdentifier *_private = nil;
    @synchronized(self) {
        if (!_private) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self internet] branch:@"4"] retain];
            }
            _private = [branchObj retain];
        }
    }
    return _private;
}

+ (ASN1ObjectIdentifier *)security {
    static ASN1ObjectIdentifier *_security = nil;
    @synchronized(self) {
        if (!_security) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self internet] branch:@"5"] retain];
            }
            _security = [branchObj retain];
        }
    }
    return _security;
}

+ (ASN1ObjectIdentifier *)SNMPv2 {
    static ASN1ObjectIdentifier *_SNMPv2 = nil;
    @synchronized(self) {
        if (!_SNMPv2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self internet] branch:@"6"] retain];
            }
            _SNMPv2 = [branchObj retain];
        }
    }
    return _SNMPv2;
}

+ (ASN1ObjectIdentifier *)mail {
    static ASN1ObjectIdentifier *_mail = nil;
    @synchronized(self) {
        if (!_mail) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self internet] branch:@"7"] retain];
            }
            _mail = [branchObj retain];
        }
    }
    return _mail;
}

+ (ASN1ObjectIdentifier *)security_mechanisms {
    static ASN1ObjectIdentifier *_security_mechanisms = nil;
    @synchronized(self) {
        if (!_security_mechanisms) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self security] branch:@"5"] retain];
            }
            _security_mechanisms = [branchObj retain];
        }
    }
    return _security_mechanisms;
}

+ (ASN1ObjectIdentifier *)security_nametypes {
    static ASN1ObjectIdentifier *_security_nametypes = nil;
    @synchronized(self) {
        if (!_security_nametypes) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self security] branch:@"6"] retain];
            }
            _security_nametypes = [branchObj retain];
        }
    }
    return _security_nametypes;
}

+ (ASN1ObjectIdentifier *)pkix {
    static ASN1ObjectIdentifier *_pkix = nil;
    @synchronized(self) {
        if (!_pkix) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self security_mechanisms] branch:@"6"] retain];
            }
            _pkix = [branchObj retain];
        }
    }
    return _pkix;
}

+ (ASN1ObjectIdentifier *)ipsec {
    static ASN1ObjectIdentifier *_ipsec = nil;
    @synchronized(self) {
        if (!_ipsec) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self security_mechanisms] branch:@"8"] retain];
            }
            _ipsec = [branchObj retain];
        }
    }
    return _ipsec;
}

+ (ASN1ObjectIdentifier *)isakmpOakley {
    static ASN1ObjectIdentifier *_isakmpOakley = nil;
    @synchronized(self) {
        if (!_isakmpOakley) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ipsec] branch:@"1"] retain];
            }
            _isakmpOakley = [branchObj retain];
        }
    }
    return _isakmpOakley;
}

+ (ASN1ObjectIdentifier *)hmacMD5 {
    static ASN1ObjectIdentifier *_hmacMD5 = nil;
    @synchronized(self) {
        if (!_hmacMD5) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self isakmpOakley] branch:@"1"] retain];
            }
            _hmacMD5 = [branchObj retain];
        }
    }
    return _hmacMD5;
}

+ (ASN1ObjectIdentifier *)hmacSHA1 {
    static ASN1ObjectIdentifier *_hmacSHA1 = nil;
    @synchronized(self) {
        if (!_hmacSHA1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self isakmpOakley] branch:@"2"] retain];
            }
            _hmacSHA1 = [branchObj retain];
        }
    }
    return _hmacSHA1;
}

+ (ASN1ObjectIdentifier *)hmacTIGER {
    static ASN1ObjectIdentifier *_hmacTIGER = nil;
    @synchronized(self) {
        if (!_hmacTIGER) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self isakmpOakley] branch:@"3"] retain];
            }
            _hmacTIGER = [branchObj retain];
        }
    }
    return _hmacTIGER;
}

+ (ASN1ObjectIdentifier *)hmacRIPEMD160 {
    static ASN1ObjectIdentifier *_hmacRIPEMD160 = nil;
    @synchronized(self) {
        if (!_hmacRIPEMD160) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self isakmpOakley] branch:@"4"] retain];
            }
            _hmacRIPEMD160 = [branchObj retain];
        }
    }
    return _hmacRIPEMD160;
}

@end
