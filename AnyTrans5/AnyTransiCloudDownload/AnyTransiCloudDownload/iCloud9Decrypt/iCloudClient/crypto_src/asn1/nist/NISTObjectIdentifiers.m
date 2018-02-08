//
//  NISTObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "NISTObjectIdentifiers.h"

@implementation NISTObjectIdentifiers

+ (ASN1ObjectIdentifier *)nistAlgorithm {
    static ASN1ObjectIdentifier *_nistAlgorithm = nil;
    @synchronized(self) {
        if (!_nistAlgorithm) {
            _nistAlgorithm = [[ASN1ObjectIdentifier alloc] initParamString:@"2.16.840.1.101.3.4"];
        }
    }
    return _nistAlgorithm;
}

+ (ASN1ObjectIdentifier *)hashAlgs {
    static ASN1ObjectIdentifier *_hashAlgs = nil;
    @synchronized(self) {
        if (!_hashAlgs) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self nistAlgorithm] branch:@"2"] retain];
            }
            _hashAlgs = [branchObj retain];
        }
    }
    return _hashAlgs;
}

+ (ASN1ObjectIdentifier *)id_sha256 {
    static ASN1ObjectIdentifier *_id_sha256 = nil;
    @synchronized(self) {
        if (!_id_sha256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hashAlgs] branch:@"1"] retain];
            }
            _id_sha256 = [branchObj retain];
        }
    }
    return _id_sha256;
}

+ (ASN1ObjectIdentifier *)id_sha384 {
    static ASN1ObjectIdentifier *_id_sha384 = nil;
    @synchronized(self) {
        if (!_id_sha384) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hashAlgs] branch:@"2"] retain];
            }
            _id_sha384 = [branchObj retain];
        }
    }
    return _id_sha384;
}

+ (ASN1ObjectIdentifier *)id_sha512 {
    static ASN1ObjectIdentifier *_id_sha512 = nil;
    @synchronized(self) {
        if (!_id_sha512) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hashAlgs] branch:@"3"] retain];
            }
            _id_sha512 = [branchObj retain];
        }
    }
    return _id_sha512;
}

+ (ASN1ObjectIdentifier *)id_sha224 {
    static ASN1ObjectIdentifier *_id_sha224 = nil;
    @synchronized(self) {
        if (!_id_sha224) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hashAlgs] branch:@"4"] retain];
            }
            _id_sha224 = [branchObj retain];
        }
    }
    return _id_sha224;
}

+ (ASN1ObjectIdentifier *)id_sha512_224 {
    static ASN1ObjectIdentifier *_id_sha512_224 = nil;
    @synchronized(self) {
        if (!_id_sha512_224) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hashAlgs] branch:@"5"] retain];
            }
            _id_sha512_224 = [branchObj retain];
        }
    }
    return _id_sha512_224;
}

+ (ASN1ObjectIdentifier *)id_sha512_256 {
    static ASN1ObjectIdentifier *_id_sha512_256 = nil;
    @synchronized(self) {
        if (!_id_sha512_256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hashAlgs] branch:@"6"] retain];
            }
            _id_sha512_256 = [branchObj retain];
        }
    }
    return _id_sha512_256;
}

+ (ASN1ObjectIdentifier *)id_sha3_224 {
    static ASN1ObjectIdentifier *_id_sha3_224 = nil;
    @synchronized(self) {
        if (!_id_sha3_224) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hashAlgs] branch:@"7"] retain];
            }
            _id_sha3_224 = [branchObj retain];
        }
    }
    return _id_sha3_224;
}

+ (ASN1ObjectIdentifier *)id_sha3_256 {
    static ASN1ObjectIdentifier *_id_sha3_256 = nil;
    @synchronized(self) {
        if (!_id_sha3_256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hashAlgs] branch:@"8"] retain];
            }
            _id_sha3_256 = [branchObj retain];
        }
    }
    return _id_sha3_256;
}

+ (ASN1ObjectIdentifier *)id_sha3_384 {
    static ASN1ObjectIdentifier *_id_sha3_384 = nil;
    @synchronized(self) {
        if (!_id_sha3_384) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hashAlgs] branch:@"9"] retain];
            }
            _id_sha3_384 = [branchObj retain];
        }
    }
    return _id_sha3_384;
}

+ (ASN1ObjectIdentifier *)id_sha3_512 {
    static ASN1ObjectIdentifier *_id_sha3_512 = nil;
    @synchronized(self) {
        if (!_id_sha3_512) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hashAlgs] branch:@"10"] retain];
            }
            _id_sha3_512 = [branchObj retain];
        }
    }
    return _id_sha3_512;
}

+ (ASN1ObjectIdentifier *)id_shake128 {
    static ASN1ObjectIdentifier *_id_shake128 = nil;
    @synchronized(self) {
        if (!_id_shake128) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hashAlgs] branch:@"11"] retain];
            }
            _id_shake128 = [branchObj retain];
        }
    }
    return _id_shake128;
}

