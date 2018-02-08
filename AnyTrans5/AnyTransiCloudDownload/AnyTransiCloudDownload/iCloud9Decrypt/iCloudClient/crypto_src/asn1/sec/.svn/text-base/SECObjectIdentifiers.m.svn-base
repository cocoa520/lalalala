//
//  SECObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SECObjectIdentifiers.h"
#import "X9ObjectIdentifiers.h"

@implementation SECObjectIdentifiers

+ (ASN1ObjectIdentifier *)ellipticCurve {
    static ASN1ObjectIdentifier *_ellipticCurve = nil;
    @synchronized(self) {
        if (!_ellipticCurve) {
            _ellipticCurve = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.132.0"];
        }
    }
    return _ellipticCurve;
}

+ (ASN1ObjectIdentifier *)sect163k1 {
    static ASN1ObjectIdentifier *_sect163k1 = nil;
    @synchronized(self) {
        if (!_sect163k1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"1"] retain];
            }
            _sect163k1 = [branchObj retain];
        }
    }
    return _sect163k1;
}

+ (ASN1ObjectIdentifier *)sect163r1 {
    static ASN1ObjectIdentifier *_sect163r1 = nil;
    @synchronized(self) {
        if (!_sect163r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"2"] retain];
            }
            _sect163r1 = [branchObj retain];
        }
    }
    return _sect163r1;
}

+ (ASN1ObjectIdentifier *)sect239k1 {
    static ASN1ObjectIdentifier *_sect239k1 = nil;
    @synchronized(self) {
        if (!_sect239k1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"3"] retain];
            }
            _sect239k1 = [branchObj retain];
        }
    }
    return _sect239k1;
}

+ (ASN1ObjectIdentifier *)sect113r1 {
    static ASN1ObjectIdentifier *_sect113r1 = nil;
    @synchronized(self) {
        if (!_sect113r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"4"] retain];
            }
            _sect113r1 = [branchObj retain];
        }
    }
    return _sect113r1;
}

+ (ASN1ObjectIdentifier *)sect113r2 {
    static ASN1ObjectIdentifier *_sect113r2 = nil;
    @synchronized(self) {
        if (!_sect113r2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"5"] retain];
            }
            _sect113r2 = [branchObj retain];
        }
    }
    return _sect113r2;
}

+ (ASN1ObjectIdentifier *)secp112r1 {
    static ASN1ObjectIdentifier *_secp112r1 = nil;
    @synchronized(self) {
        if (!_secp112r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"6"] retain];
            }
            _secp112r1 = [branchObj retain];
        }
    }
    return _secp112r1;
}

+ (ASN1ObjectIdentifier *)secp112r2 {
    static ASN1ObjectIdentifier *_secp112r2 = nil;
    @synchronized(self) {
        if (!_secp112r2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"7"] retain];
            }
            _secp112r2 = [branchObj retain];
        }
    }
    return _secp112r2;
}

+ (ASN1ObjectIdentifier *)secp160r1 {
    static ASN1ObjectIdentifier *_secp160r1 = nil;
    @synchronized(self) {
        if (!_secp160r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"8"] retain];
            }
            _secp160r1 = [branchObj retain];
        }
    }
    return _secp160r1;
}

+ (ASN1ObjectIdentifier *)secp160k1 {
    static ASN1ObjectIdentifier *_secp160k1 = nil;
    @synchronized(self) {
        if (!_secp160k1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"9"] retain];
            }
            _secp160k1 = [branchObj retain];
        }
    }
    return _secp160k1;
}

+ (ASN1ObjectIdentifier *)secp256k1 {
    static ASN1ObjectIdentifier *_secp256k1 = nil;
    @synchronized(self) {
        if (!_secp256k1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"10"] retain];
            }
            _secp256k1 = [branchObj retain];
        }
    }
    return _secp256k1;
}

+ (ASN1ObjectIdentifier *)sect163r2 {
    static ASN1ObjectIdentifier *_sect163r2 = nil;
    @synchronized(self) {
        if (!_sect163r2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"15"] retain];
            }
            _sect163r2 = [branchObj retain];
        }
    }
    return _sect163r2;
}

+ (ASN1ObjectIdentifier *)sect283k1 {
    static ASN1ObjectIdentifier *_sect283k1 = nil;
    @synchronized(self) {
        if (!_sect283k1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"16"] retain];
            }
            _sect283k1 = [branchObj retain];
        }
    }
    return _sect283k1;
}

+ (ASN1ObjectIdentifier *)sect283r1 {
    static ASN1ObjectIdentifier *_sect283r1 = nil;
    @synchronized(self) {
        if (!_sect283r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"17"] retain];
            }
            _sect283r1 = [branchObj retain];
        }
    }
    return _sect283r1;
}

