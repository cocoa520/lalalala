//
//  BCObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BCObjectIdentifiers.h"

@implementation BCObjectIdentifiers

+ (ASN1ObjectIdentifier *)bc {
    static ASN1ObjectIdentifier *_bc = nil;
    @synchronized(self) {
        if (!_bc) {
            _bc = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.22554"];
        }
    }
    return _bc;
}

+ (ASN1ObjectIdentifier *)bc_pbe {
    static ASN1ObjectIdentifier *_bc_pbe = nil;
    @synchronized(self) {
        if (!_bc_pbe) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc] branch:@"1"] retain];
            }
            _bc_pbe = [branchObj retain];
        }
    }
    return _bc_pbe;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha1 {
    static ASN1ObjectIdentifier *_bc_pbe_sha1 = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe] branch:@"1"] retain];
            }
            _bc_pbe_sha1 = [branchObj retain];
        }
    }
    return _bc_pbe_sha1;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha256 {
    static ASN1ObjectIdentifier *_bc_pbe_sha256 = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe] branch:@"2.1"] retain];
            }
            _bc_pbe_sha256 = [branchObj retain];
        }
    }
    return _bc_pbe_sha256;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha384 {
    static ASN1ObjectIdentifier *_bc_pbe_sha384 = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha384) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe] branch:@"2.2"] retain];
            }
            _bc_pbe_sha384 = [branchObj retain];
        }
    }
    return _bc_pbe_sha384;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha512 {
    static ASN1ObjectIdentifier *_bc_pbe_sha512 = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha512) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe] branch:@"2.3"] retain];
            }
            _bc_pbe_sha512 = [branchObj retain];
        }
    }
    return _bc_pbe_sha512;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha224 {
    static ASN1ObjectIdentifier *_bc_pbe_sha224 = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha224) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe] branch:@"2.4"] retain];
            }
            _bc_pbe_sha224 = [branchObj retain];
        }
    }
    return _bc_pbe_sha224;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha1_pkcs5 {
    static ASN1ObjectIdentifier *_bc_pbe_sha1_pkcs5 = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha1_pkcs5) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe_sha1] branch:@"1"] retain];
            }
            _bc_pbe_sha1_pkcs5 = [branchObj retain];
        }
    }
    return _bc_pbe_sha1_pkcs5;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha1_pkcs12 {
    static ASN1ObjectIdentifier *_bc_pbe_sha1_pkcs12 = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha1_pkcs12) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe_sha1] branch:@"2"] retain];
            }
            _bc_pbe_sha1_pkcs12 = [branchObj retain];
        }
    }
    return _bc_pbe_sha1_pkcs12;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha256_pkcs5 {
    static ASN1ObjectIdentifier *_bc_pbe_sha256_pkcs5 = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha256_pkcs5) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe_sha256] branch:@"1"] retain];
            }
            _bc_pbe_sha256_pkcs5 = [branchObj retain];
        }
    }
    return _bc_pbe_sha256_pkcs5;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha256_pkcs12 {
    static ASN1ObjectIdentifier *_bc_pbe_sha256_pkcs12 = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha256_pkcs12) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe_sha256] branch:@"2"] retain];
            }
            _bc_pbe_sha256_pkcs12 = [branchObj retain];
        }
    }
    return _bc_pbe_sha256_pkcs12;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha1_pkcs12_aes128_cbc {
    static ASN1ObjectIdentifier *_bc_pbe_sha1_pkcs12_aes128_cbc = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha1_pkcs12_aes128_cbc) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe_sha1_pkcs12] branch:@"1.2"] retain];
            }
            _bc_pbe_sha1_pkcs12_aes128_cbc = [branchObj retain];
        }
    }
    return _bc_pbe_sha1_pkcs12_aes128_cbc;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha1_pkcs12_aes192_cbc {
    static ASN1ObjectIdentifier *_bc_pbe_sha1_pkcs12_aes192_cbc = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha1_pkcs12_aes192_cbc) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe_sha1_pkcs12] branch:@"1.22"] retain];
            }
            _bc_pbe_sha1_pkcs12_aes192_cbc = [branchObj retain];
        }
    }
    return _bc_pbe_sha1_pkcs12_aes192_cbc;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha1_pkcs12_aes256_cbc {
    static ASN1ObjectIdentifier *_bc_pbe_sha1_pkcs12_aes256_cbc = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha1_pkcs12_aes256_cbc) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe_sha1_pkcs12] branch:@"1.42"] retain];
            }
            _bc_pbe_sha1_pkcs12_aes256_cbc = [branchObj retain];
        }
    }
    return _bc_pbe_sha1_pkcs12_aes256_cbc;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha256_pkcs12_aes128_cbc {
    static ASN1ObjectIdentifier *_bc_pbe_sha256_pkcs12_aes128_cbc = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha256_pkcs12_aes128_cbc) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe_sha256_pkcs12] branch:@"1.2"] retain];
            }
            _bc_pbe_sha256_pkcs12_aes128_cbc = [branchObj retain];
        }
    }
    return _bc_pbe_sha256_pkcs12_aes128_cbc;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha256_pkcs12_aes192_cbc {
    static ASN1ObjectIdentifier *_bc_pbe_sha256_pkcs12_aes192_cbc = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha256_pkcs12_aes192_cbc) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe_sha256_pkcs12] branch:@"1.22"] retain];
            }
            _bc_pbe_sha256_pkcs12_aes192_cbc = [branchObj retain];
        }
    }
    return _bc_pbe_sha256_pkcs12_aes192_cbc;
}

+ (ASN1ObjectIdentifier *)bc_pbe_sha256_pkcs12_aes256_cbc {
    static ASN1ObjectIdentifier *_bc_pbe_sha256_pkcs12_aes256_cbc = nil;
    @synchronized(self) {
        if (!_bc_pbe_sha256_pkcs12_aes256_cbc) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bc_pbe_sha256_pkcs12] branch:@"1.42"] retain];
            }
            _bc_pbe_sha256_pkcs12_aes256_cbc = [branchObj retain];
        }
    }
    return _bc_pbe_sha256_pkcs12_aes256_cbc;
}

@end