+ (ASN1ObjectIdentifier *)id_shake256 {
    static ASN1ObjectIdentifier *_id_shake256 = nil;
    @synchronized(self) {
        if (!_id_shake256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self hashAlgs] branch:@"12"] retain];
            }
            _id_shake256 = [branchObj retain];
        }
    }
    return _id_shake256;
}

+ (ASN1ObjectIdentifier *)aes {
    static ASN1ObjectIdentifier *_aes = nil;
    @synchronized(self) {
        if (!_aes) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self nistAlgorithm] branch:@"1"] retain];
            }
            _aes = [branchObj retain];
        }
    }
    return _aes;
}

+ (ASN1ObjectIdentifier *)id_aes128_ECB {
    static ASN1ObjectIdentifier *_id_aes128_ECB = nil;
    @synchronized(self) {
        if (!_id_aes128_ECB) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"1"] retain];
            }
            _id_aes128_ECB = [branchObj retain];
        }
    }
    return _id_aes128_ECB;
}

+ (ASN1ObjectIdentifier *)id_aes128_CBC {
    static ASN1ObjectIdentifier *_id_aes128_CBC = nil;
    @synchronized(self) {
        if (!_id_aes128_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"2"] retain];
            }
            _id_aes128_CBC = [branchObj retain];
        }
    }
    return _id_aes128_CBC;
}

+ (ASN1ObjectIdentifier *)id_aes128_OFB {
    static ASN1ObjectIdentifier *_id_aes128_OFB = nil;
    @synchronized(self) {
        if (!_id_aes128_OFB) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"3"] retain];
            }
            _id_aes128_OFB = [branchObj retain];
        }
    }
    return _id_aes128_OFB;
}

+ (ASN1ObjectIdentifier *)id_aes128_CFB {
    static ASN1ObjectIdentifier *_id_aes128_CFB = nil;
    @synchronized(self) {
        if (!_id_aes128_CFB) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"4"] retain];
            }
            _id_aes128_CFB = [branchObj retain];
        }
    }
    return _id_aes128_CFB;
}

+ (ASN1ObjectIdentifier *)id_aes128_wrap {
    static ASN1ObjectIdentifier *_id_aes128_wrap = nil;
    @synchronized(self) {
        if (!_id_aes128_wrap) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"5"] retain];
            }
            _id_aes128_wrap = [branchObj retain];
        }
    }
    return _id_aes128_wrap;
}

+ (ASN1ObjectIdentifier *)id_aes128_GCM {
    static ASN1ObjectIdentifier *_id_aes128_GCM = nil;
    @synchronized(self) {
        if (!_id_aes128_GCM) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"6"] retain];
            }
            _id_aes128_GCM = [branchObj retain];
        }
    }
    return _id_aes128_GCM;
}

+ (ASN1ObjectIdentifier *)id_aes128_CCM {
    static ASN1ObjectIdentifier *_id_aes128_CCM = nil;
    @synchronized(self) {
        if (!_id_aes128_CCM) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"7"] retain];
            }
            _id_aes128_CCM = [branchObj retain];
        }
    }
    return _id_aes128_CCM;
}

+ (ASN1ObjectIdentifier *)id_aes192_ECB {
    static ASN1ObjectIdentifier *_id_aes192_ECB = nil;
    @synchronized(self) {
        if (!_id_aes192_ECB) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"21"] retain];
            }
            _id_aes192_ECB = [branchObj retain];
        }
    }
    return _id_aes192_ECB;
}

+ (ASN1ObjectIdentifier *)id_aes192_CBC {
    static ASN1ObjectIdentifier *_id_aes192_CBC = nil;
    @synchronized(self) {
        if (!_id_aes192_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"22"] retain];
            }
            _id_aes192_CBC = [branchObj retain];
        }
    }
    return _id_aes192_CBC;
}

+ (ASN1ObjectIdentifier *)id_aes192_OFB {
    static ASN1ObjectIdentifier *_id_aes192_OFB = nil;
    @synchronized(self) {
        if (!_id_aes192_OFB) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"23"] retain];
            }
            _id_aes192_OFB = [branchObj retain];
        }
    }
    return _id_aes192_OFB;
}

+ (ASN1ObjectIdentifier *)id_aes192_CFB {
    static ASN1ObjectIdentifier *_id_aes192_CFB = nil;
    @synchronized(self) {
        if (!_id_aes192_CFB) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"24"] retain];
            }
            _id_aes192_CFB = [branchObj retain];
        }
    }
    return _id_aes192_CFB;
}

+ (ASN1ObjectIdentifier *)id_aes192_wrap {
    static ASN1ObjectIdentifier *_id_aes192_wrap = nil;
    @synchronized(self) {
        if (!_id_aes192_wrap) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"25"] retain];
            }
            _id_aes192_wrap = [branchObj retain];
        }
    }
    return _id_aes192_wrap;
}

+ (ASN1ObjectIdentifier *)id_aes192_GCM {
    static ASN1ObjectIdentifier *_id_aes192_GCM = nil;
    @synchronized(self) {
        if (!_id_aes192_GCM) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"26"] retain];
            }
            _id_aes192_GCM = [branchObj retain];
        }
    }
    return _id_aes192_GCM;
}

