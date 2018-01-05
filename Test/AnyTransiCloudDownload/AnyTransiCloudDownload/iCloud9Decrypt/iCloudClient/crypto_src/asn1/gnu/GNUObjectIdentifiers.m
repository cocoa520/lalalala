//
//  GNUObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "GNUObjectIdentifiers.h"

@implementation GNUObjectIdentifiers

+ (ASN1ObjectIdentifier *)GNU {
    static ASN1ObjectIdentifier *_GNU = nil;
    @synchronized(self) {
        if (!_GNU) {
            _GNU = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.1"];
        }
    }
    return _GNU;
}

+ (ASN1ObjectIdentifier *)GnuPG {
    static ASN1ObjectIdentifier *_GnuPG = nil;
    @synchronized(self) {
        if (!_GnuPG) {
            _GnuPG = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.2"];
        }
    }
    return _GnuPG;
}

+ (ASN1ObjectIdentifier *)notation {
    static ASN1ObjectIdentifier *_notation = nil;
    @synchronized(self) {
        if (!_notation) {
            _notation = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.2.1"];
        }
    }
    return _notation;
}

+ (ASN1ObjectIdentifier *)pkaAddress {
    static ASN1ObjectIdentifier *_pkaAddress = nil;
    @synchronized(self) {
        if (!_pkaAddress) {
            _pkaAddress = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.2.1.1"];
        }
    }
    return _pkaAddress;
}

+ (ASN1ObjectIdentifier *)GnuRadar {
    static ASN1ObjectIdentifier *_GnuRadar = nil;
    @synchronized(self) {
        if (!_GnuRadar) {
            _GnuRadar = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.3"];
        }
    }
    return _GnuRadar;
}

+ (ASN1ObjectIdentifier *)digestAlgorithm {
    static ASN1ObjectIdentifier *_digestAlgorithm = nil;
    @synchronized(self) {
        if (!_digestAlgorithm) {
            _digestAlgorithm = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.12"];
        }
    }
    return _digestAlgorithm;
}

+ (ASN1ObjectIdentifier *)Tiger_192 {
    static ASN1ObjectIdentifier *_Tiger_192 = nil;
    @synchronized(self) {
        if (!_Tiger_192) {
            _Tiger_192 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.12.2"];
        }
    }
    return _Tiger_192;
}

+ (ASN1ObjectIdentifier *)encryptionAlgorithm {
    static ASN1ObjectIdentifier *_encryptionAlgorithm = nil;
    @synchronized(self) {
        if (!_encryptionAlgorithm) {
            _encryptionAlgorithm = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.13"];
        }
    }
    return _encryptionAlgorithm;
}

+ (ASN1ObjectIdentifier *)Serpent {
    static ASN1ObjectIdentifier *_Serpent = nil;
    @synchronized(self) {
        if (!_Serpent) {
            _Serpent = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.13.2"];
        }
    }
    return _Serpent;
}

+ (ASN1ObjectIdentifier *)Serpent_128_ECB {
    static ASN1ObjectIdentifier *_Serpent_128_ECB = nil;
    @synchronized(self) {
        if (!_Serpent_128_ECB) {
            _Serpent_128_ECB = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.13.2.1"];
        }
    }
    return _Serpent_128_ECB;
}

+ (ASN1ObjectIdentifier *)Serpent_128_CBC {
    static ASN1ObjectIdentifier *_Serpent_128_CBC = nil;
    @synchronized(self) {
        if (!_Serpent_128_CBC) {
            _Serpent_128_CBC = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.13.2.2"];
        }
    }
    return _Serpent_128_CBC;
}

+ (ASN1ObjectIdentifier *)Serpent_128_OFB {
    static ASN1ObjectIdentifier *_Serpent_128_OFB = nil;
    @synchronized(self) {
        if (!_Serpent_128_OFB) {
            _Serpent_128_OFB = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.13.2.3"];
        }
    }
    return _Serpent_128_OFB;
}

+ (ASN1ObjectIdentifier *)Serpent_128_CFB {
    static ASN1ObjectIdentifier *_Serpent_128_CFB = nil;
    @synchronized(self) {
        if (!_Serpent_128_CFB) {
            _Serpent_128_CFB = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.13.2.4"];
        }
    }
    return _Serpent_128_CFB;
}

+ (ASN1ObjectIdentifier *)Serpent_192_ECB {
    static ASN1ObjectIdentifier *_Serpent_192_ECB = nil;
    @synchronized(self) {
        if (!_Serpent_192_ECB) {
            _Serpent_192_ECB = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.13.2.21"];
        }
    }
    return _Serpent_192_ECB;
}

+ (ASN1ObjectIdentifier *)Serpent_192_CBC {
    static ASN1ObjectIdentifier *_Serpent_192_CBC = nil;
    @synchronized(self) {
        if (!_Serpent_192_CBC) {
            _Serpent_192_CBC = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.13.2.22"];
        }
    }
    return _Serpent_192_CBC;
}

+ (ASN1ObjectIdentifier *)Serpent_192_OFB {
    static ASN1ObjectIdentifier *_Serpent_192_OFB = nil;
    @synchronized(self) {
        if (!_Serpent_192_OFB) {
            _Serpent_192_OFB = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.13.2.23"];
        }
    }
    return _Serpent_192_OFB;
}

+ (ASN1ObjectIdentifier *)Serpent_192_CFB {
    static ASN1ObjectIdentifier *_Serpent_192_CFB = nil;
    @synchronized(self) {
        if (!_Serpent_192_CFB) {
            _Serpent_192_CFB = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.13.2.24"];
        }
    }
    return _Serpent_192_CFB;
}

+ (ASN1ObjectIdentifier *)Serpent_256_ECB {
    static ASN1ObjectIdentifier *_Serpent_256_ECB = nil;
    @synchronized(self) {
        if (!_Serpent_256_ECB) {
            _Serpent_256_ECB = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.13.2.41"];
        }
    }
    return _Serpent_256_ECB;
}

+ (ASN1ObjectIdentifier *)Serpent_256_CBC {
    static ASN1ObjectIdentifier *_Serpent_256_CBC = nil;
    @synchronized(self) {
        if (!_Serpent_256_CBC) {
            _Serpent_256_CBC = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.13.2.42"];
        }
    }
    return _Serpent_256_CBC;
}

+ (ASN1ObjectIdentifier *)Serpent_256_OFB {
    static ASN1ObjectIdentifier *_Serpent_256_OFB = nil;
    @synchronized(self) {
        if (!_Serpent_256_OFB) {
            _Serpent_256_OFB = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.13.2.43"];
        }
    }
    return _Serpent_256_OFB;
}

+ (ASN1ObjectIdentifier *)Serpent_256_CFB {
    static ASN1ObjectIdentifier *_Serpent_256_CFB = nil;
    @synchronized(self) {
        if (!_Serpent_256_CFB) {
            _Serpent_256_CFB = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.13.2.44"];
        }
    }
    return _Serpent_256_CFB;
}

+ (ASN1ObjectIdentifier *)CRC {
    static ASN1ObjectIdentifier *_CRC = nil;
    @synchronized(self) {
        if (!_CRC) {
            _CRC = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.14"];
        }
    }
    return _CRC;
}

+ (ASN1ObjectIdentifier *)CRC32 {
    static ASN1ObjectIdentifier *_CRC32 = nil;
    @synchronized(self) {
        if (!_CRC32) {
            _CRC32 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.11591.14.1"];
        }
    }
    return _CRC32;
}

@end
