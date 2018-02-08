//
//  EACObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "EACObjectIdentifiers.h"

@implementation EACObjectIdentifiers

+ (ASN1ObjectIdentifier *)bsi_de {
    static ASN1ObjectIdentifier *_bsi_de = nil;
    @synchronized(self) {
        if (!_bsi_de) {
            _bsi_de = [[ASN1ObjectIdentifier alloc] initParamString:@"0.4.0.127.0.7"];
        }
    }
    return _bsi_de;
}

+ (ASN1ObjectIdentifier *)id_PK {
    static ASN1ObjectIdentifier *_id_PK = nil;
    @synchronized(self) {
        if (!_id_PK) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bsi_de] branch:@"2.2.1"] retain];
            }
            _id_PK = [branchObj retain];
        }
    }
    return _id_PK;
}

+ (ASN1ObjectIdentifier *)id_PK_DH {
    static ASN1ObjectIdentifier *_id_PK_DH = nil;
    @synchronized(self) {
        if (!_id_PK_DH) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_PK] branch:@"1"] retain];
            }
            _id_PK_DH = [branchObj retain];
        }
    }
    return _id_PK_DH;
}

+ (ASN1ObjectIdentifier *)id_PK_ECDH {
    static ASN1ObjectIdentifier *_id_PK_ECDH = nil;
    @synchronized(self) {
        if (!_id_PK_ECDH) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_PK] branch:@"2"] retain];
            }
            _id_PK_ECDH = [branchObj retain];
        }
    }
    return _id_PK_ECDH;
}

+ (ASN1ObjectIdentifier *)id_CA {
    static ASN1ObjectIdentifier *_id_CA = nil;
    @synchronized(self) {
        if (!_id_CA) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bsi_de] branch:@"2.2.3"] retain];
            }
            _id_CA = [branchObj retain];
        }
    }
    return _id_CA;
}

+ (ASN1ObjectIdentifier *)id_CA_DH {
    static ASN1ObjectIdentifier *_id_CA_DH = nil;
    @synchronized(self) {
        if (!_id_CA_DH) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_CA] branch:@"1"] retain];
            }
            _id_CA_DH = [branchObj retain];
        }
    }
    return _id_CA_DH;
}

+ (ASN1ObjectIdentifier *)id_CA_DH_3DES_CBC_CBC {
    static ASN1ObjectIdentifier *_id_CA_DH_3DES_CBC_CBC = nil;
    @synchronized(self) {
        if (!_id_CA_DH_3DES_CBC_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_CA] branch:@"1"] retain];
            }
            _id_CA_DH_3DES_CBC_CBC = [branchObj retain];
        }
    }
    return _id_CA_DH_3DES_CBC_CBC;
}

+ (ASN1ObjectIdentifier *)id_CA_ECDH {
    static ASN1ObjectIdentifier *_id_CA_ECDH = nil;
    @synchronized(self) {
        if (!_id_CA_ECDH) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_CA] branch:@"2"] retain];
            }
            _id_CA_ECDH = [branchObj retain];
        }
    }
    return _id_CA_ECDH;
}

+ (ASN1ObjectIdentifier *)id_CA_ECDH_3DES_CBC_CBC {
    static ASN1ObjectIdentifier *_id_CA_ECDH_3DES_CBC_CBC = nil;
    @synchronized(self) {
        if (!_id_CA_ECDH_3DES_CBC_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_CA] branch:@"1"] retain];
            }
            _id_CA_ECDH_3DES_CBC_CBC = [branchObj retain];
        }
    }
    return _id_CA_ECDH_3DES_CBC_CBC;
}

+ (ASN1ObjectIdentifier *)id_TA {
    static ASN1ObjectIdentifier *_id_TA = nil;
    @synchronized(self) {
        if (!_id_TA) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bsi_de] branch:@"2.2.2"] retain];
            }
            _id_TA = [branchObj retain];
        }
    }
    return _id_TA;
}

+ (ASN1ObjectIdentifier *)id_TA_RSA {
    static ASN1ObjectIdentifier *_id_TA_RSA = nil;
    @synchronized(self) {
        if (!_id_TA_RSA) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_TA] branch:@"1"] retain];
            }
            _id_TA_RSA = [branchObj retain];
        }
    }
    return _id_TA_RSA;
}

+ (ASN1ObjectIdentifier *)id_TA_RSA_v1_5_SHA_1 {
    static ASN1ObjectIdentifier *_id_TA_RSA_v1_5_SHA_1 = nil;
    @synchronized(self) {
        if (!_id_TA_RSA_v1_5_SHA_1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_TA_RSA] branch:@"1"] retain];
            }
            _id_TA_RSA_v1_5_SHA_1 = [branchObj retain];
        }
    }
    return _id_TA_RSA_v1_5_SHA_1;
}

+ (ASN1ObjectIdentifier *)id_TA_RSA_v1_5_SHA_256 {
    static ASN1ObjectIdentifier *_id_TA_RSA_v1_5_SHA_256 = nil;
    @synchronized(self) {
        if (!_id_TA_RSA_v1_5_SHA_256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_TA_RSA] branch:@"2"] retain];
            }
            _id_TA_RSA_v1_5_SHA_256 = [branchObj retain];
        }
    }
    return _id_TA_RSA_v1_5_SHA_256;
}