+ (ASN1ObjectIdentifier *)sect131r1 {
    static ASN1ObjectIdentifier *_sect131r1 = nil;
    @synchronized(self) {
        if (!_sect131r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"22"] retain];
            }
            _sect131r1 = [branchObj retain];
        }
    }
    return _sect131r1;
}

+ (ASN1ObjectIdentifier *)sect131r2 {
    static ASN1ObjectIdentifier *_sect131r2 = nil;
    @synchronized(self) {
        if (!_sect131r2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"23"] retain];
            }
            _sect131r2 = [branchObj retain];
        }
    }
    return _sect131r2;
}

+ (ASN1ObjectIdentifier *)sect193r1 {
    static ASN1ObjectIdentifier *_sect193r1 = nil;
    @synchronized(self) {
        if (!_sect193r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"24"] retain];
            }
            _sect193r1 = [branchObj retain];
        }
    }
    return _sect193r1;
}

+ (ASN1ObjectIdentifier *)sect193r2 {
    static ASN1ObjectIdentifier *_sect193r2 = nil;
    @synchronized(self) {
        if (!_sect193r2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"25"] retain];
            }
            _sect193r2 = [branchObj retain];
        }
    }
    return _sect193r2;
}

+ (ASN1ObjectIdentifier *)sect233k1 {
    static ASN1ObjectIdentifier *_sect233k1 = nil;
    @synchronized(self) {
        if (!_sect233k1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"26"] retain];
            }
            _sect233k1 = [branchObj retain];
        }
    }
    return _sect233k1;
}

+ (ASN1ObjectIdentifier *)sect233r1 {
    static ASN1ObjectIdentifier *_sect233r1 = nil;
    @synchronized(self) {
        if (!_sect233r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"27"] retain];
            }
            _sect233r1 = [branchObj retain];
        }
    }
    return _sect233r1;
}

+ (ASN1ObjectIdentifier *)secp128r1 {
    static ASN1ObjectIdentifier *_secp128r1 = nil;
    @synchronized(self) {
        if (!_secp128r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"28"] retain];
            }
            _secp128r1 = [branchObj retain];
        }
    }
    return _secp128r1;
}

+ (ASN1ObjectIdentifier *)secp128r2 {
    static ASN1ObjectIdentifier *_secp128r2 = nil;
    @synchronized(self) {
        if (!_secp128r2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"29"] retain];
            }
            _secp128r2 = [branchObj retain];
        }
    }
    return _secp128r2;
}

+ (ASN1ObjectIdentifier *)secp160r2 {
    static ASN1ObjectIdentifier *_secp160r2 = nil;
    @synchronized(self) {
        if (!_secp160r2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"30"] retain];
            }
            _secp160r2 = [branchObj retain];
        }
    }
    return _secp160r2;
}

+ (ASN1ObjectIdentifier *)secp192k1 {
    static ASN1ObjectIdentifier *_secp192k1 = nil;
    @synchronized(self) {
        if (!_secp192k1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"31"] retain];
            }
            _secp192k1 = [branchObj retain];
        }
    }
    return _secp192k1;
}

+ (ASN1ObjectIdentifier *)secp224k1 {
    static ASN1ObjectIdentifier *_secp224k1 = nil;
    @synchronized(self) {
        if (!_secp224k1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"32"] retain];
            }
            _secp224k1 = [branchObj retain];
        }
    }
    return _secp224k1;
}

+ (ASN1ObjectIdentifier *)secp224r1 {
    static ASN1ObjectIdentifier *_secp224r1 = nil;
    @synchronized(self) {
        if (!_secp224r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"33"] retain];
            }
            _secp224r1 = [branchObj retain];
        }
    }
    return _secp224r1;
}

+ (ASN1ObjectIdentifier *)secp384r1 {
    static ASN1ObjectIdentifier *_secp384r1 = nil;
    @synchronized(self) {
        if (!_secp384r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"34"] retain];
            }
            _secp384r1 = [branchObj retain];
        }
    }
    return _secp384r1;
}

+ (ASN1ObjectIdentifier *)secp521r1 {
    static ASN1ObjectIdentifier *_secp521r1 = nil;
    @synchronized(self) {
        if (!_secp521r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"35"] retain];
            }
            _secp521r1 = [branchObj retain];
        }
    }
    return _secp521r1;
}

+ (ASN1ObjectIdentifier *)sect409k1 {
    static ASN1ObjectIdentifier *_sect409k1 = nil;
    @synchronized(self) {
        if (!_sect409k1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"36"] retain];
            }
            _sect409k1 = [branchObj retain];
        }
    }
    return _sect409k1;
}

+ (ASN1ObjectIdentifier *)sect409r1 {
    static ASN1ObjectIdentifier *_sect409r1 = nil;
    @synchronized(self) {
        if (!_sect409r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"37"] retain];
            }
            _sect409r1 = [branchObj retain];
        }
    }
    return _sect409r1;
}

