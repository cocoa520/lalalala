//
//  OIWObjectIdentifier.m
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OIWObjectIdentifier.h"

@implementation OIWObjectIdentifier

+ (ASN1ObjectIdentifier *)md4WithRSA {
    static ASN1ObjectIdentifier *_md4WithRSA = nil;
    @synchronized(self) {
        if (!_md4WithRSA) {
            _md4WithRSA = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.14.3.2.2"];
        }
    }
    return _md4WithRSA;
}

+ (ASN1ObjectIdentifier *)md5WithRSA {
    static ASN1ObjectIdentifier *_md5WithRSA = nil;
    @synchronized(self) {
        if (!_md5WithRSA) {
            _md5WithRSA = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.14.3.2.3"];
        }
    }
    return _md5WithRSA;
}

+ (ASN1ObjectIdentifier *)md4WithRSAEncryption {
    static ASN1ObjectIdentifier *_md4WithRSAEncryption = nil;
    @synchronized(self) {
        if (!_md4WithRSAEncryption) {
            _md4WithRSAEncryption = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.14.3.2.4"];
        }
    }
    return _md4WithRSAEncryption;
}

+ (ASN1ObjectIdentifier *)desECB {
    static ASN1ObjectIdentifier *_desECB = nil;
    @synchronized(self) {
        if (!_desECB) {
            _desECB = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.14.3.2.6"];
        }
    }
    return _desECB;
}

+ (ASN1ObjectIdentifier *)desCBC {
    static ASN1ObjectIdentifier *_desCBC = nil;
    @synchronized(self) {
        if (!_desCBC) {
            _desCBC = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.14.3.2.7"];
        }
    }
    return _desCBC;

}

+ (ASN1ObjectIdentifier *)desOFB {
    static ASN1ObjectIdentifier *_desOFB = nil;
    @synchronized(self) {
        if (!_desOFB) {
            _desOFB = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.14.3.2.8"];
        }
    }
    return _desOFB;
}

+ (ASN1ObjectIdentifier *)desCFB {
    static ASN1ObjectIdentifier *_desCFB = nil;
    @synchronized(self) {
        if (!_desCFB) {
            _desCFB = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.14.3.2.9"];
        }
    }
    return _desCFB;
}

+ (ASN1ObjectIdentifier *)desEDE {
    static ASN1ObjectIdentifier *_desEDE = nil;
    @synchronized(self) {
        if (!_desEDE) {
            _desEDE = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.14.3.2.17"];
        }
    }
    return _desEDE;
}

+ (ASN1ObjectIdentifier *)idSHA1 {
    static ASN1ObjectIdentifier *_idSHA1 = nil;
    @synchronized(self) {
        if (!_idSHA1) {
            _idSHA1 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.14.3.2.26"];
        }
    }
    return _idSHA1;
}

+ (ASN1ObjectIdentifier *)dsaWithSHA1 {
    static ASN1ObjectIdentifier *_dsaWithSHA1 = nil;
    @synchronized(self) {
        if (!_dsaWithSHA1) {
            _dsaWithSHA1 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.14.3.2.27"];
        }
    }
    return _dsaWithSHA1;
}

+ (ASN1ObjectIdentifier *)sha1WithRSA {
    static ASN1ObjectIdentifier *_sha1WithRSA = nil;
    @synchronized(self) {
        if (!_sha1WithRSA) {
            _sha1WithRSA = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.14.3.2.29"];
        }
    }
    return _sha1WithRSA;
}

+ (ASN1ObjectIdentifier *)elGamalAlgorithm {
    static ASN1ObjectIdentifier *_elGamalAlgorithm = nil;
    @synchronized(self) {
        if (!_elGamalAlgorithm) {
            _elGamalAlgorithm = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.14.7.2.1.1"];
        }
    }
    return _elGamalAlgorithm;
}


@end
