//
//  X9ObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X9ObjectIdentifiers.h"

@implementation X9ObjectIdentifiers

+ (ASN1ObjectIdentifier *)ansi_X9_62 {
    static ASN1ObjectIdentifier *_ansi_X9_62 = nil;
    @synchronized(self) {
        if (!_ansi_X9_62) {
            _ansi_X9_62 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.10045"];
        }
    }
    return _ansi_X9_62;
}

+ (ASN1ObjectIdentifier *)id_fieldType {
    static ASN1ObjectIdentifier *_id_fieldType = nil;
    @synchronized(self) {
        if (!_id_fieldType) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ansi_X9_62] branch:@"1"] retain];
            }
            _id_fieldType = [branchObj retain];
        }
    }
    return _id_fieldType;
}

+ (ASN1ObjectIdentifier *)prime_field {
    static ASN1ObjectIdentifier *_prime_field = nil;
    @synchronized(self) {
        if (!_prime_field) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_fieldType] branch:@"1"] retain];
            }
            _prime_field = [branchObj retain];
        }
    }
    return _prime_field;
}

+ (ASN1ObjectIdentifier *)characteristic_two_field {
    static ASN1ObjectIdentifier *_characteristic_two_field = nil;
    @synchronized(self) {
        if (!_characteristic_two_field) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_fieldType] branch:@"2"] retain];
            }
            _characteristic_two_field = [branchObj retain];
        }
    }
    return _characteristic_two_field;
}

+ (ASN1ObjectIdentifier *)gnBasis {
    static ASN1ObjectIdentifier *_gnBasis = nil;
    @synchronized(self) {
        if (!_gnBasis) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self characteristic_two_field] branch:@"3.1"] retain];
            }
            _gnBasis = [branchObj retain];
        }
    }
    return _gnBasis;
}

+ (ASN1ObjectIdentifier *)tpBasis {
    static ASN1ObjectIdentifier *_tpBasis = nil;
    @synchronized(self) {
        if (!_tpBasis) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self characteristic_two_field] branch:@"3.2"] retain];
            }
            _tpBasis = [branchObj retain];
        }
    }
    return _tpBasis;
}

+ (ASN1ObjectIdentifier *)ppBasis {
    static ASN1ObjectIdentifier *_ppBasis = nil;
    @synchronized(self) {
        if (!_ppBasis) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self characteristic_two_field] branch:@"3.3"] retain];
            }
            _ppBasis = [branchObj retain];
        }
    }
    return _ppBasis;
}

+ (ASN1ObjectIdentifier *)id_ecSigType {
    static ASN1ObjectIdentifier *_id_ecSigType = nil;
    @synchronized(self) {
        if (!_id_ecSigType) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ansi_X9_62] branch:@"4"] retain];
            }
            _id_ecSigType = [branchObj retain];
        }
    }
    return _id_ecSigType;
}

+ (ASN1ObjectIdentifier *)ecdsa_with_SHA1 {
    static ASN1ObjectIdentifier *_ecdsa_with_SHA1 = nil;
    @synchronized(self) {
        if (!_ecdsa_with_SHA1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_ecSigType] branch:@"1"] retain];
            }
            _ecdsa_with_SHA1 = [branchObj retain];
        }
    }
    return _ecdsa_with_SHA1;
}

+ (ASN1ObjectIdentifier *)id_publicKeyType {
    static ASN1ObjectIdentifier *_id_publicKeyType = nil;
    @synchronized(self) {
        if (!_id_publicKeyType) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ansi_X9_62] branch:@"2"] retain];
            }
            _id_publicKeyType = [branchObj retain];
        }
    }
    return _id_publicKeyType;
}

+ (ASN1ObjectIdentifier *)id_ecPublicKey {
    static ASN1ObjectIdentifier *_id_ecPublicKey = nil;
    @synchronized(self) {
        if (!_id_ecPublicKey) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_publicKeyType] branch:@"1"] retain];
            }
            _id_ecPublicKey = [branchObj retain];
        }
    }
    return _id_ecPublicKey;
}

