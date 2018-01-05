//
//  CryptoProObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CryptoProObjectIdentifiers.h"

@implementation CryptoProObjectIdentifiers

+ (ASN1ObjectIdentifier *)GOST_id {
    static ASN1ObjectIdentifier *_GOST_id = nil;
    @synchronized(self) {
        if (!_GOST_id) {
            _GOST_id = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.643.2.2"];
        }
    }
    return _GOST_id;
}

+ (ASN1ObjectIdentifier *)gostR3411 {
    static ASN1ObjectIdentifier *_gostR3411 = nil;
    @synchronized(self) {
        if (!_gostR3411) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"9"] retain];
            }
            _gostR3411 = [branchObj retain];
        }
    }
    return _gostR3411;
}

+ (ASN1ObjectIdentifier *)gostR3411Hmac {
    static ASN1ObjectIdentifier *_gostR3411Hmac = nil;
    @synchronized(self) {
        if (!_gostR3411Hmac) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"10"] retain];
            }
            _gostR3411Hmac = [branchObj retain];
        }
    }
    return _gostR3411Hmac;
}

+ (ASN1ObjectIdentifier *)gostR28147_Cbc {
    static ASN1ObjectIdentifier *_gostR28147_cbc = nil;
    @synchronized(self) {
        if (!_gostR28147_cbc) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"21"] retain];
            }
            _gostR28147_cbc = [branchObj retain];
        }
    }
    return _gostR28147_cbc;
}

+ (ASN1ObjectIdentifier *)id_Gost28147_89_CryptoPro_A_ParamSet {
    static ASN1ObjectIdentifier *_id_Gost28147_89_CryptoPro_A_ParamSet = nil;
    @synchronized(self) {
        if (!_id_Gost28147_89_CryptoPro_A_ParamSet) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"31.1"] retain];
            }
            _id_Gost28147_89_CryptoPro_A_ParamSet = [branchObj retain];
        }
    }
    return _id_Gost28147_89_CryptoPro_A_ParamSet;
}

+ (ASN1ObjectIdentifier *)id_Gost28147_89_CryptoPro_B_ParamSet {
    static ASN1ObjectIdentifier *_id_Gost28147_89_CryptoPro_B_ParamSet = nil;
    @synchronized(self) {
        if (!_id_Gost28147_89_CryptoPro_B_ParamSet) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"31.2"] retain];
            }
            _id_Gost28147_89_CryptoPro_B_ParamSet = [branchObj retain];
        }
    }
    return _id_Gost28147_89_CryptoPro_B_ParamSet;
}

+ (ASN1ObjectIdentifier *)id_Gost28147_89_CryptoPro_C_ParamSet {
    static ASN1ObjectIdentifier *_id_Gost28147_89_CryptoPro_C_ParamSet = nil;
    @synchronized(self) {
        if (!_id_Gost28147_89_CryptoPro_C_ParamSet) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"31.3"] retain];
            }
            _id_Gost28147_89_CryptoPro_C_ParamSet = [branchObj retain];
        }
    }
    return _id_Gost28147_89_CryptoPro_C_ParamSet;
}

+ (ASN1ObjectIdentifier *)id_Gost28147_89_CryptoPro_D_ParamSet {
    static ASN1ObjectIdentifier *_id_Gost28147_89_CryptoPro_D_ParamSet = nil;
    @synchronized(self) {
        if (!_id_Gost28147_89_CryptoPro_D_ParamSet) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"31.4"] retain];
            }
            _id_Gost28147_89_CryptoPro_D_ParamSet = [branchObj retain];
        }
    }
    return _id_Gost28147_89_CryptoPro_D_ParamSet;
}

+ (ASN1ObjectIdentifier *)gostR3410_94 {
    static ASN1ObjectIdentifier *_gostR3410_94 = nil;
    @synchronized(self) {
        if (!_gostR3410_94) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"20"] retain];
            }
            _gostR3410_94 = [branchObj retain];
        }
    }
    return _gostR3410_94;
}

