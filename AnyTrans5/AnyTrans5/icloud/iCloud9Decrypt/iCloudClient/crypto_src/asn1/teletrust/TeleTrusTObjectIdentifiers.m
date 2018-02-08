//
//  TeleTrusTObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "TeleTrusTObjectIdentifiers.h"

@implementation TeleTrusTObjectIdentifiers

+ (ASN1ObjectIdentifier *)teleTrusTAlgorithm {
    static ASN1ObjectIdentifier *_teleTrusTAlgorithm = nil;
    @synchronized(self) {
        if (!_teleTrusTAlgorithm) {
            _teleTrusTAlgorithm = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.36.3"];
        }
    }
    return _teleTrusTAlgorithm;
}

+ (ASN1ObjectIdentifier *)ripemd160 {
    static ASN1ObjectIdentifier *_ripemd160 = nil;
    @synchronized(self) {
        if (!_ripemd160) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self teleTrusTAlgorithm] branch:@"2.1"] retain];
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
                branchObj = [[[self teleTrusTAlgorithm] branch:@"2.2"] retain];
            }
            _ripemd128 = [branchObj retain];
        }
    }
    return _ripemd128;
}

+ (ASN1ObjectIdentifier *)ripemd256 {
    static ASN1ObjectIdentifier *_ripemd256 = nil;
    @synchronized(self) {
        if (!_ripemd256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self teleTrusTAlgorithm] branch:@"2.3"] retain];
            }
            _ripemd256 = [branchObj retain];
        }
    }
    return _ripemd256;
}

+ (ASN1ObjectIdentifier *)teleTrusTRSAsignatureAlgorithm {
    static ASN1ObjectIdentifier *_teleTrusTRSAsignatureAlgorithm = nil;
    @synchronized(self) {
        if (!_teleTrusTRSAsignatureAlgorithm) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self teleTrusTAlgorithm] branch:@"3.1"] retain];
            }
            _teleTrusTRSAsignatureAlgorithm = [branchObj retain];
        }
    }
    return _teleTrusTRSAsignatureAlgorithm;
}

+ (ASN1ObjectIdentifier *)rsaSignatureWithripemd160 {
    static ASN1ObjectIdentifier *_rsaSignatureWithripemd160 = nil;
    @synchronized(self) {
        if (!_rsaSignatureWithripemd160) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self teleTrusTRSAsignatureAlgorithm] branch:@"2"] retain];
            }
            _rsaSignatureWithripemd160 = [branchObj retain];
        }
    }
    return _rsaSignatureWithripemd160;
}

+ (ASN1ObjectIdentifier *)rsaSignatureWithripemd128 {
    static ASN1ObjectIdentifier *_rsaSignatureWithripemd128 = nil;
    @synchronized(self) {
        if (!_rsaSignatureWithripemd128) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self teleTrusTRSAsignatureAlgorithm] branch:@"3"] retain];
            }
            _rsaSignatureWithripemd128 = [branchObj retain];
        }
    }
    return _rsaSignatureWithripemd128;
}

+ (ASN1ObjectIdentifier *)rsaSignatureWithripemd256 {
    static ASN1ObjectIdentifier *_rsaSignatureWithripemd256 = nil;
    @synchronized(self) {
        if (!_rsaSignatureWithripemd256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self teleTrusTRSAsignatureAlgorithm] branch:@"4"] retain];
            }
            _rsaSignatureWithripemd256 = [branchObj retain];
        }
    }
    return _rsaSignatureWithripemd256;
}

+ (ASN1ObjectIdentifier *)ecSign {
    static ASN1ObjectIdentifier *_ecSign = nil;
    @synchronized(self) {
        if (!_ecSign) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self teleTrusTAlgorithm] branch:@"3.2"] retain];
            }
            _ecSign = [branchObj retain];
        }
    }
    return _ecSign;
}

+ (ASN1ObjectIdentifier *)ecSignWithSha1 {
    static ASN1ObjectIdentifier *_ecSignWithSha1 = nil;
    @synchronized(self) {
        if (!_ecSignWithSha1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ecSign] branch:@"1"] retain];
            }
            _ecSignWithSha1 = [branchObj retain];
        }
    }
    return _ecSignWithSha1;
}

+ (ASN1ObjectIdentifier *)ecSignWithRipemd160 {
    static ASN1ObjectIdentifier *_ecSignWithRipemd160 = nil;
    @synchronized(self) {
        if (!_ecSignWithRipemd160) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ecSign] branch:@"2"] retain];
            }
            _ecSignWithRipemd160 = [branchObj retain];
        }
    }
    return _ecSignWithRipemd160;
}

+ (ASN1ObjectIdentifier *)ecc_brainpool {
    static ASN1ObjectIdentifier *_ecc_brainpool = nil;
    @synchronized(self) {
        if (!_ecc_brainpool) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self teleTrusTAlgorithm] branch:@"3.2.8"] retain];
            }
            _ecc_brainpool = [branchObj retain];
        }
    }
    return _ecc_brainpool;
}

+ (ASN1ObjectIdentifier *)ellipticCurve {
    static ASN1ObjectIdentifier *_ellipticCurve = nil;
    @synchronized(self) {
        if (!_ellipticCurve) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ecc_brainpool] branch:@"1"] retain];
            }
            _ellipticCurve = [branchObj retain];
        }
    }
    return _ellipticCurve;
}