+ (ASN1ObjectIdentifier *)ecdsa_with_SHA2 {
    static ASN1ObjectIdentifier *_ecdsa_with_SHA2 = nil;
    @synchronized(self) {
        if (!_ecdsa_with_SHA2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_ecSigType] branch:@"3"] retain];
            }
            _ecdsa_with_SHA2 = [branchObj retain];
        }
    }
    return _ecdsa_with_SHA2;
}

+ (ASN1ObjectIdentifier *)ecdsa_with_SHA224 {
    static ASN1ObjectIdentifier *_ecdsa_with_SHA224 = nil;
    @synchronized(self) {
        if (!_ecdsa_with_SHA224) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ecdsa_with_SHA2] branch:@"1"] retain];
            }
            _ecdsa_with_SHA224 = [branchObj retain];
        }
    }
    return _ecdsa_with_SHA224;
}

+ (ASN1ObjectIdentifier *)ecdsa_with_SHA256 {
    static ASN1ObjectIdentifier *_ecdsa_with_SHA256 = nil;
    @synchronized(self) {
        if (!_ecdsa_with_SHA256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ecdsa_with_SHA2] branch:@"2"] retain];
            }
            _ecdsa_with_SHA256 = [branchObj retain];
        }
    }
    return _ecdsa_with_SHA256;
}

+ (ASN1ObjectIdentifier *)ecdsa_with_SHA384 {
    static ASN1ObjectIdentifier *_ecdsa_with_SHA384 = nil;
    @synchronized(self) {
        if (!_ecdsa_with_SHA384) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ecdsa_with_SHA2] branch:@"3"] retain];
            }
            _ecdsa_with_SHA384 = [branchObj retain];
        }
    }
    return _ecdsa_with_SHA384;
}

+ (ASN1ObjectIdentifier *)ecdsa_with_SHA512 {
    static ASN1ObjectIdentifier *_ecdsa_with_SHA512 = nil;
    @synchronized(self) {
        if (!_ecdsa_with_SHA512) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ecdsa_with_SHA2] branch:@"4"] retain];
            }
            _ecdsa_with_SHA512 = [branchObj retain];
        }
    }
    return _ecdsa_with_SHA512;
}

+ (ASN1ObjectIdentifier *)ellipticCurve {
    static ASN1ObjectIdentifier *_ellipticCurve = nil;
    @synchronized(self) {
        if (!_ellipticCurve) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ansi_X9_62] branch:@"3"] retain];
            }
            _ellipticCurve = [branchObj retain];
        }
    }
    return _ellipticCurve;
}

+ (ASN1ObjectIdentifier *)cTwoCurve {
    static ASN1ObjectIdentifier *_cTwoCurve = nil;
    @synchronized(self) {
        if (!_cTwoCurve) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"0"] retain];
            }
            _cTwoCurve = [branchObj retain];
        }
    }
    return _cTwoCurve;
}

+ (ASN1ObjectIdentifier *)c2pnb163v1 {
    static ASN1ObjectIdentifier *_c2pnb163v1 = nil;
    @synchronized(self) {
        if (!_c2pnb163v1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"1"] retain];
            }
            _c2pnb163v1 = [branchObj retain];
        }
    }
    return _c2pnb163v1;
}

+ (ASN1ObjectIdentifier *)c2pnb163v2{
    static ASN1ObjectIdentifier *_c2pnb163v2 = nil;
    @synchronized(self) {
        if (!_c2pnb163v2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"2"] retain];
            }
            _c2pnb163v2 = [branchObj retain];
        }
    }
    return _c2pnb163v2;
}
+ (ASN1ObjectIdentifier *)c2pnb163v3 {
    static ASN1ObjectIdentifier *_c2pnb163v3 = nil;
    @synchronized(self) {
        if (!_c2pnb163v3) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"3"] retain];
            }
            _c2pnb163v3 = [branchObj retain];
        }
    }
    return _c2pnb163v3;
}

+ (ASN1ObjectIdentifier *)c2pnb176w1 {
    static ASN1ObjectIdentifier *_c2pnb176w1 = nil;
    @synchronized(self) {
        if (!_c2pnb176w1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"4"] retain];
            }
            _c2pnb176w1 = [branchObj retain];
        }
    }
    return _c2pnb176w1;
}