+ (ASN1ObjectIdentifier *)id_TA_RSA_PSS_SHA_1 {
    static ASN1ObjectIdentifier *_id_TA_RSA_PSS_SHA_1 = nil;
    @synchronized(self) {
        if (!_id_TA_RSA_PSS_SHA_1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_TA_RSA] branch:@"3"] retain];
            }
            _id_TA_RSA_PSS_SHA_1 = [branchObj retain];
        }
    }
    return _id_TA_RSA_PSS_SHA_1;
}

+ (ASN1ObjectIdentifier *)id_TA_RSA_PSS_SHA_256 {
    static ASN1ObjectIdentifier *_id_TA_RSA_PSS_SHA_256 = nil;
    @synchronized(self) {
        if (!_id_TA_RSA_PSS_SHA_256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_TA_RSA] branch:@"4"] retain];
            }
            _id_TA_RSA_PSS_SHA_256 = [branchObj retain];
        }
    }
    return _id_TA_RSA_PSS_SHA_256;
}

+ (ASN1ObjectIdentifier *)id_TA_RSA_v1_5_SHA_512 {
    static ASN1ObjectIdentifier *_id_TA_RSA_v1_5_SHA_512 = nil;
    @synchronized(self) {
        if (!_id_TA_RSA_v1_5_SHA_512) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_TA_RSA] branch:@"5"] retain];
            }
            _id_TA_RSA_v1_5_SHA_512 = [branchObj retain];
        }
    }
    return _id_TA_RSA_v1_5_SHA_512;
}

+ (ASN1ObjectIdentifier *)id_TA_RSA_PSS_SHA_512 {
    static ASN1ObjectIdentifier *_id_TA_RSA_PSS_SHA_512 = nil;
    @synchronized(self) {
        if (!_id_TA_RSA_PSS_SHA_512) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_TA_RSA] branch:@"6"] retain];
            }
            _id_TA_RSA_PSS_SHA_512 = [branchObj retain];
        }
    }
    return _id_TA_RSA_PSS_SHA_512;
}

+ (ASN1ObjectIdentifier *)id_TA_ECDSA {
    static ASN1ObjectIdentifier *_id_TA_ECDSA = nil;
    @synchronized(self) {
        if (!_id_TA_ECDSA) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_TA] branch:@"2"] retain];
            }
            _id_TA_ECDSA = [branchObj retain];
        }
    }
    return _id_TA_ECDSA;
}

+ (ASN1ObjectIdentifier *)id_TA_ECDSA_SHA_1 {
    static ASN1ObjectIdentifier *_id_TA_ECDSA_SHA_1 = nil;
    @synchronized(self) {
        if (!_id_TA_ECDSA_SHA_1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_TA_ECDSA] branch:@"1"] retain];
            }
            _id_TA_ECDSA_SHA_1 = [branchObj retain];
        }
    }
    return _id_TA_ECDSA_SHA_1;
}

+ (ASN1ObjectIdentifier *)id_TA_ECDSA_SHA_224 {
    static ASN1ObjectIdentifier *_id_TA_ECDSA_SHA_224 = nil;
    @synchronized(self) {
        if (!_id_TA_ECDSA_SHA_224) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_TA_ECDSA] branch:@"2"] retain];
            }
            _id_TA_ECDSA_SHA_224 = [branchObj retain];
        }
    }
    return _id_TA_ECDSA_SHA_224;
}

+ (ASN1ObjectIdentifier *)id_TA_ECDSA_SHA_256 {
    static ASN1ObjectIdentifier *_id_TA_ECDSA_SHA_256 = nil;
    @synchronized(self) {
        if (!_id_TA_ECDSA_SHA_256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_TA_ECDSA] branch:@"3"] retain];
            }
            _id_TA_ECDSA_SHA_256 = [branchObj retain];
        }
    }
    return _id_TA_ECDSA_SHA_256;
}

+ (ASN1ObjectIdentifier *)id_TA_ECDSA_SHA_384 {
    static ASN1ObjectIdentifier *_id_TA_ECDSA_SHA_384 = nil;
    @synchronized(self) {
        if (!_id_TA_ECDSA_SHA_384) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_TA_ECDSA] branch:@"4"] retain];
            }
            _id_TA_ECDSA_SHA_384 = [branchObj retain];
        }
    }
    return _id_TA_ECDSA_SHA_384;
}

+ (ASN1ObjectIdentifier *)id_TA_ECDSA_SHA_512 {
    static ASN1ObjectIdentifier *_id_TA_ECDSA_SHA_512 = nil;
    @synchronized(self) {
        if (!_id_TA_ECDSA_SHA_512) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_TA_ECDSA] branch:@"5"] retain];
            }
            _id_TA_ECDSA_SHA_512 = [branchObj retain];
        }
    }
    return _id_TA_ECDSA_SHA_512;
}

+ (ASN1ObjectIdentifier *)id_EAC_ePassport {
    static ASN1ObjectIdentifier *_id_EAC_ePassport = nil;
    @synchronized(self) {
        if (!_id_EAC_ePassport) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bsi_de] branch:@"3.1.2.1"] retain];
            }
            _id_EAC_ePassport = [branchObj retain];
        }
    }
    return _id_EAC_ePassport;
}

@end