+ (ASN1ObjectIdentifier *)gostR3410_2001 {
    static ASN1ObjectIdentifier *_gostR3410_2001 = nil;
    @synchronized(self) {
        if (!_gostR3410_2001) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"19"] retain];
            }
            _gostR3410_2001 = [branchObj retain];
        }
    }
    return _gostR3410_2001;
}

+ (ASN1ObjectIdentifier *)gostR3411_94_with_gostR3410_94 {
    static ASN1ObjectIdentifier *_gostR3411_94_with_gostR3410_94 = nil;
    @synchronized(self) {
        if (!_gostR3411_94_with_gostR3410_94) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"4"] retain];
            }
            _gostR3411_94_with_gostR3410_94 = [branchObj retain];
        }
    }
    return _gostR3411_94_with_gostR3410_94;
}

+ (ASN1ObjectIdentifier *)gostR3411_94_with_gostR3410_2001 {
    static ASN1ObjectIdentifier *_gostR3411_94_with_gostR3410_2001 = nil;
    @synchronized(self) {
        if (!_gostR3411_94_with_gostR3410_2001) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"3"] retain];
            }
            _gostR3411_94_with_gostR3410_2001 = [branchObj retain];
        }
    }
    return _gostR3411_94_with_gostR3410_2001;
}

+ (ASN1ObjectIdentifier *)gostR3411_94_CryptoProParamSet {
    static ASN1ObjectIdentifier *_gostR3411_94_CryptoProParamSet = nil;
    @synchronized(self) {
        if (!_gostR3411_94_CryptoProParamSet) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"30.1"] retain];
            }
            _gostR3411_94_CryptoProParamSet = [branchObj retain];
        }
    }
    return _gostR3411_94_CryptoProParamSet;
}

+ (ASN1ObjectIdentifier *)gostR3410_94_CryptoPro_A {
    static ASN1ObjectIdentifier *_gostR3410_94_CryptoPro_A = nil;
    @synchronized(self) {
        if (!_gostR3410_94_CryptoPro_A) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"32.2"] retain];
            }
            _gostR3410_94_CryptoPro_A = [branchObj retain];
        }
    }
    return _gostR3410_94_CryptoPro_A;
}

+ (ASN1ObjectIdentifier *)gostR3410_94_CryptoPro_B {
    static ASN1ObjectIdentifier *_gostR3410_94_CryptoPro_B = nil;
    @synchronized(self) {
        if (!_gostR3410_94_CryptoPro_B) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"32.3"] retain];
            }
            _gostR3410_94_CryptoPro_B = [branchObj retain];
        }
    }
    return _gostR3410_94_CryptoPro_B;
}

+ (ASN1ObjectIdentifier *)gostR3410_94_CryptoPro_C {
    static ASN1ObjectIdentifier *_gostR3410_94_CryptoPro_C = nil;
    @synchronized(self) {
        if (!_gostR3410_94_CryptoPro_C) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"32.4"] retain];
            }
            _gostR3410_94_CryptoPro_C = [branchObj retain];
        }
    }
    return _gostR3410_94_CryptoPro_C;
}

+ (ASN1ObjectIdentifier *)gostR3410_94_CryptoPro_D {
    static ASN1ObjectIdentifier *_gostR3410_94_CryptoPro_D = nil;
    @synchronized(self) {
        if (!_gostR3410_94_CryptoPro_D) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"32.5"] retain];
            }
            _gostR3410_94_CryptoPro_D = [branchObj retain];
        }
    }
    return _gostR3410_94_CryptoPro_D;
}

+ (ASN1ObjectIdentifier *)gostR3410_94_CryptoPro_XchA {
    static ASN1ObjectIdentifier *_gostR3410_94_CryptoPro_XchA = nil;
    @synchronized(self) {
        if (!_gostR3410_94_CryptoPro_XchA) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"33.1"] retain];
            }
            _gostR3410_94_CryptoPro_XchA = [branchObj retain];
        }
    }
    return _gostR3410_94_CryptoPro_XchA;
}