+ (ASN1ObjectIdentifier *)id_aes192_CCM {
    static ASN1ObjectIdentifier *_id_aes192_CCM = nil;
    @synchronized(self) {
        if (!_id_aes192_CCM) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"27"] retain];
            }
            _id_aes192_CCM = [branchObj retain];
        }
    }
    return _id_aes192_CCM;
}

+ (ASN1ObjectIdentifier *)id_aes256_ECB {
    static ASN1ObjectIdentifier *_id_aes256_ECB = nil;
    @synchronized(self) {
        if (!_id_aes256_ECB) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"41"] retain];
            }
            _id_aes256_ECB = [branchObj retain];
        }
    }
    return _id_aes256_ECB;
}

+ (ASN1ObjectIdentifier *)id_aes256_CBC {
    static ASN1ObjectIdentifier *_id_aes256_CBC = nil;
    @synchronized(self) {
        if (!_id_aes256_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"42"] retain];
            }
            _id_aes256_CBC = [branchObj retain];
        }
    }
    return _id_aes256_CBC;
}

+ (ASN1ObjectIdentifier *)id_aes256_OFB {
    static ASN1ObjectIdentifier *_id_aes256_OFB = nil;
    @synchronized(self) {
        if (!_id_aes256_OFB) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"43"] retain];
            }
            _id_aes256_OFB = [branchObj retain];
        }
    }
    return _id_aes256_OFB;
}

+ (ASN1ObjectIdentifier *)id_aes256_CFB {
    static ASN1ObjectIdentifier *_id_aes256_CFB = nil;
    @synchronized(self) {
        if (!_id_aes256_CFB) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"44"] retain];
            }
            _id_aes256_CFB = [branchObj retain];
        }
    }
    return _id_aes256_CFB;
}

+ (ASN1ObjectIdentifier *)id_aes256_wrap {
    static ASN1ObjectIdentifier *_id_aes256_wrap = nil;
    @synchronized(self) {
        if (!_id_aes256_wrap) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"45"] retain];
            }
            _id_aes256_wrap = [branchObj retain];
        }
    }
    return _id_aes256_wrap;
}

+ (ASN1ObjectIdentifier *)id_aes256_GCM {
    static ASN1ObjectIdentifier *_id_aes256_GCM = nil;
    @synchronized(self) {
        if (!_id_aes256_GCM) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"46"] retain];
            }
            _id_aes256_GCM = [branchObj retain];
        }
    }
    return _id_aes256_GCM;
}

+ (ASN1ObjectIdentifier *)id_aes256_CCM {
    static ASN1ObjectIdentifier *_id_aes256_CCM = nil;
    @synchronized(self) {
        if (!_id_aes256_CCM) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self aes] branch:@"47"] retain];
            }
            _id_aes256_CCM = [branchObj retain];
        }
    }
    return _id_aes256_CCM;
}

+ (ASN1ObjectIdentifier *)id_dsa_with_sha2 {
    static ASN1ObjectIdentifier *_id_dsa_with_sha2 = nil;
    @synchronized(self) {
        if (!_id_dsa_with_sha2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self nistAlgorithm] branch:@"3"] retain];
            }
            _id_dsa_with_sha2 = [branchObj retain];
        }
    }
    return _id_dsa_with_sha2;
}

+ (ASN1ObjectIdentifier *)dsa_with_sha224 {
    static ASN1ObjectIdentifier *_dsa_with_sha224 = nil;
    @synchronized(self) {
        if (!_dsa_with_sha224) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_dsa_with_sha2] branch:@"1"] retain];
            }
            _dsa_with_sha224 = [branchObj retain];
        }
    }
    return _dsa_with_sha224;
}

+ (ASN1ObjectIdentifier *)dsa_with_sha256 {
    static ASN1ObjectIdentifier *_dsa_with_sha256 = nil;
    @synchronized(self) {
        if (!_dsa_with_sha256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_dsa_with_sha2] branch:@"2"] retain];
            }
            _dsa_with_sha256 = [branchObj retain];
        }
    }
    return _dsa_with_sha256;
}

+ (ASN1ObjectIdentifier *)dsa_with_sha384 {
    static ASN1ObjectIdentifier *_dsa_with_sha384 = nil;
    @synchronized(self) {
        if (!_dsa_with_sha384) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_dsa_with_sha2] branch:@"3"] retain];
            }
            _dsa_with_sha384 = [branchObj retain];
        }
    }
    return _dsa_with_sha384;
}

+ (ASN1ObjectIdentifier *)dsa_with_sha512 {
    static ASN1ObjectIdentifier *_dsa_with_sha512 = nil;
    @synchronized(self) {
        if (!_dsa_with_sha512) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_dsa_with_sha2] branch:@"4"] retain];
            }
            _dsa_with_sha512 = [branchObj retain];
        }
    }
    return _dsa_with_sha512;
}

@end