+ (ASN1ObjectIdentifier *)c2tnb191v1 {
    static ASN1ObjectIdentifier *_c2tnb191v1 = nil;
    @synchronized(self) {
        if (!_c2tnb191v1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"5"] retain];
            }
            _c2tnb191v1 = [branchObj retain];
        }
    }
    return _c2tnb191v1;
}

+ (ASN1ObjectIdentifier *)c2tnb191v2 {
    static ASN1ObjectIdentifier *_c2tnb191v2 = nil;
    @synchronized(self) {
        if (!_c2tnb191v2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"6"] retain];
            }
            _c2tnb191v2 = [branchObj retain];
        }
    }
    return _c2tnb191v2;
}

+ (ASN1ObjectIdentifier *)c2tnb191v3 {
    static ASN1ObjectIdentifier *_c2tnb191v3 = nil;
    @synchronized(self) {
        if (!_c2tnb191v3) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"7"] retain];
            }
            _c2tnb191v3 = [branchObj retain];
        }
    }
    return _c2tnb191v3;
}

+ (ASN1ObjectIdentifier *)c2onb191v4 {
    static ASN1ObjectIdentifier *_c2onb191v4 = nil;
    @synchronized(self) {
        if (!_c2onb191v4) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"8"] retain];
            }
            _c2onb191v4 = [branchObj retain];
        }
    }
    return _c2onb191v4;
}

+ (ASN1ObjectIdentifier *)c2onb191v5 {
    static ASN1ObjectIdentifier *_c2onb191v5 = nil;
    @synchronized(self) {
        if (!_c2onb191v5) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"9"] retain];
            }
            _c2onb191v5 = [branchObj retain];
        }
    }
    return _c2onb191v5;
}

+ (ASN1ObjectIdentifier *)c2pnb208w1 {
    static ASN1ObjectIdentifier *_c2pnb208w1 = nil;
    @synchronized(self) {
        if (!_c2pnb208w1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"10"] retain];
            }
            _c2pnb208w1 = [branchObj retain];
        }
    }
    return _c2pnb208w1;
}

+ (ASN1ObjectIdentifier *)c2tnb239v1 {
    static ASN1ObjectIdentifier *_c2tnb239v1 = nil;
    @synchronized(self) {
        if (!_c2tnb239v1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"11"] retain];
            }
            _c2tnb239v1 = [branchObj retain];
        }
    }
    return _c2tnb239v1;
}

+ (ASN1ObjectIdentifier *)c2tnb239v2 {
    static ASN1ObjectIdentifier *_c2tnb239v2 = nil;
    @synchronized(self) {
        if (!_c2tnb239v2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"12"] retain];
            }
            _c2tnb239v2 = [branchObj retain];
        }
    }
    return _c2tnb239v2;
}

+ (ASN1ObjectIdentifier *)c2tnb239v3 {
    static ASN1ObjectIdentifier *_c2tnb239v3 = nil;
    @synchronized(self) {
        if (!_c2tnb239v3) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"13"] retain];
            }
            _c2tnb239v3 = [branchObj retain];
        }
    }
    return _c2tnb239v3;
}

+ (ASN1ObjectIdentifier *)c2onb239v4 {
    static ASN1ObjectIdentifier *_c2onb239v4 = nil;
    @synchronized(self) {
        if (!_c2onb239v4) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"14"] retain];
            }
            _c2onb239v4 = [branchObj retain];
        }
    }
    return _c2onb239v4;
}

+ (ASN1ObjectIdentifier *)c2onb239v5 {
    static ASN1ObjectIdentifier *_c2onb239v5 = nil;
    @synchronized(self) {
        if (!_c2onb239v5) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"15"] retain];
            }
            _c2onb239v5 = [branchObj retain];
        }
    }
    return _c2onb239v5;
}

+ (ASN1ObjectIdentifier *)c2pnb272w1 {
    static ASN1ObjectIdentifier *_c2pnb272w1 = nil;
    @synchronized(self) {
        if (!_c2pnb272w1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"16"] retain];
            }
            _c2pnb272w1 = [branchObj retain];
        }
    }
    return _c2pnb272w1;
}