+ (ASN1ObjectIdentifier *)sect571k1 {
    static ASN1ObjectIdentifier *_sect571k1 = nil;
    @synchronized(self) {
        if (!_sect571k1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"38"] retain];
            }
            _sect571k1 = [branchObj retain];
        }
    }
    return _sect571k1;
}

+ (ASN1ObjectIdentifier *)sect571r1 {
    static ASN1ObjectIdentifier *_sect571r1 = nil;
    @synchronized(self) {
        if (!_sect571r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"39"] retain];
            }
            _sect571r1 = [branchObj retain];
        }
    }
    return _sect571r1;
}

+ (ASN1ObjectIdentifier *)secp192r1 {
    static ASN1ObjectIdentifier *_secp192r1 = nil;
    @synchronized(self) {
        if (!_secp192r1) {
            _secp192r1 = [[X9ObjectIdentifiers prime192v1] retain];
        }
    }
    return _secp192r1;
}

+ (ASN1ObjectIdentifier *)secp256r1 {
    static ASN1ObjectIdentifier *_secp256r1 = nil;
    @synchronized(self) {
        if (!_secp256r1) {
            _secp256r1 = [[X9ObjectIdentifiers prime256v1] retain];
        }
    }
    return _secp256r1;
}

+ (ASN1ObjectIdentifier *)secg_scheme {
    static ASN1ObjectIdentifier *_secg_scheme = nil;
    @synchronized(self) {
        if (!_secg_scheme) {
            _secg_scheme = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.132.1"];
        }
    }
    return _secg_scheme;
}

+ (ASN1ObjectIdentifier *)dhSinglePass_stdDH_sha224kdf_scheme {
    static ASN1ObjectIdentifier *_dhSinglePass_stdDH_sha224kdf_scheme = nil;
    @synchronized(self) {
        if (!_dhSinglePass_stdDH_sha224kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"11.0"] retain];
            }
            _dhSinglePass_stdDH_sha224kdf_scheme = [branchObj retain];
        }
    }
    return _dhSinglePass_stdDH_sha224kdf_scheme;
}

+ (ASN1ObjectIdentifier *)dhSinglePass_stdDH_sha256kdf_scheme {
    static ASN1ObjectIdentifier *_dhSinglePass_stdDH_sha256kdf_scheme = nil;
    @synchronized(self) {
        if (!_dhSinglePass_stdDH_sha256kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"11.1"] retain];
            }
            _dhSinglePass_stdDH_sha256kdf_scheme = [branchObj retain];
        }
    }
    return _dhSinglePass_stdDH_sha256kdf_scheme;
}

+ (ASN1ObjectIdentifier *)dhSinglePass_stdDH_sha384kdf_scheme {
    static ASN1ObjectIdentifier *_dhSinglePass_stdDH_sha384kdf_scheme = nil;
    @synchronized(self) {
        if (!_dhSinglePass_stdDH_sha384kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"11.2"] retain];
            }
            _dhSinglePass_stdDH_sha384kdf_scheme = [branchObj retain];
        }
    }
    return _dhSinglePass_stdDH_sha384kdf_scheme;
}

+ (ASN1ObjectIdentifier *)dhSinglePass_stdDH_sha512kdf_scheme {
    static ASN1ObjectIdentifier *_dhSinglePass_stdDH_sha512kdf_scheme = nil;
    @synchronized(self) {
        if (!_dhSinglePass_stdDH_sha512kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"11.3"] retain];
            }
            _dhSinglePass_stdDH_sha512kdf_scheme = [branchObj retain];
        }
    }
    return _dhSinglePass_stdDH_sha512kdf_scheme;
}

+ (ASN1ObjectIdentifier *)dhSinglePass_cofactorDH_sha224kdf_scheme {
    static ASN1ObjectIdentifier *_dhSinglePass_cofactorDH_sha224kdf_scheme = nil;
    @synchronized(self) {
        if (!_dhSinglePass_cofactorDH_sha224kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"14.0"] retain];
            }
            _dhSinglePass_cofactorDH_sha224kdf_scheme = [branchObj retain];
        }
    }
    return _dhSinglePass_cofactorDH_sha224kdf_scheme;
}

+ (ASN1ObjectIdentifier *)dhSinglePass_cofactorDH_sha256kdf_scheme {
    static ASN1ObjectIdentifier *_dhSinglePass_cofactorDH_sha256kdf_scheme = nil;
    @synchronized(self) {
        if (!_dhSinglePass_cofactorDH_sha256kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"14.1"] retain];
            }
            _dhSinglePass_cofactorDH_sha256kdf_scheme = [branchObj retain];
        }
    }
    return _dhSinglePass_cofactorDH_sha256kdf_scheme;
}