+ (ASN1ObjectIdentifier *)gostR3410_94_CryptoPro_XchB {
    static ASN1ObjectIdentifier *_gostR3410_94_CryptoPro_XchB = nil;
    @synchronized(self) {
        if (!_gostR3410_94_CryptoPro_XchB) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"33.2"] retain];
            }
            _gostR3410_94_CryptoPro_XchB = [branchObj retain];
        }
    }
    return _gostR3410_94_CryptoPro_XchB;
}

+ (ASN1ObjectIdentifier *)gostR3410_94_CryptoPro_XchC {
    static ASN1ObjectIdentifier *_gostR3410_94_CryptoPro_XchC = nil;
    @synchronized(self) {
        if (!_gostR3410_94_CryptoPro_XchC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"33.3"] retain];
            }
            _gostR3410_94_CryptoPro_XchC = [branchObj retain];
        }
    }
    return _gostR3410_94_CryptoPro_XchC;
}

+ (ASN1ObjectIdentifier *)gostR3410_2001_CryptoPro_A {
    static ASN1ObjectIdentifier *_gostR3410_2001_CryptoPro_A = nil;
    @synchronized(self) {
        if (!_gostR3410_2001_CryptoPro_A) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"35.1"] retain];
            }
            _gostR3410_2001_CryptoPro_A = [branchObj retain];
        }
    }
    return _gostR3410_2001_CryptoPro_A;
}

+ (ASN1ObjectIdentifier *)gostR3410_2001_CryptoPro_B {
    static ASN1ObjectIdentifier *_gostR3410_2001_CryptoPro_B = nil;
    @synchronized(self) {
        if (!_gostR3410_2001_CryptoPro_B) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"35.2"] retain];
            }
            _gostR3410_2001_CryptoPro_B = [branchObj retain];
        }
    }
    return _gostR3410_2001_CryptoPro_B;
}

+ (ASN1ObjectIdentifier *)gostR3410_2001_CryptoPro_C {
    static ASN1ObjectIdentifier *_gostR3410_2001_CryptoPro_C = nil;
    @synchronized(self) {
        if (!_gostR3410_2001_CryptoPro_C) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"35.3"] retain];
            }
            _gostR3410_2001_CryptoPro_C = [branchObj retain];
        }
    }
    return _gostR3410_2001_CryptoPro_C;
}

+ (ASN1ObjectIdentifier *)gostR3410_2001_CryptoPro_XchA {
    static ASN1ObjectIdentifier *_gostR3410_2001_CryptoPro_XchA = nil;
    @synchronized(self) {
        if (!_gostR3410_2001_CryptoPro_XchA) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"36.0"] retain];
            }
            _gostR3410_2001_CryptoPro_XchA = [branchObj retain];
        }
    }
    return _gostR3410_2001_CryptoPro_XchA;
}

+ (ASN1ObjectIdentifier *)gostR3410_2001_CryptoPro_XchB {
    static ASN1ObjectIdentifier *_gostR3410_2001_CryptoPro_XchB = nil;
    @synchronized(self) {
        if (!_gostR3410_2001_CryptoPro_XchB) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"36.1"] retain];
            }
            _gostR3410_2001_CryptoPro_XchB = [branchObj retain];
        }
    }
    return _gostR3410_2001_CryptoPro_XchB;
}

+ (ASN1ObjectIdentifier *)gost_ElSgDH3410_default {
    static ASN1ObjectIdentifier *_gost_ElSgDH3410_default = nil;
    @synchronized(self) {
        if (!_gost_ElSgDH3410_default) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"36.0"] retain];
            }
            _gost_ElSgDH3410_default = [branchObj retain];
        }
    }
    return _gost_ElSgDH3410_default;
}

+ (ASN1ObjectIdentifier *)gost_ElSgDH3410_1 {
    static ASN1ObjectIdentifier *_gost_ElSgDH3410_1 = nil;
    @synchronized(self) {
        if (!_gost_ElSgDH3410_1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self GOST_id] branch:@"36.1"] retain];
            }
            _gost_ElSgDH3410_1 = [branchObj retain];
        }
    }
    return _gost_ElSgDH3410_1;
}


@end