+ (ASN1ObjectIdentifier *)c2pnb304w1 {
    static ASN1ObjectIdentifier *_c2pnb304w1 = nil;
    @synchronized(self) {
        if (!_c2pnb304w1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"17"] retain];
            }
            _c2pnb304w1 = [branchObj retain];
        }
    }
    return _c2pnb304w1;
}

+ (ASN1ObjectIdentifier *)c2tnb359v1 {
    static ASN1ObjectIdentifier *_c2tnb359v1 = nil;
    @synchronized(self) {
        if (!_c2tnb359v1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"18"] retain];
            }
            _c2tnb359v1 = [branchObj retain];
        }
    }
    return _c2tnb359v1;
}

+ (ASN1ObjectIdentifier *)c2pnb368w1 {
    static ASN1ObjectIdentifier *_c2pnb368w1 = nil;
    @synchronized(self) {
        if (!_c2pnb368w1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"19"] retain];
            }
            _c2pnb368w1 = [branchObj retain];
        }
    }
    return _c2pnb368w1;
}

+ (ASN1ObjectIdentifier *)c2tnb431r1 {
    static ASN1ObjectIdentifier *_c2tnb431r1 = nil;
    @synchronized(self) {
        if (!_c2tnb431r1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self cTwoCurve] branch:@"20"] retain];
            }
            _c2tnb431r1 = [branchObj retain];
        }
    }
    return _c2tnb431r1;
}

+ (ASN1ObjectIdentifier *)primeCurve {
    static ASN1ObjectIdentifier *_primeCurve = nil;
    @synchronized(self) {
        if (!_primeCurve) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ellipticCurve] branch:@"1"] retain];
            }
            _primeCurve = [branchObj retain];
        }
    }
    return _primeCurve;
}

+ (ASN1ObjectIdentifier *)prime192v1 {
    static ASN1ObjectIdentifier *_prime192v1 = nil;
    @synchronized(self) {
        if (!_prime192v1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self primeCurve] branch:@"1"] retain];
            }
            _prime192v1 = [branchObj retain];
        }
    }
    return _prime192v1;
}

+ (ASN1ObjectIdentifier *)prime192v2 {
    static ASN1ObjectIdentifier *_prime192v2 = nil;
    @synchronized(self) {
        if (!_prime192v2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self primeCurve] branch:@"2"] retain];
            }
            _prime192v2 = [branchObj retain];
        }
    }
    return _prime192v2;
}

+ (ASN1ObjectIdentifier *)prime192v3 {
    static ASN1ObjectIdentifier *_prime192v3 = nil;
    @synchronized(self) {
        if (!_prime192v3) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self primeCurve] branch:@"3"] retain];
            }
            _prime192v3 = [branchObj retain];
        }
    }
    return _prime192v3;
}

+ (ASN1ObjectIdentifier *)prime239v1 {
    static ASN1ObjectIdentifier *_prime239v1 = nil;
    @synchronized(self) {
        if (!_prime239v1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self primeCurve] branch:@"4"] retain];
            }
            _prime239v1 = [branchObj retain];
        }
    }
    return _prime239v1;
}

+ (ASN1ObjectIdentifier *)prime239v2 {
    static ASN1ObjectIdentifier *_prime239v2 = nil;
    @synchronized(self) {
        if (!_prime239v2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self primeCurve] branch:@"5"] retain];
            }
            _prime239v2 = [branchObj retain];
        }
    }
    return _prime239v2;
}

+ (ASN1ObjectIdentifier *)prime239v3 {
    static ASN1ObjectIdentifier *_prime239v3 = nil;
    @synchronized(self) {
        if (!_prime239v3) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self primeCurve] branch:@"6"] retain];
            }
            _prime239v3 = [branchObj retain];
        }
    }
    return _prime239v3;
}