+ (ASN1ObjectIdentifier *)dhSinglePass_cofactorDH_sha384kdf_scheme {
    static ASN1ObjectIdentifier *_dhSinglePass_cofactorDH_sha384kdf_scheme = nil;
    @synchronized(self) {
        if (!_dhSinglePass_cofactorDH_sha384kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"14.2"] retain];
            }
            _dhSinglePass_cofactorDH_sha384kdf_scheme = [branchObj retain];
        }
    }
    return _dhSinglePass_cofactorDH_sha384kdf_scheme;
}

+ (ASN1ObjectIdentifier *)dhSinglePass_cofactorDH_sha512kdf_scheme {
    static ASN1ObjectIdentifier *_dhSinglePass_cofactorDH_sha512kdf_scheme = nil;
    @synchronized(self) {
        if (!_dhSinglePass_cofactorDH_sha512kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"14.3"] retain];
            }
            _dhSinglePass_cofactorDH_sha512kdf_scheme = [branchObj retain];
        }
    }
    return _dhSinglePass_cofactorDH_sha512kdf_scheme;
}

+ (ASN1ObjectIdentifier *)mqvSinglePass_sha224kdf_scheme {
    static ASN1ObjectIdentifier *_mqvSinglePass_sha224kdf_scheme = nil;
    @synchronized(self) {
        if (!_mqvSinglePass_sha224kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"15.0"] retain];
            }
            _mqvSinglePass_sha224kdf_scheme = [branchObj retain];
        }
    }
    return _mqvSinglePass_sha224kdf_scheme;
}

+ (ASN1ObjectIdentifier *)mqvSinglePass_sha256kdf_scheme {
    static ASN1ObjectIdentifier *_mqvSinglePass_sha256kdf_scheme = nil;
    @synchronized(self) {
        if (!_mqvSinglePass_sha256kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"15.1"] retain];
            }
            _mqvSinglePass_sha256kdf_scheme = [branchObj retain];
        }
    }
    return _mqvSinglePass_sha256kdf_scheme;
}

+ (ASN1ObjectIdentifier *)mqvSinglePass_sha384kdf_scheme {
    static ASN1ObjectIdentifier *_mqvSinglePass_sha384kdf_scheme = nil;
    @synchronized(self) {
        if (!_mqvSinglePass_sha384kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"15.2"] retain];
            }
            _mqvSinglePass_sha384kdf_scheme = [branchObj retain];
        }
    }
    return _mqvSinglePass_sha384kdf_scheme;
}

+ (ASN1ObjectIdentifier *)mqvSinglePass_sha512kdf_scheme {
    static ASN1ObjectIdentifier *_mqvSinglePass_sha512kdf_scheme = nil;
    @synchronized(self) {
        if (!_mqvSinglePass_sha512kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"15.3"] retain];
            }
            _mqvSinglePass_sha512kdf_scheme = [branchObj retain];
        }
    }
    return _mqvSinglePass_sha512kdf_scheme;
}

+ (ASN1ObjectIdentifier *)mqvFull_sha224kdf_scheme {
    static ASN1ObjectIdentifier *_mqvFull_sha224kdf_scheme = nil;
    @synchronized(self) {
        if (!_mqvFull_sha224kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"16.0"] retain];
            }
            _mqvFull_sha224kdf_scheme = [branchObj retain];
        }
    }
    return _mqvFull_sha224kdf_scheme;
}

+ (ASN1ObjectIdentifier *)mqvFull_sha256kdf_scheme {
    static ASN1ObjectIdentifier *_mqvFull_sha256kdf_scheme = nil;
    @synchronized(self) {
        if (!_mqvFull_sha256kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"16.1"] retain];
            }
            _mqvFull_sha256kdf_scheme = [branchObj retain];
        }
    }
    return _mqvFull_sha256kdf_scheme;
}

+ (ASN1ObjectIdentifier *)mqvFull_sha384kdf_scheme {
    static ASN1ObjectIdentifier *_mqvFull_sha384kdf_scheme = nil;
    @synchronized(self) {
        if (!_mqvFull_sha384kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"16.2"] retain];
            }
            _mqvFull_sha384kdf_scheme = [branchObj retain];
        }
    }
    return _mqvFull_sha384kdf_scheme;
}

+ (ASN1ObjectIdentifier *)mqvFull_sha512kdf_scheme {
    static ASN1ObjectIdentifier *_mqvFull_sha512kdf_scheme = nil;
    @synchronized(self) {
        if (!_mqvFull_sha512kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self secg_scheme] branch:@"16.3"] retain];
            }
            _mqvFull_sha512kdf_scheme = [branchObj retain];
        }
    }
    return _mqvFull_sha512kdf_scheme;
}

@end