+ (ASN1ObjectIdentifier *)versionOne {
    static ASN1ObjectIdentifier *_versionOne = nil;
    @synchronized(self) {
        if (!_versionOne) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"1"] retain];
            }
            _versionOne = [branchObj retain];
        }
    }
    return _versionOne;
}

+ (ASN1ObjectIdentifier *)brainpoolP160r1 {
    static ASN1ObjectIdentifier *_brainpoolP160r1 = nil;
    @synchronized(self) {
        if (!_brainpoolP160r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self versionOne] branch:@"1"] retain];
            }
            _brainpoolP160r1 = [branchObj retain];
        }
    }
    return _brainpoolP160r1;
}

+ (ASN1ObjectIdentifier *)brainpoolP160t1 {
    static ASN1ObjectIdentifier *_brainpoolP160t1 = nil;
    @synchronized(self) {
        if (!_brainpoolP160t1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self versionOne] branch:@"2"] retain];
            }
            _brainpoolP160t1 = [branchObj retain];
        }
    }
    return _brainpoolP160t1;
}

+ (ASN1ObjectIdentifier *)brainpoolP192r1 {
    static ASN1ObjectIdentifier *_brainpoolP192r1 = nil;
    @synchronized(self) {
        if (!_brainpoolP192r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self versionOne] branch:@"3"] retain];
            }
            _brainpoolP192r1 = [branchObj retain];
        }
    }
    return _brainpoolP192r1;
}

+ (ASN1ObjectIdentifier *)brainpoolP192t1 {
    static ASN1ObjectIdentifier *_brainpoolP192t1 = nil;
    @synchronized(self) {
        if (!_brainpoolP192t1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self versionOne] branch:@"4"] retain];
            }
            _brainpoolP192t1 = [branchObj retain];
        }
    }
    return _brainpoolP192t1;
}

+ (ASN1ObjectIdentifier *)brainpoolP224r1 {
    static ASN1ObjectIdentifier *_brainpoolP224r1 = nil;
    @synchronized(self) {
        if (!_brainpoolP224r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self versionOne] branch:@"5"] retain];
            }
            _brainpoolP224r1 = [branchObj retain];
        }
    }
    return _brainpoolP224r1;
}

+ (ASN1ObjectIdentifier *)brainpoolP224t1 {
    static ASN1ObjectIdentifier *_brainpoolP224t1 = nil;
    @synchronized(self) {
        if (!_brainpoolP224t1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self versionOne] branch:@"6"] retain];
            }
            _brainpoolP224t1 = [branchObj retain];
        }
    }
    return _brainpoolP224t1;
}

+ (ASN1ObjectIdentifier *)brainpoolP256r1 {
    static ASN1ObjectIdentifier *_brainpoolP256r1 = nil;
    @synchronized(self) {
        if (!_brainpoolP256r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self versionOne] branch:@"7"] retain];
            }
            _brainpoolP256r1 = [branchObj retain];
        }
    }
    return _brainpoolP256r1;
}

+ (ASN1ObjectIdentifier *)brainpoolP256t1 {
    static ASN1ObjectIdentifier *_brainpoolP256t1 = nil;
    @synchronized(self) {
        if (!_brainpoolP256t1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self versionOne] branch:@"8"] retain];
            }
            _brainpoolP256t1 = [branchObj retain];
        }
    }
    return _brainpoolP256t1;
}

+ (ASN1ObjectIdentifier *)brainpoolP320r1 {
    static ASN1ObjectIdentifier *_brainpoolP320r1 = nil;
    @synchronized(self) {
        if (!_brainpoolP320r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self versionOne] branch:@"9"] retain];
            }
            _brainpoolP320r1 = [branchObj retain];
        }
    }
    return _brainpoolP320r1;
}

+ (ASN1ObjectIdentifier *)brainpoolP320t1 {
    static ASN1ObjectIdentifier *_brainpoolP320t1 = nil;
    @synchronized(self) {
        if (!_brainpoolP320t1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self versionOne] branch:@"10"] retain];
            }
            _brainpoolP320t1 = [branchObj retain];
        }
    }
    return _brainpoolP320t1;
}

+ (ASN1ObjectIdentifier *)brainpoolP384r1 {
    static ASN1ObjectIdentifier *_brainpoolP384r1 = nil;
    @synchronized(self) {
        if (!_brainpoolP384r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self versionOne] branch:@"11"] retain];
            }
            _brainpoolP384r1 = [branchObj retain];
        }
    }
    return _brainpoolP384r1;
}

+ (ASN1ObjectIdentifier *)brainpoolP384t1 {
    static ASN1ObjectIdentifier *_brainpoolP384t1 = nil;
    @synchronized(self) {
        if (!_brainpoolP384t1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self versionOne] branch:@"12"] retain];
            }
            _brainpoolP384t1 = [branchObj retain];
        }
    }
    return _brainpoolP384t1;
}

+ (ASN1ObjectIdentifier *)brainpoolP512r1 {
    static ASN1ObjectIdentifier *_brainpoolP512r1 = nil;
    @synchronized(self) {
        if (!_brainpoolP512r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self versionOne] branch:@"13"] retain];
            }
            _brainpoolP512r1 = [branchObj retain];
        }
    }
    return _brainpoolP512r1;
}

+ (ASN1ObjectIdentifier *)brainpoolP512t1 {
    static ASN1ObjectIdentifier *_brainpoolP512t1 = nil;
    @synchronized(self) {
        if (!_brainpoolP512t1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self versionOne] branch:@"14"] retain];
            }
            _brainpoolP512t1 = [branchObj retain];
        }
    }
    return _brainpoolP512t1;
}

@end