+ (ASN1ObjectIdentifier *)prime256v1 {
    static ASN1ObjectIdentifier *_prime256v1 = nil;
    @synchronized(self) {
        if (!_prime256v1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self primeCurve] branch:@"7"] retain];
            }
            _prime256v1 = [branchObj retain];
        }
    }
    return _prime256v1;
}

+ (ASN1ObjectIdentifier *)id_dsa {
    static ASN1ObjectIdentifier *_id_dsa = nil;
    @synchronized(self) {
        if (!_id_dsa) {
            _id_dsa = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.10040.4.1"];
        }
    }
    return _id_dsa;
}

+ (ASN1ObjectIdentifier *)id_dsa_with_sha1 {
    static ASN1ObjectIdentifier *_id_dsa_with_sha1 = nil;
    @synchronized(self) {
        if (!_id_dsa_with_sha1) {
            _id_dsa_with_sha1 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.10040.4.3"];
        }
    }
    return _id_dsa_with_sha1;
}

+ (ASN1ObjectIdentifier *)x9_63_scheme {
    static ASN1ObjectIdentifier *_x9_63_scheme = nil;
    @synchronized(self) {
        if (!_x9_63_scheme) {
            _x9_63_scheme = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.133.16.840.63.0"];
        }
    }
    return _x9_63_scheme;
}

+ (ASN1ObjectIdentifier *)dhSinglePass_stdDH_sha1kdf_scheme {
    static ASN1ObjectIdentifier *_dhSinglePass_stdDH_sha1kdf_scheme = nil;
    @synchronized(self) {
        if (!_dhSinglePass_stdDH_sha1kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self x9_63_scheme] branch:@"2"] retain];
            }
            _dhSinglePass_stdDH_sha1kdf_scheme = [branchObj retain];
        }
    }
    return _dhSinglePass_stdDH_sha1kdf_scheme;
}

+ (ASN1ObjectIdentifier *)dhSinglePass_cofactorDH_sha1kdf_scheme {
    static ASN1ObjectIdentifier *_dhSinglePass_cofactorDH_sha1kdf_scheme = nil;
    @synchronized(self) {
        if (!_dhSinglePass_cofactorDH_sha1kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self x9_63_scheme] branch:@"3"] retain];
            }
            _dhSinglePass_cofactorDH_sha1kdf_scheme = [branchObj retain];
        }
    }
    return _dhSinglePass_cofactorDH_sha1kdf_scheme;
}

+ (ASN1ObjectIdentifier *)mqvSinglePass_sha1kdf_scheme {
    static ASN1ObjectIdentifier *_mqvSinglePass_sha1kdf_scheme = nil;
    @synchronized(self) {
        if (!_mqvSinglePass_sha1kdf_scheme) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self x9_63_scheme] branch:@"16"] retain];
            }
            _mqvSinglePass_sha1kdf_scheme = [branchObj retain];
        }
    }
    return _mqvSinglePass_sha1kdf_scheme;
}

+ (ASN1ObjectIdentifier *)ansi_X9_42 {
    static ASN1ObjectIdentifier *_ansi_X9_42 = nil;
    @synchronized(self) {
        if (!_ansi_X9_42) {
            _ansi_X9_42 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.10046"];
        }
    }
    return _ansi_X9_42;
}

+ (ASN1ObjectIdentifier *)dhpublicnumber {
    static ASN1ObjectIdentifier *_dhpublicnumber = nil;
    @synchronized(self) {
        if (!_dhpublicnumber) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ansi_X9_42] branch:@"2.1"] retain];
            }
            _dhpublicnumber = [branchObj retain];
        }
    }
    return _dhpublicnumber;
}

+ (ASN1ObjectIdentifier *)x9_42_schemes {
    static ASN1ObjectIdentifier *_x9_42_schemes = nil;
    @synchronized(self) {
        if (!_x9_42_schemes) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self ansi_X9_42] branch:@"3"] retain];
            }
            _x9_42_schemes = [branchObj retain];
        }
    }
    return _x9_42_schemes;
}

+ (ASN1ObjectIdentifier *)dhStatic {
    static ASN1ObjectIdentifier *_dhStatic = nil;
    @synchronized(self) {
        if (!_dhStatic) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self x9_42_schemes] branch:@"1"] retain];
            }
            _dhStatic = [branchObj retain];
        }
    }
    return _dhStatic;
}

+ (ASN1ObjectIdentifier *)dhEphem {
    static ASN1ObjectIdentifier *_dhEphem = nil;
    @synchronized(self) {
        if (!_dhEphem) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self x9_42_schemes] branch:@"2"] retain];
            }
            _dhEphem = [branchObj retain];
        }
    }
    return _dhEphem;
}

+ (ASN1ObjectIdentifier *)dhOneFlow {
    static ASN1ObjectIdentifier *_dhOneFlow = nil;
    @synchronized(self) {
        if (!_dhOneFlow) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self x9_42_schemes] branch:@"3"] retain];
            }
            _dhOneFlow = [branchObj retain];
        }
    }
    return _dhOneFlow;
}

+ (ASN1ObjectIdentifier *)dhHybrid1 {
    static ASN1ObjectIdentifier *_dhHybrid1 = nil;
    @synchronized(self) {
        if (!_dhHybrid1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self x9_42_schemes] branch:@"4"] retain];
            }
            _dhHybrid1 = [branchObj retain];
        }
    }
    return _dhHybrid1;
}

+ (ASN1ObjectIdentifier *)dhHybrid2 {
    static ASN1ObjectIdentifier *_dhHybrid2 = nil;
    @synchronized(self) {
        if (!_dhHybrid2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self x9_42_schemes] branch:@"5"] retain];
            }
            _dhHybrid2 = [branchObj retain];
        }
    }
    return _dhHybrid2;
}

+ (ASN1ObjectIdentifier *)dhHybridOneFlow {
    static ASN1ObjectIdentifier *_dhHybridOneFlow = nil;
    @synchronized(self) {
        if (!_dhHybridOneFlow) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self x9_42_schemes] branch:@"6"] retain];
            }
            _dhHybridOneFlow = [branchObj retain];
        }
    }
    return _dhHybridOneFlow;
}

+ (ASN1ObjectIdentifier *)mqv2 {
    static ASN1ObjectIdentifier *_mqv2 = nil;
    @synchronized(self) {
        if (!_mqv2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self x9_42_schemes] branch:@"7"] retain];
            }
            _mqv2 = [branchObj retain];
        }
    }
    return _mqv2;
}

+ (ASN1ObjectIdentifier *)mqv1 {
    static ASN1ObjectIdentifier *_mqv1 = nil;
    @synchronized(self) {
        if (!_mqv1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self x9_42_schemes] branch:@"8"] retain];
            }
            _mqv1 = [branchObj retain];
        }
    }
    return _mqv1;
}

+ (ASN1ObjectIdentifier *)x9_44 {
    static ASN1ObjectIdentifier *_x9_44 = nil;
    @synchronized(self) {
        if (!_x9_44) {
            _x9_44 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.133.16.840.9.44"];
        }
    }
    return _x9_44;
}

+ (ASN1ObjectIdentifier *)x9_44_components {
    static ASN1ObjectIdentifier *_x9_44_components = nil;
    @synchronized(self) {
        if (!_x9_44_components) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self x9_44] branch:@"1"] retain];
            }
            _x9_44_components = [branchObj retain];
        }
    }
    return _x9_44_components;
}

+ (ASN1ObjectIdentifier *)id_kdf_kdf2 {
    static ASN1ObjectIdentifier *_id_kdf_kdf2 = nil;
    @synchronized(self) {
        if (!_id_kdf_kdf2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self x9_44_components] branch:@"1"] retain];
            }
            _id_kdf_kdf2 = [branchObj retain];
        }
    }
    return _id_kdf_kdf2;
}

+ (ASN1ObjectIdentifier *)id_kdf_kdf3 {
    static ASN1ObjectIdentifier *_id_kdf_kdf3 = nil;
    @synchronized(self) {
        if (!_id_kdf_kdf3) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self x9_44_components] branch:@"2"] retain];
            }
            _id_kdf_kdf3 = [branchObj retain];
        }
    }
    return _id_kdf_kdf3;
}

@end
